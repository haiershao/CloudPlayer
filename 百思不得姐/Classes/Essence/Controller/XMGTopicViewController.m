//
//  XMGTopicViewController.m
//  百思不得姐
//
//  Created by hwawo on 16/7/8.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGTopicViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "XMGTopic.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "XMGTopicCell.h"
#import "XMGCommentViewController.h"
#import "XMGNewViewController.h"
#import "ZFPlayer.h"
#import <ZFDownloadManager.h>
#import "XMGTopicVideoView.h"
@interface XMGTopicViewController ()<ZFPlayerDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    NSInteger index;
    NSMutableArray *_dataSource;
    NSIndexPath *currentIndexPath;
}
/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 上次选中的索引(或者控制器) */
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property(nonatomic,assign)CGFloat historyY;
@end

static NSString * const XMGTopicCellId = @"topic";

@implementation XMGTopicViewController

- (NSMutableArray *)topics{
    
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化表格
    [self setupTableView];
    
    [self setUpRefresh];
    
    index = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CZDiscoverCell" bundle:nil] forCellReuseIdentifier:@"CZDiscoverCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)setupTableView{
    
    self.tableView.backgroundColor = [UIColor clearColor];
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.lh_Height;
    CGFloat top = XMGTitilesViewH + XMGTitilesViewY;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGTopicCell class]) bundle:nil] forCellReuseIdentifier:XMGTopicCellId];
    
    [XMGNoteCenter addObserver:self selector:@selector(tabBarSelect) name:XMGTabBarDidSelectNotification object:nil];
}

- (void)tabBarSelect{

    if (self.lastSelectedIndex == self.tabBarController.selectedIndex && self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}

- (void)setUpRefresh{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

- (NSString *)a{

    return [self.parentViewController isKindOfClass:[XMGNewViewController class]] ? @"newlist":@"list";
}

- (void)loadNewTopics{
    
    [self.tableView.mj_footer endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        if (self.params != params) return ;
        
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        self.topics = [XMGTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];;
        XMGLog(@"loadNewTopics %@",responseObject[@"list"]);
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        //下啦刷新页数置0
        self.page = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
   
}

- (void)loadMoreTopics{
    [self.tableView.mj_header endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"maxtime"] = self.maxtime;
    NSInteger page = self.page+1;
    params[@"page"] = @(page);
    
    self.params = params;
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        if (self.params != params) return ;
        NSLog(@"self.page%ld",(long)self.page);
        self.maxtime = responseObject[@"info"][@"maxtime"];
        NSArray *topics = [XMGTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.topics addObjectsFromArray:topics];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        self.page = page;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = !(self.topics.count);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XMGTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGTopicCellId];
    
    XMGTopic *topic = self.topics[indexPath.row];
    
    cell.topic = topic;
    
    __block NSIndexPath *weakIndexPath = indexPath;
    __block XMGTopicCell *weakCell     = cell;
    __weak typeof(self)  weakSelf      = self;
    cell.playBlock = ^(UIButton *btn){

        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
        playerModel.title            = topic.text;
        playerModel.videoURL         = [NSURL URLWithString:topic.videouri];
        
        playerModel.placeholderImageURLString = topic.large_image;
        playerModel.tableView        = weakSelf.tableView;
        playerModel.indexPath        = weakIndexPath;
        // 赋值分辨率字典
        //        playerModel.resolutionDic    = dic;
        // player的父视图
        playerModel.fatherView       = weakCell.videoView;
        
        // 设置播放控制层和model
        [weakSelf.playerView playerControlView:weakSelf.controlView playerModel:playerModel];
        // 下载功能
        weakSelf.playerView.hasDownload = YES;
        // 自动播放
        [weakSelf.playerView autoPlayTheVideo];
        [btn bringSubviewToFront:weakSelf.playerView];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMGTopic *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath---%zd",indexPath.row);
    XMGCommentViewController *commentVc = [XMGCommentViewController commentViewController];
    commentVc.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVc animated:YES];
}


- (ZFPlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    
    NSString *name = [url lastPathComponent];
    XMGLog(@"ZFTableViewController zf_playerDownload url %@ name%@",url,name);
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
}

//设置滑动的判定范围
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (_historyY+20<targetContentOffset->y)
    {
        [self setTabBarHidden:YES];
    }
    else if(_historyY-20>targetContentOffset->y)
    {
        
        [self setTabBarHidden:NO];
    }
    _historyY=targetContentOffset->y;
}
//隐藏显示tabbar
- (void)setTabBarHidden:(BOOL)hidden
{
    UIView *tab = self.tabBarController.view;
    CGRect  tabRect=self.tabBarController.tabBar.frame;
    if ([tab.subviews count] < 2) {
        return;
    }
    
    UIView *view;
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        view = [tab.subviews objectAtIndex:1];
    } else {
        view = [tab.subviews objectAtIndex:0];
    }
    
    if (hidden) {
        view.frame = tab.bounds;
        tabRect.origin.y=[[UIScreen mainScreen]bounds].size.height+self.tabBarController.tabBar.frame.size.height;
        [self.navigationController setNavigationBarHidden:hidden];
    } else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
        tabRect.origin.y=[[UIScreen mainScreen] bounds].size.height-self.tabBarController.tabBar.frame.size.height;
        [self.navigationController setNavigationBarHidden:hidden];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.tabBarController.tabBar.frame=tabRect;
    }completion:^(BOOL finished) {
        
    }];
    
}
@end
