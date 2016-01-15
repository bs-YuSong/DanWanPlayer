//
//  ResultViewController.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  展示结果控制器
 */
@class VideoModel;
@interface ResultViewController : UIViewController
- (instancetype)initWithModel:(VideoModel *)model;
@end
