//
//  PlayerViewController.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/25.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlayViewModel.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "BarrageDescriptor+Tools.h"
#import "BarrageRenderer.h"
#import "PlayerUIView.h"
#import "DanMuModel.h"
#import "JHVLCMedia.h"

@interface PlayerViewController ()<PlayerUIViewDelegate, BarrageRendererDelegate>
@property (nonatomic, strong) PlayViewModel *playVM;
@property (nonatomic, strong) BarrageRenderer *rander;
@property (nonatomic, strong) VLCMediaPlayer *player;
/**
 *  播放器ui
 */
@property (nonatomic, strong) PlayerUIView *playerUIView;
/**
 *  播放器依附的ui
 */
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *videoTitle;
@property (nonatomic, strong) NSURL *videoURL;
/**
 *  是否暂停
 */
@property (nonatomic, assign, getter=isPause) BOOL pause;
/**
 *  是否隐藏弹幕
 */
@property (nonatomic, assign, getter=isHideDanMu) BOOL hideDanMu;

@property (nonatomic, assign, getter=isPlayerHidden) BOOL playerHidden;
@end

@implementation PlayerViewController
#pragma mark - 方法

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.playVM getDanMuCompletionHandler:^(NSError *error) {
        JHVLCMedia *m = [[JHVLCMedia alloc] initWithURL: self.videoURL];
        __weak typeof(self)weakSelf = self;
        [m parseWithBlock:^(VLCMedia *aMedia) {
            weakSelf.player = [[VLCMediaPlayer alloc] initWithOptions:nil];
            [weakSelf.player setMedia: m];
            weakSelf.player.drawable = weakSelf.playerView;
            [weakSelf startPlay];
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    [self.rander stop];
    [self.player stop];
}

- (instancetype)initWithModel:(id)model provider:(NSString *)provider videoURL:(NSURL *)videoURL videoTitle:(NSString *)videoTitle{
    if (self = [super init]) {
        self.videoTitle = videoTitle;
        self.videoURL = videoURL;
        self.playVM = [[PlayViewModel alloc] initWithModel:model provider:provider];
    }
    return self;
}
/**
 *  获取视频时长
 *
 *  @return 时长浮点数
 */
- (CGFloat)videoTime{
    return self.player.media.length.numberValue.floatValue / 1000;
}
/**
 *  获取视频当前时间
 *
 *  @return 当前时间浮点值
 */
- (CGFloat)currentSecond{
    return self.player.time.numberValue.floatValue / 1000;
}
/**
 *  视频和弹幕一起播放
 */
- (void)videoAndDanMuPlay{
    [self.rander start];
    [self.player play];
}
/**
 *  视频和弹幕一起暂停
 */
- (void)videoAndDanMuPause{
    [self.rander pause];
    [self.player pause];
}

- (void)startPlay{
    [self videoAndDanMuPlay];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(playDanmu) userInfo: nil repeats: YES];
}
//播放弹幕
- (void)playDanmu{
    //暂停状态直接返回
    if (self.isPause) return;
    //播放弹幕
    NSArray* danMus = [self.playVM currentSecondDanMuArr: [self currentSecond]];
    [danMus enumerateObjectsUsingBlock:^(DanMuDataModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.rander receive: [BarrageDescriptor descriptorWithText: obj.message color: obj.color style: obj.mode fontSize:obj.fontSize]];
    }];
    //更新当前时间
    [self.playerUIView updateCurrentTime: [self currentSecond] bufferTime: 0];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    !self.isPlayerHidden?[self.playerUIView showPlayer]:[self.playerUIView hiddenPlayer];
    self.playerHidden = !self.isPlayerHidden;
}

#pragma mark - 横屏代码
- (BOOL)shouldAutorotate{
    return NO;
} //NS_AVAILABLE_IOS(6_0);当前viewcontroller是否支持转屏

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
} //当前viewcontroller支持哪些转屏方向

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}


#pragma mark - PlayerUIView
- (void)playerTouchBackArrow:(PlayerUIView*)UIView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)playerTouchDanMuButton:(PlayerUIView*)UIView{
    self.isHideDanMu?[self.rander start]:[self.rander stop];
    self.hideDanMu = !self.isHideDanMu;
}
- (void)playerTouchPlayerButton:(PlayerUIView*)UIView{
    self.isPause?[self videoAndDanMuPlay]:[self videoAndDanMuPause];
    self.pause = !self.isPause;
}
- (void)playerTouchSlider:(PlayerUIView*)UIView slideValue:(CGFloat)value{
    [self.player setPosition: value];
}

#pragma mark - 懒加载

- (PlayerUIView *)playerUIView {
    if(_playerUIView == nil) {
        _playerUIView = [[PlayerUIView alloc] initWithTitle: self.videoTitle videoTime: [self videoTime]];
        _playerUIView.alpha = 0;
        _playerUIView.delegate = self;
        __weak typeof(self)weakSelf = self;
        [_playerUIView updateValue:^{
            weakSelf.playerHidden = !weakSelf.isPlayerHidden;
        }];
        [self.view insertSubview:_playerUIView atIndex: 4];
        [_playerUIView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _playerUIView;
}


- (BarrageRenderer *)rander{
	if(_rander == nil) {
		_rander = [[BarrageRenderer alloc] init];
        _rander.delegate = self;
        [_rander setSpeed: 1];
        [self.view insertSubview:_rander.view atIndex: 3];
	}
	return _rander;
}

- (UIView *)playerView{
	if(_playerView == nil) {
		_playerView = [[UIView alloc] init];
        [self.view insertSubview:_playerView atIndex: 2];
        [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];   
	}
	return _playerView;
}


@end
