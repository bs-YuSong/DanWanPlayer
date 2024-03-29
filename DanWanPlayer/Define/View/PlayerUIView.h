//
//  PlayerUIView.h
//  te
//
//  Created by apple-jd44 on 15/11/27.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayerUIView;
@protocol PlayerUIViewDelegate<NSObject>
@optional
- (void)playerTouchBackArrow:(PlayerUIView*)UIView;
- (void)playerTouchDanMuButton:(PlayerUIView*)UIView;
- (void)playerTouchPlayerButton:(PlayerUIView*)UIView;
- (void)playerTouchSlider:(PlayerUIView*)UIView slideValue:(CGFloat)value;
@end

typedef void(^handle)();
@interface PlayerUIView : UIView
@property (nonatomic, weak) id<PlayerUIViewDelegate> delegate;
@property (nonatomic, strong) handle returnBlock;
/**
 *  初始化播放器ui
 *
 *  @param title     视频标题
 *  @param videoTime 视频总时长
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString*)title videoTime:(CGFloat)videoTime;
- (void)showPlayer;
- (void)hiddenPlayer;
/**
 *  用于更新参数
 *
 */
- (void)updateValue:(handle) block;
/**
 *  更新时间
 *
 *  @param currentTime 当前时间
 *  @param bufferTime  缓存时间
 */
- (void)updateCurrentTime:(CGFloat)currentTime bufferTime:(CGFloat)bufferTime;
@end
