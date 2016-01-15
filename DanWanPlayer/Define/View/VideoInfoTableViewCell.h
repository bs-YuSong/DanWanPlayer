//
//  VideoInfoTableViewCell.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/25.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  视频详情cell
 */
@interface VideoInfoTableViewCell : UITableViewCell
- (void)setWithCoverImg:(UIImage *)coverImg title:(NSString *)title time:(NSString *)time;
@end
