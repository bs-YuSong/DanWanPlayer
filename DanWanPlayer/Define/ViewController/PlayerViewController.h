//
//  PlayerViewController.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/25.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DanMuModel;
/**
 *  播放器控制器
 */
@interface PlayerViewController : UIViewController
/**
 *  初始化
 *
 *  @param model      弹幕模型 可能为弹幕的id或者danMuModel
 *  @param provider   提供者
 *  @param videoURL   视频本地路径
 *  @param videoTitle 视频标题
 *
 *  @return self
 */
- (instancetype)initWithModel:(id)model provider:(NSString *)provider videoURL:(NSURL *)videoURL videoTitle:(NSString *)videoTitle;
@end
