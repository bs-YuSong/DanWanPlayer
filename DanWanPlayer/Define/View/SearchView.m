//
//  SearchView.m
//  BiliBili
//
//  Created by apple-jd24 on 15/12/14.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "SearchView.h"


@interface SearchView()
/**
 *  搜索框
 */
@property (nonatomic, strong)UITextField* searchTextField;
/**
 *  搜索确认按钮
 */
@property (nonatomic, strong)UIButton* searchButton;
@end


@implementation SearchView

- (instancetype)init{
    if (self = [super init]) {
        self.searchButton.hidden = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UITextField *)searchTextField{
	if(_searchTextField == nil) {
		_searchTextField = [[UITextField alloc] init];
        _searchTextField.font = [UIFont systemFontOfSize: 13];
        _searchTextField.placeholder = @"  找不到？试试手动搜索";
        [self addSubview: _searchTextField];
        [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.mas_equalTo(0);
            make.right.mas_offset(-40);
        }];
	}
	return _searchTextField;
}


- (UIButton *)searchButton{
	if(_searchButton == nil) {
		_searchButton = [[UIButton alloc] init];
        _searchButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_searchButton setImage: [UIImage imageNamed:@"ic_search_query"] forState: UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(touchSearchButton) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: _searchButton];
        [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_offset(0);
            make.left.mas_equalTo(self.searchTextField.mas_right);
        }];
	}
	return _searchButton;
}

#pragma mark - 协议方法

- (void)touchSearchButton{
    if ([self.delegate respondsToSelector:@selector(searchButtonDown:searchText:)]) {
        [self.delegate searchButtonDown:self searchText:[self.searchTextField.text stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLPathAllowedCharacterSet]]];
    }
}
@end
