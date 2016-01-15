//
//  PlayerUIView.m
//  te
//
//  Created by apple-jd44 on 15/11/27.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "PlayerUIView.h"
#import "Masonry.h"
#import "PlayerSliderView.h"
//淡出时间
#define fadeTime 0.5
@interface PlayerUIView ()<PlayerSliderViewDelegate>
@property (nonatomic, strong) UIView* headView;
@property (nonatomic, strong) UIView* bottomView;
/**
 *  当前时间
 */
@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UIButton* titleButton;
@property (nonatomic, strong) UIButton* playButton;
@property (nonatomic, strong) UIButton* danMuButton;
/**
 *  格式化时间
 */
@property (nonatomic, strong) NSDateFormatter* formatter;
/**
 *  视频总时间
 */
@property (nonatomic, strong) NSString *videoTime;
@property (nonatomic, assign) CGFloat videoFloatTime;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) PlayerSliderView* slideView;
@end

@implementation PlayerUIView

- (instancetype)initWithTitle:(NSString*)title videoTime:(CGFloat)videoTime{
    if (self = [super init]) {
        [self.titleButton setTitle:title forState:UIControlStateNormal];
        self.videoFloatTime = videoTime;
        self.videoTime = [self formatterStringTimeWithCGFloatTime: videoTime];
        self.timeLabel.text = [@"00:00/" stringByAppendingString: self.videoTime];
        //初始化title
        [self addSubview: self.headView];
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height).multipliedBy(0.1);
        }];
        //初始化时间面板
        [self addSubview: self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height).multipliedBy(0.25);
        }]; 
    }
    return self;
}

#pragma mark - 方法

- (void)showPlayer{
    self.hidden = NO;
    [self.timer invalidate];
    [UIView animateWithDuration:fadeTime animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        //显示三秒后自动隐藏
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoHiddenPlayer) userInfo:nil repeats:NO];
    }];
}

- (void)hiddenPlayer{
    [self.timer invalidate];
    [UIView animateWithDuration:fadeTime animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

/**
 *  自动隐藏
 */
- (void)autoHiddenPlayer{
    if (_returnBlock) self.returnBlock();
    [self hiddenPlayer];
}

- (void)updateCurrentTime:(CGFloat)currentTime bufferTime:(CGFloat)bufferTime{
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",[self formatterStringTimeWithCGFloatTime: currentTime],self.videoTime];
    
    [self.slideView updateCurrentTime: currentTime / self.videoFloatTime];
}

- (void)updateValue:(handle) block{
    self.returnBlock = block;
}
/**
 *  把时间格式化
 *
 *  @param time 时间
 *
 *  @return 格式化之后的时间
 */
- (NSString *)formatterStringTimeWithCGFloatTime:(CGFloat)time{
    return [self.formatter stringFromDate: [NSDate dateWithTimeIntervalSinceReferenceDate: time]];
}

#pragma mark - 协议
- (void)playButtonTouchDown{
    self.playButton.selected = !self.playButton.isSelected;
    if([self.delegate respondsToSelector:@selector(playerTouchPlayerButton:)]){
        [self.delegate playerTouchPlayerButton: self];
    }
}

- (void)danMuButtonDown{
    if([self.delegate respondsToSelector:@selector(playerTouchDanMuButton:)]){
        [self.delegate playerTouchDanMuButton: self];
    }
}

- (void)arrowButtonDown{
    if([self.delegate respondsToSelector:@selector(playerTouchBackArrow:)]){
        [self.delegate playerTouchBackArrow: self];
    }
}

#pragma mark - PlayerSliderView

- (void)playerSliderTouchEnd:(CGFloat)endValue playerSliderView:(PlayerSliderView *)PlayerSliderView{
    if([self.delegate respondsToSelector:@selector(playerTouchSlider:slideValue:)]){
        [self.delegate playerTouchSlider: self slideValue: endValue];
    }
}


#pragma mark - 懒加载

- (UIView *)headView{
    if(_headView == nil) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    }
    return _headView;
}


- (UIView *)bottomView {
    if(_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        UIView* tempView = [[UIView alloc] init];
        [_bottomView addSubview: tempView];
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.slideView.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        [tempView addSubview: self.playButton];
        [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tempView).mas_offset(20);
            make.width.mas_equalTo(23);
            make.height.mas_equalTo(26);
            make.centerY.equalTo(tempView);
        }];
        
        [tempView addSubview: self.danMuButton];
        [self.danMuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.playButton);
            make.right.mas_offset(-20);
        }];
    }
    return _bottomView;
}

- (UILabel *)timeLabel{
    if(_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize: 15];
        _timeLabel.textColor = [UIColor whiteColor];
        [self.bottomView addSubview: _timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.playButton.mas_right).mas_offset(20);
            make.centerY.equalTo(self.playButton);
        }];
    }
    return _timeLabel;
}


- (NSDateFormatter *)formatter{
    if(_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"mm:ss"];
    }
    return _formatter;
}

- (PlayerSliderView *)slideView{
    if(_slideView == nil) {
        _slideView = [[PlayerSliderView alloc] initWithLineWidth:3 currentTimeColor:kRGBColor(92, 166, 251) bufferTimeColor:[UIColor grayColor] lineBackGroundColor:[UIColor whiteColor] thumbImg:nil];
        _slideView.delegate = self;
        [self.bottomView addSubview: _slideView];
        
        [_slideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.equalTo(self.bottomView);
            make.width.equalTo(self.bottomView).mas_offset(-20);
            make.height.mas_equalTo(self.bottomView.mas_height).multipliedBy(0.4);
        }];
    }
    return _slideView;
}

- (UIButton *) titleButton {
	if(_titleButton == nil) {
		_titleButton = [[UIButton alloc] init];
        _titleButton.titleLabel.font = [UIFont systemFontOfSize: 15];
        [_titleButton setImage:[UIImage imageNamed:@"bili_player_back_button"] forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(arrowButtonDown) forControlEvents:UIControlEventTouchUpInside];
        [self.headView addSubview: self.titleButton];
        [_titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(20);
            make.centerY.equalTo(self.headView);
        }];
	}
	return _titleButton;
}

- (UIButton *) playButton {
	if(_playButton == nil) {
        _playButton = [[UIButton alloc] init];
        UIImage *buttonNorImg = [[UIImage imageNamed:@"ic_action_download_play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage *buttonSelImg = [[UIImage imageNamed:@"ic_action_download_pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        _playButton.tintColor = [UIColor whiteColor];
        [_playButton setBackgroundImage:buttonNorImg forState:UIControlStateNormal];
        [_playButton setBackgroundImage:buttonSelImg forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonTouchDown) forControlEvents:UIControlEventTouchUpInside];

	}
	return _playButton;
}

- (UIButton *) danMuButton {
	if(_danMuButton == nil) {
		_danMuButton = [[UIButton alloc] init];
        [_danMuButton setImage:[UIImage imageNamed:@"ic_answer_danmaku2"] forState:UIControlStateNormal];
        [_danMuButton addTarget:self action:@selector(danMuButtonDown) forControlEvents:UIControlEventTouchUpInside];
        [_danMuButton setTitle:@" 弹幕开关" forState:UIControlStateNormal];
        _danMuButton.titleLabel.font = [UIFont systemFontOfSize: 12];
	}
	return _danMuButton;
}

@end
