//
//  IPlaylistTableViewCell.m
//  Lightning DS
//
//  Created by wuxiaolong on 15/9/9.
//  Copyright (c) 2015年 com.auralic. All rights reserved.
//

#import "IPlaylistTableViewCell.h"

@interface IPlaylistTableViewCell () {

}
@end

@implementation IPlaylistTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.firstLab.font = [UIFont systemFontOfSize:17];;
    self.secondLab.font = [UIFont systemFontOfSize:12];
    
//    self.firstLab.textColor = IUIDsignFirstTextColor;
//    self.nameTF.textColor = IUIDsignFirstTextColor;
//    self.secondLab.textColor = IUIDsignSecondTextColor;
//    
//    self.firstLab.highlightedTextColor = IUIDsignFirstHighlightedTextColor;
//    self.secondLab.highlightedTextColor = IUIDsignSecondHighlightedTextColor;
    
    self.firstLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.secondLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    UIImage *moreImage = [UIImage imageNamed:@"btn_shared_more"];
    moreImage = [moreImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.moreBtn.tintColor = kThemeColor;
    [self.moreBtn setImage:moreImage forState:UIControlStateNormal];
    
}
- (IBAction)moreBtnActive:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didSelectAtIndexPath:)]) {
        [self.delegate cell:self didSelectAtIndexPath:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (!self.selected) {
        self.firstLab.highlighted = highlighted;
        self.secondLab.highlighted = highlighted;
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.firstLab.text = @"";
    self.secondLab.text = @"";
    
//    self.firstLab.textColor = IUIDsignFirstTextColor;
//    self.secondLab.textColor = IUIDsignSecondTextColor;
    [self.firstLab.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)dealloc
{
    
}

+ (NSString *)registeredIdentifier{
    return @"IPlaylistTableViewCell";
}

+ (void)registerForTableView:(UITableView *)tableView{
    
    [tableView registerNib:[UINib nibWithNibName:[self registeredIdentifier] bundle:nil] forCellReuseIdentifier:[self registeredIdentifier]];
}

-(void)setTheEditingStyle:(BOOL)isEditing{
    [_firstLab setHidden:isEditing];
    [_secondLab setHidden:isEditing];
}

@end
