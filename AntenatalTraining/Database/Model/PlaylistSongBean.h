//
//  PlaylistSongBean.h
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "MusicModel.h"

@interface PlaylistSongBean : MusicModel

@property (nonatomic, strong) NSNumber *playlist_id;
@property (nonatomic, strong) NSNumber *order_index;

@end
