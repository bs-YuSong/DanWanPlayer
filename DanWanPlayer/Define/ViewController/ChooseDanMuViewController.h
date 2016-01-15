//
//  ChooseDanMuViewController.h
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;
/**
 *  弹幕库选择视图
 */
@interface ChooseDanMuViewController : UIViewController
- (instancetype)initWithVideoDic:(NSDictionary *)dic episode:(NSInteger)episode model:(VideoModel *)model;
@end
