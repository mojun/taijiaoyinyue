//
//  LeftViewController.m
//  AntenatalTraining
//
//  Created by test on 16/4/27.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "LeftViewController.h"
#import "TouchButton.h"
#import "UIButton+UIButtonImageWithLabel.h"

static NSInteger _currentSelectedIndex = 100;

@interface LeftViewController () {
    UIScrollView *_scrollView;
    NSMutableArray *_cells;
}

@end

#define kThemeBlueColor UIColor_RGB(48,150,225)
#define kThemeGrayColor UIColor_RGB(182,193,199)

@implementation LeftViewController

#pragma mark - life cycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self scrollView];
    [self setupItems];
}

#pragma mark - getters and setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _scrollView;
}

- (void)setupItems {
    
    _cells = [NSMutableArray array];
    CGFloat startFromYPos = 80;
    NSArray *items = arrayFromResource(@"SideItems.plist");
    _cells = [NSMutableArray arrayWithCapacity:items.count];
    _scrollView.delaysContentTouches = NO;
    CGFloat spacing = 10 * screenHScale();
    NSInteger count = items.count;
    for (NSInteger i=0; i<count; i++) {
        NSString *item = items[i][@"identifier"];
        NSString *title = items[i][@"title"];
        TouchButton *cell = [TouchButton buttonWithType:UIButtonTypeCustom];
        cell.frame = CGRectMake(0, 0, 104, 48);
        cell.showsTouchWhenHighlighted = NO;
        [cell setImage:[UIImage imageNamed:item] withTitle:title titleColor:kThemeGrayColor forState:UIControlStateNormal];
        [cell setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_active", item]] withTitle:title titleColor:kThemeColor forState:UIControlStateHighlighted];
        [cell setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_active", item]] withTitle:title titleColor:kThemeColor forState:UIControlStateSelected];
        cell.tag = i;
        [cell addTarget:self action:@selector(sideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat yPos = (cell.frameHeight + spacing) * i + startFromYPos;
        if (i == count - 1) {
            yPos = screenSize().height - cell.frameHeight - spacing;
        }
        
        cell.frameY = yPos;
        [_cells addObject:cell];
        [_scrollView addSubview:cell];
    }
    
    NSInteger selectedIndex = (_currentSelectedIndex == 100) ? 0 : _currentSelectedIndex;
    UIButton *selectedCell = _cells[selectedIndex];
    [selectedCell sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)sideButtonAction:(UIButton *)sender{
    
    _currentSelectedIndex = sender.tag;
    [_delegate leftViewController:self didSelectAtIndex:_currentSelectedIndex];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIButton *cell in _cells) {
            cell.selected = NO;
        }
        UIButton *selectedCell = _cells[_currentSelectedIndex];
        selectedCell.selected = YES;
    });
}

@end
