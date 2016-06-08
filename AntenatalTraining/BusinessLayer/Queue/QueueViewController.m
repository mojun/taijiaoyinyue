//
//  QueueViewController.m
//  AntenatalTraining
//
//  Created by mo jun on 5/7/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "QueueViewController.h"
#import "PZProgressBar.h"
#import <StreamingKit/STKAudioPlayer.h>
#import <MediaPlayer/MediaPlayer.h>
#import "QueueBarView.h"
#import "NSString+Extension.h"
#import "ATImageEntity.h"
#import "FICImageHelper.h"
#import "MusicModel.h"
#import <AVFoundation/AVFoundation.h>

@interface QueueViewController ()<STKAudioPlayerDelegate> {
    NSMutableArray      *_queueList;
    
    NSUInteger          _currentPlayIndex;
    
    STKAudioPlayer      *_audioPlayer;
    
    /// 高斯模糊背景hXh
    UIImageView         *_blurBgView;
    
    /// 大封面
    UIImageView         *_coverImageView;
    
    /// placeholder image
    UIImageView         *_placeholderImageView;
    
    NSTimer             *_progressTimer;
    
    PZProgressBar       *_fullQueueProgressBar;
    
    /// 播放时间
    UILabel             *_passedTimeLabel;
    
    /// 剩余时间
    UILabel             *_leftTimeLabel;
    
    /// 歌曲名称
    UILabel        *_songTitleLabel;
    
    UIButton            *_playPauseButton;
    
    UIButton            *_prevButton;
    
    UIButton            *_nextButton;
    
    UIButton            *_minVolumeButton;
    
    UIButton            *_maxVolumeButton;
    
    BOOL _isPlaying;
    
}

@end

