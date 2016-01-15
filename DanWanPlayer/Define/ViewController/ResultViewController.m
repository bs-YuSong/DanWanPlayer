//
//  ResultViewController.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "ResultViewController.h"
#import "SearchViewModel.h"
#import "MatchViewModel.h"
#import "SearchTableViewCell.h"
#import "MatchTableViewCell.h"
#import "SearchView.h"
#import "PlayerViewController.h"
#import "ChooseDanMuViewController.h"
#import "EpisodeChooseTableViewController.h"
#import "DanMuModel.h"
#import "VideoModel.h"
#import "MJRefreshNormalHeader+Tools.h"

#import "DanMuNetManager.h"
@interface ResultViewController ()<UITableViewDelegate, UITableViewDataSource,SearchViewDelegate>
@property (nonatomic, strong) SearchViewModel *searchVM;
@property (nonatomic, strong) MatchViewModel *matchVM;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) UIButton *touchButton;
@property (nonatomic, strong) NSString *keyWord;
/**
 *  顶部标题栏尺寸
 */
@property (nonatomic, strong) NSValue* topFrame;
/**
 *  match视图刷新头
 */
@property (nonatomic, strong) MJRefreshNormalHeader *matchHeader;
/**
 *  search视图刷新头
 */
@property (nonatomic, strong) MJRefreshNormalHeader *searchHeader;
/**
 *  用于判断单元格类型
 */
@property (nonatomic, assign, getter=isSearchStyle) BOOL searchStyle;
@end

@implementation ResultViewController

#pragma mark - 方法

- (void)viewDidLoad {
    [super viewDidLoad];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tableView.mj_header = self.matchHeader;
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)initWithModel:(VideoModel *)model{
    if (self = [super init]) {
        self.navigationItem.title = @"选择番剧";
        self.matchVM = [[MatchViewModel alloc] initWithModel: model];
        self.searchVM = [[SearchViewModel alloc] initWithModel: model];
    }
    return self;
}

- (void)hideKeyBoard{
    [self.view endEditing: YES];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    self.touchButton.hidden = NO;
}

- (void)keyboardWillHide:(NSNotification *)notification{
    self.touchButton.hidden = YES;
}

#pragma mark - UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cell = nil;
    if (self.searchStyle) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];
        if (cell == nil) {
            cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchTableViewCell"];
        }
        [cell setWithDic: @{
                            @"textLabel.text" : [self.searchVM  modelTitleWithIndex: indexPath]
                            }];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"MatchTableViewCell"];
        if (cell == nil) {
            cell = [[MatchTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MatchTableViewCell"];
        }
        [cell setWithDic: @{
                            @"textLabel.text" : [self.matchVM modelAnimeTitleIdWithIndex: indexPath.row],
                            @"detailTextLabel.text" : [self.matchVM modelEpisodeTitleWithIndex: indexPath.row]
                            }];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isSearchStyle ? [self.searchVM modelZoneCountWithSection: section] : [self.matchVM modelCount];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.isSearchStyle ? [self.searchVM modelCount] : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.isSearchStyle ? [self.searchVM modelTypeWithSection: section] : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
    if (self.isSearchStyle) {
        [self.navigationController pushViewController:[[EpisodeChooseTableViewController alloc] initWithEpisodeArr:[self.searchVM modelEpisodesWithIndex: indexPath] title:[self.searchVM  modelTitleWithIndex: indexPath] model:self.searchVM.videoModel] animated: YES];
    //匹配模式 尝试获取官方弹幕 如果存在 直接推出播放界面
    }else{
        [SVProgressHUD showWithStatus:[[NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Message" ofType:@"plist"]][@"Load"] randomObject] maskType:SVProgressHUDMaskTypeNone];
        [DanMuNetManager getWithParameters:@{@"id": [self.matchVM modelEpisodeIdWithIndex: indexPath.row]} completionHandler:^(id responseObj, NSError *error) {
            [SVProgressHUD dismiss];
            //官方弹幕存在
            if ([responseObj isKindOfClass:[DanMuModel class]]) {
                NSURL *filePath = [NSURL fileURLWithPath: [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:self.matchVM.videoModel.filePath]];
                [self presentViewController:[[PlayerViewController alloc] initWithModel:responseObj provider:nil videoURL:filePath videoTitle:[self.matchVM modelEpisodeTitleWithIndex: indexPath.row]] animated:YES completion: nil];
            }else{
                NSString *str = [self.matchVM modelEpisodeTitleWithIndex: indexPath.row];
                //让滚轮自动滚到对应分集
                [str enumerateRegexMatches:@"\\d{1,}" options:NSRegularExpressionCaseInsensitive usingBlock:^(NSString *match, NSRange matchRange, BOOL *stop) {
                    *stop = YES;
                    [self.navigationController pushViewController:[[ChooseDanMuViewController alloc] initWithVideoDic:responseObj episode:match.intValue - 1 model:self.matchVM.videoModel] animated:YES];
                }];
            }
        }];
    }
}

#pragma mark - SearchView
- (void)searchButtonDown:(SearchView *)searchView searchText:(NSString *)searchText{
    if (searchText == nil || [searchText isEqualToString:@""]) return;
    [self hideKeyBoard];
    //点击搜索后 tableview改为搜索模式
    self.searchStyle = YES;
    self.keyWord = searchText;
    self.tableView.mj_header = self.searchHeader;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview: _tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.equalTo(self.searchView).mas_offset(-20);
        }];
    }
    return _tableView;
}

- (SearchView *)searchView {
    if(_searchView == nil) {
        _searchView = [[SearchView alloc] init];
        _searchView.delegate = self;
        [self.view addSubview: _searchView];
        [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_offset([self.topFrame CGRectValue].size.height);
            make.height.mas_equalTo(40);
        }];
    }
    return _searchView;
}

- (NSValue *)topFrame{
    if (_topFrame == nil) {
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        CGRect rectNav = self.navigationController.navigationBar.frame;
        rectStatus.size.height += rectNav.size.height;
        _topFrame = [NSValue valueWithCGRect: rectStatus];
    }
    return _topFrame;
}

- (MJRefreshNormalHeader *)matchHeader {
    if(_matchHeader == nil) {
        _matchHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.matchVM refreshWithModelCompletionHandler:^(NSError *error) {
                [self.tableView.mj_header endRefreshing];
                if (error) [SVProgressHUD showErrorWithStatus: [[NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Message" ofType:@"plist"]][@"Error"] firstObject]];
                else [self.tableView reloadData];
            }];
        }];
    }
    return _matchHeader;
}

- (MJRefreshNormalHeader *)searchHeader {
	if(_searchHeader == nil) {
        _searchHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_searchVM refreshWithKeyWord:self.keyWord completionHandler:^(NSError *error) {
                [self.tableView.mj_header endRefreshing];
                if (error) [SVProgressHUD showErrorWithStatus: [[NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Message" ofType:@"plist"]][@"Error"] firstObject]];
                else [self.tableView reloadData];
            }];
        }];
	}
	return _searchHeader;
}

- (UIButton *)touchButton {
    if(_touchButton == nil) {
        _touchButton = [[UIButton alloc] init];
        [_touchButton addTarget: self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: _touchButton];
        [_touchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.searchView.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return _touchButton;
}

@end
