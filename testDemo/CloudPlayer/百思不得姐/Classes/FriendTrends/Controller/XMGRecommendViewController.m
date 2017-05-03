//
//  XMGRecommendViewController.m
//  百思不得姐
//
//  Created by hwawo on 16/6/30.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGRecommendViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "XMGRecommendCategory.h"
#import <MJExtension.h>
#import "XMGRecommendCategoryCell.h"
#import "XMGRecommendUserCell.h"
#import "XMGRecommendUser.h"
#import <MJRefresh.h>

#define XMGSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]
@interface XMGRecommendViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (strong, nonatomic) NSMutableArray *categories;
/** 右边的用户数据 */
@property (nonatomic, strong) NSArray *users;
@property (strong, nonatomic) AFHTTPSessionManager *manager;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
@end
static NSString *const XMGCategoryId = @"category";
static NSString * const XMGUserId = @"user";
@implementation XMGRecommendViewController

- (AFHTTPSessionManager *)manager{

    if (!_manager) {
        
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpTableView];
    
    [self loadCategories];
    
    [self setUpRefresh];
}

- (void)setUpRefresh{

    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    
    self.userTableView.mj_footer.hidden = YES;
}

- (void)loadMoreUsers{

    
    XMGRecommendCategory *rc = XMGSelectedCategory;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(rc.id);
    params[@"page"] = @(++rc.currentPage);
    self.params = params;
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        // 字典数组 -> 模型数组
        NSArray *users = [XMGRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 添加到当前类别对应的用户数组中
        [rc.users addObjectsFromArray:users];

        //是最后一次请求才去刷新表格
        if (self.params != params) return ;
        
        
        [self.userTableView reloadData];
        
        
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];
}

- (void)loadNewUsers{

    XMGRecommendCategory *rc = XMGSelectedCategory;
    rc.currentPage = 1;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(rc.id);
    params[@"page"] = @(rc.currentPage);
    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {

        // 字典数组 -> 模型数组
        NSArray *users = [XMGRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [rc.users removeAllObjects];
        
        // 添加到当前类别对应的用户数组中
        [rc.users addObjectsFromArray:users];
        
        rc.total = [responseObject[@"total"] integerValue];
        
        //是最后一次请求才去刷新表格
        if (self.params != params) return ;
        
        [self.userTableView reloadData];
        
        [self.userTableView.mj_header endRefreshing];
        
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMGLog(@"%@", error);
    }];
}

- (void)checkFooterState{
    
    XMGRecommendCategory *rc = XMGSelectedCategory;
    
    self.userTableView.mj_footer.hidden = (rc.users.count == 0);
    
    if (rc.users.count == rc.total) {
        [self.userTableView.mj_footer resetNoMoreData];
    }else{
        
        [self.userTableView.mj_footer endRefreshing];
    }
}

- (void)loadCategories{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        [SVProgressHUD dismiss];
        
        self.categories = [XMGRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        NSLog(@"%@",self.categories);
        
        [self.categoryTableView reloadData];
        
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        [self.userTableView.mj_header beginRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
        
    }];
}

- (void)setUpTableView{

    self.title = @"推荐关注";
    
    // 设置背景色
    self.view.backgroundColor = XMGGlobalBg;

    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:XMGCategoryId];
    
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:XMGUserId];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;
    
}

+ (instancetype)recommendViewController{

    return [[XMGRecommendViewController alloc] initWithNibName:@"XMGRecommendViewController" bundle:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.categoryTableView) return self.categories.count;
        
    return [XMGSelectedCategory users].count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    if (tableView == self.categoryTableView) {
        
        XMGRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGCategoryId];
        
        cell.category = self.categories[indexPath.row];
        
        return cell;
    }else{
    
        XMGRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGUserId];
        XMGRecommendCategory *c = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        cell.user = c.users[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    
    XMGRecommendCategory *c = self.categories[indexPath.row];
    if (c.users.count) {
        
        [self.userTableView reloadData];
    }else{
    
        [self.userTableView reloadData];
        
        [self.userTableView.mj_header beginRefreshing];
        
    }
    
    
}

- (void)dealloc{

    [self.manager.operationQueue cancelAllOperations];
}

@end