@implementation QueueViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        _isPlaying = NO;
        _audioPlayer = [[STKAudioPlayer alloc] init];
        _audioPlayer.delegate = self;
        _queueList = [NSMutableArray array];
        
        __weak __typeof(&*self)weakSelf = self;
        MPRemoteCommandCenter *center = [MPRemoteCommandCenter sharedCommandCenter];
        center.pauseCommand.enabled = YES;
        [center.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            NSLog(@"pause");
            [weakSelf actionPlayPause:nil];
            return MPRemoteCommandHandlerStatusSuccess;
        }];
        
        center.playCommand.enabled = YES;
        [center.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            NSLog(@"play");
            [weakSelf actionPlayPause:nil];
            return MPRemoteCommandHandlerStatusSuccess;
        }];
        
        [center.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            NSLog(@"next");
            [weakSelf actionNext:nil];
            return MPRemoteCommandHandlerStatusSuccess;
        }];
        
        [center.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            NSLog(@"prev");
            [weakSelf actionPrev:nil];
            return MPRemoteCommandHandlerStatusSuccess;
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMediaNotification:) name:kPlayMediaNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak __typeof(&*self)weakSelf = self;
    UIView *blackView = [UIView new];
    blackView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight + kQueueBarFooterHeight);
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    
    /// 高斯背景
    _blurBgView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - kScreenHeight - kQueueBarFooterHeight) * 0.5f, 0, kScreenHeight + kQueueBarFooterHeight, kScreenHeight + kQueueBarFooterHeight)];
    _blurBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_blurBgView];
    
    CGFloat circleSize = 110;
    _coverImageView = [UIImageView new];
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    _coverImageView.backgroundColor = [UIColor clearColor];
    _coverImageView.layer.cornerRadius = circleSize * 0.5f;
    _coverImageView.layer.masksToBounds = YES;
    [self.view addSubview:_coverImageView];
    _coverImageView.frame = CGRectMake((kScreenWidth - circleSize) * 0.5f, (kScreenWidth - circleSize) * 0.5f, circleSize, circleSize);
    
    _placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    _placeholderImageView.image = [UIImage imageNamed:@"icon_shared_defaultcover_black"];
    [self.view addSubview:_placeholderImageView];
    [_blurBgView setImageViewToBlurWithImage:_placeholderImageView.image andBlurRadius:50 completionBlock:nil];
    
    _queueBar.coverImageView.image = [UIImage imageNamed:@"icon_shared_defaultcover50_gray"];
    
    UIView *controlContainer = [UIView new];
    controlContainer.frame = CGRectMake(0, kScreenWidth, kScreenWidth, kScreenHeight - kScreenWidth);
    controlContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:controlContainer];
    
    UIView *maskBlackView = [UIView new];
    [controlContainer addSubview:maskBlackView];
    CGRect maskFrame = controlContainer.bounds;
    maskFrame.size.height += kQueueBarFooterHeight;
    maskBlackView.frame = maskFrame;
    maskBlackView.backgroundColor = [UIColor blackColor];
    maskBlackView.alpha = 0.25;
    
    _passedTimeLabel = [UILabel new];
    [controlContainer addSubview:_passedTimeLabel];
    _passedTimeLabel.frame = CGRectMake(kQueueLeftTimeLabelLeftSpace * kQueueHRatio, kQueueLeftTimeLabelTopSpace * kQueueVRatio, kQueueLeftTimeLabelWidth, kQueueLeftTimeLabelHeight);
    _passedTimeLabel.textAlignment = NSTextAlignmentLeft;
    _passedTimeLabel.font = [UIFont systemFontOfSize:10];
    _passedTimeLabel.textColor = kQueueLabelColor;
    _passedTimeLabel.text = @"0:00";
    
    _leftTimeLabel = [UILabel new];
    [controlContainer addSubview:_leftTimeLabel];
    _leftTimeLabel.frame = CGRectMake(kScreenWidth - kQueueRightTimeLabelRightSpace * kQueueHRatio - kQueueRightTimeLabelWidth, kQueueRightTimeLabelTopSpace * kQueueVRatio, kQueueRightTimeLabelWidth, kQueueRightTimeLabelHeight);
    _leftTimeLabel.textAlignment = NSTextAlignmentRight;
    _leftTimeLabel.font = [UIFont systemFontOfSize:10];
    _leftTimeLabel.textColor = kQueueLabelColor;
    _leftTimeLabel.text = @"-0:00";
    
    _songTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _leftTimeLabel.frameBottom + kQueueTitleLabelTopSpace * kQueueVRatio, kScreenWidth, kQueueTitleLabelHeight)];
    [controlContainer addSubview:_songTitleLabel];
    _songTitleLabel.textAlignment = NSTextAlignmentCenter;
    _songTitleLabel.textColor = kQueueLabelColor;
    _songTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    //    _songTitleLabel.text = @"_subTitleLabel.frame = CGRectMake(0, _songTitleLabel.frameBottom + kQueueSubTitleLabelTopSpace * kQueueVRatio, ";
    
    _playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playPauseButton setImage:[UIImage imageNamed:@"btn_queue_play"] forState:UIControlStateNormal];
    [_playPauseButton setImage:[UIImage imageNamed:@"btn_queue_pause"] forState:UIControlStateSelected];
    [controlContainer addSubview:_playPauseButton];
    _playPauseButton.frame = CGRectMake((kScreenWidth - kQueueControlButtonWidth) * 0.5f, _songTitleLabel.frameBottom + kQueueControlButtonTopSpace * kQueueVRatio, kQueueControlButtonWidth, kQueueControlButtonHeight);
    [_playPauseButton addTarget:self action:@selector(actionPlayPause:) forControlEvents:UIControlEventTouchUpInside];
    [_queueBar setPlayPauseBlock:^{
        [weakSelf actionPlayPause:nil];
    }];
    
    _prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_prevButton setImage:[UIImage imageNamed:@"btn_queue_previous"] forState:UIControlStateNormal];
    [controlContainer addSubview:_prevButton];
    _prevButton.frame = CGRectMake(_playPauseButton.frameX - kQueueControlButtonWidth - kQueueControlButtonHInnerSpace * kQueueHRatio, _playPauseButton.frameY, kQueueControlButtonWidth, kQueueControlButtonHeight);
    [_prevButton addTarget:self action:@selector(actionPrev:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setImage:[UIImage imageNamed:@"btn_queue_next"] forState:UIControlStateNormal];
    [controlContainer addSubview:_nextButton];
    _nextButton.frame = CGRectMake(_playPauseButton.frameX + kQueueControlButtonWidth + kQueueControlButtonHInnerSpace * kQueueHRatio, _playPauseButton.frameY, kQueueControlButtonWidth, kQueueControlButtonHeight);
    [_nextButton addTarget:self action:@selector(actionNext:) forControlEvents:UIControlEventTouchUpInside];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc]initWithFrame:CGRectMake(kQueueVolumeBarHOuterSpace * kQueueHRatio, _playPauseButton.frameBottom + kQueueVolumeBarTopSpace * kQueueVRatio, kScreenWidth - kQueueVolumeBarHOuterSpace * kQueueHRatio * 2, kQueueVolumeBarHeight)];
    [controlContainer addSubview:volumeView];
    
    UIImage *volumeMaxImage = [UIImage imageNamed:@"tab_queue_volume_right"];
    UIImage *volumeMinImage = [UIImage imageNamed:@"tab_queue_volume_left"];
    UIImage *volumeHandlerImage = [UIImage imageNamed:@"tab_queue_volume_handler"];
    [volumeView setMaximumVolumeSliderImage:volumeMaxImage forState:UIControlStateNormal];
    [volumeView setMaximumVolumeSliderImage:volumeMaxImage forState:UIControlStateHighlighted];
    [volumeView setMaximumVolumeSliderImage:volumeMaxImage forState:UIControlStateDisabled];
    
    [volumeView setMinimumVolumeSliderImage:volumeMinImage forState:UIControlStateNormal];
    [volumeView setMinimumVolumeSliderImage:volumeMinImage forState:UIControlStateHighlighted];
    [volumeView setMinimumVolumeSliderImage:volumeMinImage forState:UIControlStateDisabled];
    
    [volumeView setVolumeThumbImage:volumeHandlerImage forState:UIControlStateNormal];
    [volumeView setVolumeThumbImage:volumeHandlerImage forState:UIControlStateHighlighted];
    [volumeView setVolumeThumbImage:volumeHandlerImage forState:UIControlStateDisabled];
    
    UISlider *volumeSlider = nil;
    for (UIView *v in volumeView.subviews) {
        if ([v isKindOfClass:[UISlider class]]) {
            volumeSlider = (UISlider *)v;
            break;
        }
    }
