//
//  HomeViewController.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/25.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "HomeViewController.h"
#import "VideoInfoTableViewCell.h"
#import "VideoModel.h"
#import <AVFoundation/AVFoundation.h>
#import "JHVLCMedia.h"
#import "JHVLCMediaThumbnailer.h"
//#import <MediaPlayer/MediaPlayer.h>
#import "ResultViewController.h"

#import "PlayerViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <VideoModel *>*videosArr;
@property (nonatomic, strong) NSMutableArray *mediaArr;
/**
 *  格式化时间
 */
@property (nonatomic, strong) NSDateFormatter* formatter;
@end

@implementation HomeViewController
#pragma mark - 方法

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (instancetype)init{
    if (self = [super init]) {
        self.navigationItem.title = @"选择视频";
    }
    return self;
}

//获取视频总时长和缩略图
- (void)videoTimeAndThumbWithPath:(NSURL *)path index:(NSInteger)index{
    JHVLCMedia *media = [[JHVLCMedia alloc] initWithURL:path];
    __weak typeof (self)weakSelf = self;
    [media parseWithBlock:^(VLCMedia *aMedia) {
        weakSelf.videosArr[index].duration = aMedia.length.stringValue;
        [weakSelf.tableView reloadRow: index inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
        
        JHVLCMediaThumbnailer *th = [[JHVLCMediaThumbnailer alloc] initWithMedia:aMedia];
        [th fetchThumbnailWithBlock:^(UIImage *aThumb) {
            weakSelf.videosArr[index].thumb = aThumb;
            [weakSelf.tableView reloadRow: index inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }];
    [self.mediaArr addObject: media];
}

//视频文件长
- (NSString *)videoLengthWithPath:(NSURL *)path{
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:path.path error:nil][@"NSFileSize"] stringValue];
}
//文件md5
- (NSString *)videoHashWithPath:(NSURL *)path{
    return [[[NSFileHandle fileHandleForReadingFromURL:path error: nil] readDataOfLength: 16777216] md5String];
}

#pragma mark - UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoTableViewCell"];
    if (cell == nil) {
        cell = [[VideoInfoTableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"VideoInfoTableViewCell"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    [cell setWithCoverImg: self.videosArr[indexPath.row].thumb title:self.videosArr[indexPath.row].fileName time: self.videosArr[indexPath.row].duration];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
    [self.navigationController pushViewController:[[ResultViewController alloc] initWithModel: self.videosArr[indexPath.row]] animated: YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.videosArr.count;
}


#pragma mark - 懒加载
- (NSDateFormatter *)formatter{
    if(_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"mm:ss"];
    }
    return _formatter;
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 80)];
        label.font = [UIFont systemFontOfSize: 15];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.videosArr.count?@"ㄟ( ▔, ▔ )ㄏ没有了":@"´_ゝ`并没有找到视频";
        _tableView.tableFooterView = label;
    }
    return _tableView;
}

- (NSArray <VideoModel *>*)videosArr {
    if(_videosArr == nil) {
        NSArray *contentsArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[UIApplication sharedExtensionApplication].documentsPath error:nil];
        NSArray *canPlayArr = @[@"WMV",@"AVI",@"MKV",@"RMVB",@"RM",@"XVID",@"MP4",@"3GP",@"MPG"];
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0, index = 0; i < contentsArr.count; ++i) {
            NSString *obj = contentsArr[i];
            for (NSString *type in canPlayArr) {
                if ([type localizedCaseInsensitiveContainsString: [obj pathExtension]]) {
                    VideoModel* model = [[VideoModel alloc] init];
                    NSURL *filePath = [NSURL fileURLWithPath: [[UIApplication sharedExtensionApplication].documentsPath stringByAppendingPathComponent: obj]];
                    model.filePath = obj;
                    model.fileName = [obj stringByDeletingPathExtension];
                    
                    [self videoTimeAndThumbWithPath:filePath index: index];
                    model.length = [self videoLengthWithPath: filePath];
                    model.md5 = [self videoHashWithPath: filePath];
                    [tempArr addObject: model];
                    index++;
                    break;
                }
            }
        }
        _videosArr = tempArr;
    }
    return _videosArr;
}

- (NSMutableArray *)mediaArr {
	if(_mediaArr == nil) {
		_mediaArr = [[NSMutableArray alloc] init];
	}
	return _mediaArr;
}

@end
