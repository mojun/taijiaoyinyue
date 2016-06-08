//
//  QITableBaseCell.m
//  PlayZer
//
//  Created by mojun on 15/10/27.
//  Copyright © 2015年 kimoworks. All rights reserved.
//

#import "QITableBaseCell.h"

@implementation QITableBaseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (void)registerForTableView:(UITableView *)tableView{
    NSLog(@"subclass must override this method");
}

+ (NSString *)registeredIdentifier{
    NSLog(@"subclass must override this method");
    return nil;
}

- (void)highlightedShow{
    self.alpha = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.alpha = 1.0f;
    });
}

@end