//    [volumeSlider setValue:[DOUAudioStreamer volume] animated:NO];
    [volumeSlider addTarget:self action:@selector(volumeChanged:) forControlEvents:UIControlEventValueChanged];
    
    CGFloat sliderHeight = CGRectGetHeight(volumeView.frame);
    
    _minVolumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_minVolumeButton setImage:[UIImage imageNamed:@"btn_queue_volume_min"] forState:UIControlStateNormal];
    [controlContainer addSubview:_minVolumeButton];
    _minVolumeButton.frame = CGRectMake(volumeView.frameX - kQueueVolumeHSpace - kQueueVolumeButtonSize , CGRectGetMinY(volumeView.frame) + (sliderHeight - kQueueVolumeButtonSize) * 0.5f, kQueueVolumeButtonSize, kQueueVolumeButtonSize);
    
    _maxVolumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_maxVolumeButton setImage:[UIImage imageNamed:@"btn_queue_volume_max"] forState:UIControlStateNormal];
    [controlContainer addSubview:_maxVolumeButton];
    _maxVolumeButton.frame = CGRectMake(volumeView.frameX + volumeView.frameWidth + kQueueVolumeHSpace, CGRectGetMinY(volumeView.frame) + (sliderHeight - kQueueVolumeButtonSize) * 0.5f, kQueueVolumeButtonSize, kQueueVolumeButtonSize);
    
    _fullQueueProgressBar = [PZProgressBar new];
    [self.view addSubview:_fullQueueProgressBar];
    _fullQueueProgressBar.frame = CGRectMake(0, kScreenWidth, kScreenWidth, 38);
    
    [_fullQueueProgressBar setPanBegin:^{
        
    }];
    
    [_fullQueueProgressBar setPanChanged:^(CGFloat progress) {
        [weakSelf seekPlayTime:progress];
    }];
    
    [self _updateControlIsPlaying:_isPlaying];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helpers
