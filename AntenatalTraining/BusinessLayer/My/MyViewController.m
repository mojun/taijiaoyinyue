//
//  MyViewController.m
//  AntenatalTraining
//
//  Created by test on 16/4/28.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "MyViewController.h"
#import "QITableBaseCell.h"
#import "MusicDetailViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "TouchButton.h"

@interface MyViewCell : QITableBaseCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation MyViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = kThemeLightBlack;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconView.mas_right).offset(8);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

+ (void)registerForTableView:(UITableView *)tableView{
    [tableView registerClass:[self class] forCellReuseIdentifier:[self registeredIdentifier]];
}

+ (NSString *)registeredIdentifier {
    return @"MyViewCell";
}

@end

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate, SKStoreProductViewControllerDelegate>
{
    NSArray *_datas;
}

@property (nonatomic, strong) QITableListView *listView;

@end

@implementation MyViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        _datas = @[
                   @{@"title":@"我的收藏",@"icon":@"settings_collection"},
                   @{@"title":@"给个好评吧^_^", @"icon": @"settings_write"},
                   @{@"title":[NSString stringWithFormat:@"当前版本:  V%@", version],@"icon":@"settings_version"}
                   ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.listView addToSuperView:self.view];
    self.listView.tableView.tableHeaderView = [self headerView];
    self.listView.tableView.tableFooterView = [self footerView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyViewCell registeredIdentifier] forIndexPath:indexPath];
    
    NSDictionary *data = _datas[indexPath.row];
    cell.titleLabel.text = data[@"title"];
    cell.iconView.image = [UIImage imageNamed:data[@"icon"]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:{
            MusicDetailViewController *c = [[MusicDetailViewController alloc] initFromXib];
            c.title = @"我的收藏  ";
            [self.navigationController pushViewController:c animated:YES];
            break;
        }
        case 1:{
            [self evaluateAppId:@"822431295"];
            break;
        }
        default:
            break;
    }
}


- (void)evaluateAppId:(NSString *)appId{
    
    [SVProgressHUD showWithStatus:nil];
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId唯一的
     
     @{SKStoreProductParameterITunesItemIdentifier : appId} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         [SVProgressHUD dismiss];
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }
              ];
         }
         
     }];
}

//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - getters

- (QITableListView *)listView {
    if (_listView == nil) {
        _listView = [[QITableListView alloc] initWithStyle:UITableViewStylePlain delegate:self];
        [_listView registerCellClass:[MyViewCell class]];
        _listView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f];
        _listView.tableView.separatorColor = kTableCellSeparatorColor;
    }
    return _listView;
}

- (UIView *)headerView {
    
    CGFloat width = kScreenWidth;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.54 * width)];
    UIImageView *imageView = [[UIImageView alloc] init];
    [header addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header);
    }];
//    [imageView setImageViewToBlurWithImage:[UIImage imageNamed:@"settings_header"] andBlurRadius:2];
    imageView.image = [UIImage imageNamed:@"settings_header"];
    
    UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.alpha = 0.80;
    [header addSubview:effectView];
    
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header);
    }];
    
//    UIImageView *imageProfileView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings_profile"]];
//    [header addSubview:imageProfileView];
//    [imageProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(60, 60));
//        make.left.equalTo(header.mas_left);
//        make.bottom.equalTo(header.mas_bottom);
//    }];
    
    return header;
}

- (UIView *)footerView {
    
    NSArray *appIds = @[@"822431295",@"888551320"];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    
    CGFloat buttonWidth = 60;
    CGFloat spacing = 40;
    CGFloat xPos = (kScreenWidth - buttonWidth * 2 - spacing) * 0.5f;
    for (NSInteger i=0; i<appIds.count; i++) {
        TouchButton *btn = [TouchButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:appIds[i]] forState:UIControlStateNormal];
        btn.frame = CGRectMake(xPos, (120 - buttonWidth) * 0.5f, buttonWidth, buttonWidth);
//        btn.layer.cornerRadius = 4;
//        btn.layer.masksToBounds = YES;
        btn.layer.shadowColor = kThemeColor.CGColor;
        btn.layer.shadowOffset = CGSizeMake(0, 0);
        btn.layer.shadowOpacity = 0.8f;
        btn.layer.shadowRadius = 4;
        [footer addSubview:btn];
        [btn addTarget:self action:@selector(footerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        xPos += (buttonWidth + spacing);
    }
    
    return footer;
}

- (void)footerButtonAction:(UIButton *)sender {
    
    NSArray *appIds = @[@"822431295",@"888551320"];
    NSInteger tag = sender.tag;
    NSString *appId = appIds[tag];
    [self evaluateAppId:appId];
}

@end
