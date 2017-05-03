//
//  XMGCommentViewController.m
//  百思不得姐
//
//  Created by hwawo on 16/7/14.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGCommentViewController.h"
#import "XMGTopicCell.h"
#import "XMGTopic.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import "XMGComment.h"
#import "XMGUser.h"
#import <MJExtension.h>
#import "XMGCommentCell.h"
#import "XMGCommentHeaderView.h"
static NSString * const XMGCommentId = @"comment";
@interface XMGCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
/** 工具条底部间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSapce;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;

/** 保存帖子的top_cmt */
@property (nonatomic, strong) XMGComment *saved_top_cmt;

/** 管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/** 保存当前的页码 */
@property (nonatomic, assign) NSInteger page;
@end

@implementation XMGCommentViewController

- (AFHTTPSessionManager *)manager{

    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    
    [self setUpHeader];
    
    [self setUpRefresh];
}

- (void)setUpRefresh{

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
//    self.tableView.mj_footer.hidden = YES;
}

- (void)loadNewComments{

    // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        //最热评论
        self.hotComments = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        NSLog(@"----%@",responseObject);
        
        //最新评论
        self.latestComments = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreComments{

    // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSInteger page = self.page+1;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
//    params[@"hot"] = @"1";
    params[@"page"] = @(page);
    XMGComment *cmt = [self.latestComments firstObject];
    params[@"lastcid"] = cmt.ID;
    
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        self.page = page;
        
        //最热评论
//        self.hotComments = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        NSLog(@"----%@",responseObject);

        NSArray *newComments = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        //控制footer状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total ) {
//            self.tableView.mj_footer.hidden = YES;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
        
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)setUpHeader{
    CGFloat screenW = XMGScreenW;
    UIView *header = [[UIView alloc] init];
    
    XMGTopicCell *cell = [XMGTopicCell topicCell];
    
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
    cell.topic = self.topic;
    
    cell.lh_Size = CGSizeMake(screenW, self.topic.cellHeight);
    
    [header addSubview:cell];
    
    header.lh_Height = self.topic.cellHeight + XMGTopicCellMargin;
    
    self.tableView.tableHeaderView = header;
}

- (void)setUpTableView{

    self.title = @"评论";
    self.tableView.backgroundColor = XMGGlobalBg;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"  " highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
    //自动算cell高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGCommentCell class]) bundle:nil] forCellReuseIdentifier:XMGCommentId];
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.saved_top_cmt) {
       self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
    [self.manager invalidateSessionCancelingTasks:YES];
}

- (void)keyboardWillChangeFrame:(NSNotification *)note{

    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat screenH = XMGScreenH;
    self.bottomSapce.constant = screenH - frame.origin.y;
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

+ (instancetype)commentViewController{

    return [[XMGCommentViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

#pragma mark - <UITableViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    XMGCommentHeaderView *headerView = [XMGCommentHeaderView headerViewWithTableView:tableView];
    NSInteger hotCommentsCount = self.hotComments.count;
    NSLog(@"------------%ld",(long)hotCommentsCount);
    if (section == 0) {
        headerView.title = hotCommentsCount ? @"最热评论" : @"最新评论";
    }else{
    
        headerView.title = @"最新评论";
    }

    return headerView;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"----------------------------------------");
    UIMenuController *menuVc = [UIMenuController sharedMenuController];
    
    XMGCommentCell *cell = (XMGCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell becomeFirstResponder];
    
    UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
    UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
    UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];

    menuVc.menuItems = @[ding, replay, report];
    CGRect rect = CGRectMake(0, cell.lh_Height * 0.5, cell.lh_Width, cell.lh_Height*0.5);
    [menuVc setTargetRect:rect inView:cell];
    [menuVc setMenuVisible:YES animated:YES];
}

- (void)ding:(UIMenuController *)menuVc{

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexpath:indexPath].content);
}

- (void)replay:(UIMenuController *)menuVc{
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexpath:indexPath].content);
}

- (void)report:(UIMenuController *)menuVc{
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexpath:indexPath].content);
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (self.hotComments.count) {
        return 2;
    }else if (self.latestComments.count){
    
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    NSInteger hotCount = self.hotComments.count;
//    NSInteger latestCount = self.latestComments.count;
    
    if (section == 0) {
       return  self.hotComments.count ? self.hotComments.count : self.latestComments.count;
    }
    
    return self.latestComments.count;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//
//    if (section == 0) {
//        return self.hotComments.count ? @"最热评论" : @"最新评论";
//    }
//    return @"最新评论";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    XMGComment *comment = [self commentInIndexpath:indexPath];
    
    XMGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGCommentId];
    
    cell.comment = comment;
    
    return cell;
    
}

- (XMGComment *)commentInIndexpath:(NSIndexPath *)indexPath{

    return [self commentsInSection:indexPath.section][indexPath.row];
}

- (NSArray *)commentsInSection:(NSInteger)section{

    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    
    return self.latestComments;
}

@end