- (void)changeCoverImage:(UIImage *)image{
    _coverImageView.image = image;
    _queueBar.coverImageView.image = image;
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setFillMode:kCAFillModeForwards];
    [animation setType:kCATransitionFade];
    [animation setSubtype:kCATransitionFromLeft];
    [_coverImageView.layer addAnimation:animation forKey:@"changeCoverImage"];
    [_queueBar.coverImageView.layer addAnimation:animation forKey:@"changeBarCoverImage"];
    
    __weak UIImageView *weakImageView = _blurBgView;
    [_blurBgView setImageViewToBlurWithImage:image andBlurRadius:50 completionBlock:^(NSError *error) {
        if (error == nil) {
            [weakImageView.layer addAnimation:animation forKey:@"changeBGCoverImage"];
        }
    }];
    
    __weak UIImageView *weakBgCoverImageView = _queueBar.bgCoverImageView;
    [_queueBar.bgCoverImageView setImageViewToBlurWithImage:image andBlurRadius:50 completionBlock:^(NSError *error) {
        if (error == nil) {
            [weakBgCoverImageView.layer addAnimation:animation forKey:@"changeQueueBDCoverImage"];
        }
    }];
}

- (void)_updateControlIsPlaying:(BOOL)isPlaying{
    if (isPlaying == _isPlaying) {
        return;
    }
    _queueBar.isPlaying = isPlaying;
    _playPauseButton.selected = isPlaying;
    _isPlaying = isPlaying;
    if (_isPlaying) {
        CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
        monkeyAnimation.duration = 1.5f;
        monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        monkeyAnimation.cumulative = NO;
        monkeyAnimation.removedOnCompletion = NO; //No Remove
        
        monkeyAnimation.repeatCount = FLT_MAX;
        [_coverImageView.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
        _coverImageView.layer.speed = 0.2;
        _coverImageView.layer.beginTime = 0.0;
    } else {
        CFTimeInterval pausedTime = [_coverImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        _coverImageView.layer.speed = 0.0;
        _coverImageView.layer.timeOffset = pausedTime;
        [_coverImageView.layer removeAnimationForKey:@"AnimatedKey"];
    }
}

- (void)_startTimer {
    
    if (_progressTimer) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
    
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(_timerAction:)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - notification
- (void)playMediaNotification:(NSNotification *)notification {
    
    
    [self _updateControlIsPlaying:YES];
    id obj = notification.object;
    NSDictionary *dictionary = obj;
    NSArray *songs = [dictionary objectForKey:@"songs"];
    NSInteger offset = [[dictionary objectForKey:@"offset"] integerValue];
    PlayAction action = (PlayAction)[[dictionary objectForKey:@"action"] integerValue];
    if (action == PlayActionNow) {
        [_queueList removeAllObjects];
        [_queueList addObjectsFromArray:songs];
        _currentPlayIndex = offset;
        [self resetStreamer];
        [self _startTimer];
    } else {
        [_queueList addObjectsFromArray:songs];
    }
    
    
}

#pragma mark - Streamer
- (void)cancelStreamer{
    if (_audioPlayer != nil) {
        [_audioPlayer pause];
    }
}

- (void)resetStreamer{
    [self cancelStreamer];
    
    if (_queueList.count == 0) {
        NSLog(@"没有歌曲");
    } else {
        
        MusicModel *object = [_queueList objectAtIndex:_currentPlayIndex];
        [_audioPlayer playURL:[object audioFileURL] withQueueItemID:object];
    }
}

- (void)updateControl
{
    STKAudioPlayerState state = _audioPlayer.state;
    NSLog(@"status: %@", @(state));
    if (state == STKAudioPlayerStatePlaying) {
        [self _updateControlIsPlaying:YES];
    } else if (state == STKAudioPlayerStatePaused) {
        [self _updateControlIsPlaying:NO];
    } else if (state == STKAudioPlayerStateStopped) {
        [self actionNext:nil];
    } else if (state == STKAudioPlayerStateError){
        [self actionStop:nil];
    }
}

- (void)actionPlayPause:(id)sender
{
    [self _updateControlIsPlaying:!_isPlaying];
    if (_audioPlayer.state == STKAudioPlayerStatePaused) {
        [_audioPlayer resume];
        [self _startTimer];
    } else {
        [_audioPlayer pause];
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
    
}

- (void)actionNext:(id)sender
{
    
    if (_currentPlayIndex - 1 >= [_queueList count]) {
//        __weak __typeof(&*self)weakSelf = self;
//        [[Pandora api]fetchSongsForStation:_station callback:^(BOOL suc) {
//            [weakSelf fetchStationSongsHandler:suc];
//        }];
    }
    
    if (++_currentPlayIndex >= [_queueList count]) {
        _currentPlayIndex = 0;
    }
    
    [self resetStreamer];
}

- (void)actionPrev:(id)sender{
    NSInteger index = _currentPlayIndex - 1;
    if (index < 0) {
        _currentPlayIndex = 0;
    } else {
        _currentPlayIndex--;
    }
    [self resetStreamer];
}

- (void)actionStop:(id)sender
{
    [self _updateControlIsPlaying:NO];
    [_progressTimer invalidate];
    _progressTimer = nil;
    [_audioPlayer stop];
}

- (void)_timerAction:(id)timer{
    
    CGFloat progress = 0;
    CGFloat currentTime = _audioPlayer.progress;
    CGFloat duration = _audioPlayer.duration;
    if ([_audioPlayer duration] > 0.0f) {
        progress = currentTime / duration;
    }
    _queueBar.progress = progress;
    _fullQueueProgressBar.progress = progress;
    
    NSInteger currentInt = (NSInteger)currentTime;
    NSInteger leftTime = (NSInteger)duration - currentInt;
    
    NSString *currentString = [NSString stringWithFormat:@"%@", @(currentInt)];
    NSString *leftTimeString = [NSString stringWithFormat:@"%@",@(leftTime)];
    
    currentString = [currentString toDateStringTime];
    leftTimeString = [NSString stringWithFormat:@"-%@", [leftTimeString toDateStringTime]];
    _passedTimeLabel.text = currentString;
    _leftTimeLabel.text = leftTimeString;
    NSLog(@"progress: %@",@(progress));
    
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *songInfo = [NSMutableDictionary dictionaryWithDictionary:[center nowPlayingInfo]];
    [songInfo setObject:@(currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [songInfo setObject:@(duration) forKey:MPMediaItemPropertyPlaybackDuration];
    [center setNowPlayingInfo:songInfo];
}

- (void)volumeChanged:(UISlider *)sender{
    _audioPlayer.volume = sender.value;
}

- (void)seekPlayTime:(CGFloat)progress{
    [_audioPlayer seekToTime:(progress * _audioPlayer.duration)];
}

#pragma mark - STKAudioPlayerDelegate
/// Raised when an item has started playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId {
    
    MusicModel *model = (MusicModel *)queueItemId;
    NSString *title = model.title;
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *songInfo = [NSMutableDictionary dictionaryWithCapacity:4];
    [songInfo setObject:title forKey:MPMediaItemPropertyTitle];
    [songInfo setObject:@(audioPlayer.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    [songInfo setObject:@(audioPlayer.progress) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [songInfo setObject:@(_currentPlayIndex) forKey:MPNowPlayingInfoPropertyChapterNumber];
    [songInfo setObject:@(_queueList.count) forKey:MPNowPlayingInfoPropertyChapterCount];
    [center setNowPlayingInfo:songInfo];
    
    _placeholderImageView.hidden = YES;
    _queueBar.titleLabel.text = title;
    _songTitleLabel.text = title;
    __weak __typeof(&*self)weakSelf = self;
    [self updateControl];
    [[FICImageCache sharedImageCache] retrieveImageForEntity:model.imageEntity withFormatName:FICCategoryGridImageFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        // This completion block may be called much later. We should check to make sure this cell hasn't been reused for different photos before displaying the image that has loaded.
        if (image) {
            [weakSelf changeCoverImage:image];
            MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
            NSMutableDictionary *songInfo = [NSMutableDictionary dictionaryWithDictionary:[center nowPlayingInfo]];
            MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc]initWithImage:image];
            [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork ];
            [center setNowPlayingInfo:songInfo];
        }
    }];
}
/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId {
    [self updateControl];
}
/// Raised when the state of the player has changed
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
    [self updateControl];
}

/// Raised when an item has finished playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    [self updateControl];
}
/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    [self updateControl];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
