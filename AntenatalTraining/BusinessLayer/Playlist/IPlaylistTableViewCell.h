//
//  IPlaylistTableViewCell.h
//  Lightning DS
//
//  Created by wuxiaolong on 15/9/9.
//  Copyright (c) 2015年 com.auralic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchButton.h"
#import "QITableBaseCell.h"

@class IPlaylistTableViewCell;
@protocol IPlaylistTableViewCellDelegate <NSObject>

- (void)cell:(IPlaylistTableViewCell *)cell didSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface IPlaylistTableViewCell :  QITableBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet TouchButton *moreBtn;
@property (weak, nonatomic) id<IPlaylistTableViewCellDelegate>delegate;

-(void)setTheEditingStyle:(BOOL)isEditing;

@end
