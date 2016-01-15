//
//  EpisodeChooseTableViewController.m
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/8.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "EpisodeChooseTableViewController.h"
#import "EpisodeChooseViewModel.h"
#import "ChooseDanMuViewController.h"
#import "PlayerViewController.h"
#import "DanMuNetManager.h"
#import "DanMuModel.h"
#import "VideoModel.h"

@interface EpisodeChooseTableViewController ()
@property (nonatomic, strong) EpisodeChooseViewModel *vm;
@property (nonatomic, strong) VideoModel *model;
@end

@implementation EpisodeChooseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (instancetype)initWithEpisodeArr:(NSArray<EpisodesModel*>*)episodes title:(NSString *)title model:(VideoModel *)model{
    if (self = [super init]) {
        self.navigationItem.title = title;
        self.model = model;
        self.vm = [[EpisodeChooseViewModel alloc] initWithEpisodeArr: episodes];
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.vm episodeCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.vm episodeTitleWithIndex: indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [self.vm episodeTitleWithIndex: indexPath.row];
    [str enumerateRegexMatches:@"\\d{1,}" options:NSRegularExpressionCaseInsensitive usingBlock:^(NSString *match, NSRange matchRange, BOOL *stop) {
        *stop = YES;
        
        [SVProgressHUD showWithStatus:[[NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Message" ofType:@"plist"]][@"Load"] randomObject] maskType:SVProgressHUDMaskTypeNone];
        [DanMuNetManager getWithParameters:@{@"id": [self.vm episodeIDWithIndex: indexPath.row]} completionHandler:^(id responseObj, NSError *error) {
            [SVProgressHUD dismiss];
            //官方弹幕存在
            if ([responseObj isKindOfClass:[DanMuModel class]]) {
                NSURL *filePath = [NSURL fileURLWithPath: [[UIApplication sharedExtensionApplication].documentsPath stringByAppendingPathComponent:self.model.filePath]];
                [self presentViewController:[[PlayerViewController alloc] initWithModel:responseObj provider:nil videoURL:filePath videoTitle:nil] animated:YES completion: nil];
            }else{
                NSString *str = [self.vm episodeTitleWithIndex: indexPath.row];
                //让滚轮自动滚到对应分集
                [str enumerateRegexMatches:@"\\d{1,}" options:NSRegularExpressionCaseInsensitive usingBlock:^(NSString *match, NSRange matchRange, BOOL *stop) {
                    *stop = YES;
                    [self.navigationController pushViewController:[[ChooseDanMuViewController alloc] initWithVideoDic:responseObj episode:match.intValue - 1 model:self.model] animated:YES];
                }];
            }
        }];
    }];
    
}

@end
