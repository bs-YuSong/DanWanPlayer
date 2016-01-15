//
//  EpisodeChooseTableViewController.h
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/8.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EpisodesModel, VideoModel;
/**
 搜索视图分集选择视图
 
 - returns: self
 */
@interface EpisodeChooseTableViewController : UITableViewController
- (instancetype)initWithEpisodeArr:(NSArray<EpisodesModel*>*)episodes title:(NSString *)title model:(VideoModel *)model;
@end
