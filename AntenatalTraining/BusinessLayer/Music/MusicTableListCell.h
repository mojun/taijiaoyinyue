//
//  MusicTableListCell.h
//  AntenatalTraining
//
//  Created by mo jun on 5/5/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "QITableBaseCell.h"

@class MusicTableListCell;
@protocol MusicTableListCellDelegate <NSObject>

@optional
- (void)musicTableListCell:(MusicTableListCell *)cell didTouchedButtonAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MusicTableListCell : QITableBaseCell

//@property (nonatomic, strong) IBOutlet UIImageView  *coverView;

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) id<MusicTableListCellDelegate> delegate;

@end
