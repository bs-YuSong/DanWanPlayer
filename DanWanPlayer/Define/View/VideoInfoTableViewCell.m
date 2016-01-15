//
//  VideoInfoTableViewCell.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/25.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "VideoInfoTableViewCell.h"
@interface VideoInfoTableViewCell()
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation VideoInfoTableViewCell
- (void)setWithCoverImg:(UIImage *)coverImg title:(NSString *)title time:(NSString *)time{
    [self.coverImgView setImage: coverImg];
    self.titleLabel.text = title;
    self.timeLabel.text = time;
}

- (UIImageView *)coverImgView {
	if(_coverImgView == nil) {
		_coverImgView = [[UIImageView alloc] init];
        [self addSubview: _coverImgView];
        [_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(106);
            make.height.mas_equalTo(66);
            make.top.left.mas_offset(10);
            make.bottom.mas_offset(-10);
        }];
	}
	return _coverImgView;
}

- (UILabel *)titleLabel {
	if(_titleLabel == nil) {
		_titleLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 1;
        [self addSubview: _titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.coverImgView);
            make.left.equalTo(self.coverImgView.mas_right).mas_offset(10);
            make.right.mas_offset(-10);
        }];
	}
	return _titleLabel;
}

- (UILabel *)timeLabel {
	if(_timeLabel == nil) {
		_timeLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize: 13];
        [_timeLabel setTextColor: kRGBColor(130, 130, 130)];
        [self addSubview: _timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(10);
        }];
	}
	return _timeLabel;
}

@end
