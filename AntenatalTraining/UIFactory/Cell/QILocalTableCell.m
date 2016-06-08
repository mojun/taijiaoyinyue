//
//  QILocalTableCell.m
//  PlayZer
//
//  Created by mo jun on 10/28/15.
//  Copyright © 2015 kimoworks. All rights reserved.
//

#import "QILocalTableCell.h"

@implementation QILocalTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.coverView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kListCellHeight, kListCellHeight)];
        [self addSubview:self.coverView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kListCellHeight + 10, 0, kScreenWidth - 10 *2, kListCellHeight)];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.titleLabel];
    }
    return self;
}

+ (void)registerForTableView:(UITableView *)tableView{
    [tableView registerClass:[self class] forCellReuseIdentifier:[self registeredIdentifier]];
}

+ (NSString *)registeredIdentifier{
    return @"QILocalTableCell";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
