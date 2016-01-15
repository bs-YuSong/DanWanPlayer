//
//  ChooseDanMuViewController.m
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ChooseDanMuViewController.h"
#import "ChooseDanMuViewModel.h"
#import "VideoInfoModel.h"
#import "VideoModel.h"
#import "PlayerViewController.h"

@interface ChooseDanMuViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) ChooseDanMuViewModel *vm;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *chooseOverButton;
@property (nonatomic, assign) NSInteger episode;
@property (nonatomic, strong) VideoModel *model;
@end

@implementation ChooseDanMuViewController

#pragma mark -  方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.pickerView selectRow:self.episode inComponent:2 animated: NO];
    [self.view addSubview: self.chooseOverButton];
}

- (instancetype)initWithVideoDic:(NSDictionary *)dic episode:(NSInteger)episode model:(VideoModel *)model{
    if (self = [super init]) {
        self.vm = [[ChooseDanMuViewModel alloc] initWithVideoDic: dic];
        self.episode = episode;
        self.model = model;
    }
    return self;
}

- (void)downDanMu{
    NSInteger index0 = [self.pickerView selectedRowInComponent: 0];
    NSInteger index2 = [self.pickerView selectedRowInComponent: 2];
    NSURL *filePath = [NSURL fileURLWithPath: [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent: self.model.filePath]];
    
    [self presentViewController:[[PlayerViewController alloc] initWithModel:[self.vm danMuKuWithIndex: index2] provider:[self.vm supplierNameWithIndex: index0] videoURL:filePath videoTitle: [self.vm episodeTitleWithIndex: index2]] animated:YES completion:nil];
}

#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return [[UIScreen mainScreen] currentBounds].size.height / 6;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [self.vm supplierNum];
            break;
        case 1:
            return [self.vm shiBanNum];
            break;
        case 2:
            return [self.vm episodeNum];
            break;
        default:
            break;
    }
    return 0;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, view.size.width, view.size.height)];
        label.font = [UIFont systemFontOfSize: 20];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
    }
    
    switch (component) {
        case 0:
            label.text = [self.vm supplierNameWithIndex: row];
            break;
        case 1:
            label.text = [self.vm shiBanTitleWithIndex: row];
            break;
        case 2:
            label.text = [self.vm episodeTitleWithIndex: row];
            break;
        default:
            break;
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            self.vm.shiBanArr = self.vm.contentDic[self.vm.supplierArr[row]];
            self.vm.episodeTitleArr = self.vm.shiBanArr.firstObject.videos;
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            [self.pickerView selectRow:self.episode inComponent:2 animated: YES];
            [self.pickerView reloadAllComponents];
            break;
        case 1:
            self.vm.episodeTitleArr = self.vm.shiBanArr[row].videos;
            [self.pickerView selectRow:self.episode inComponent:2 animated: YES];
            [self.pickerView reloadAllComponents];
            break;
        case 2:
            self.episode = row;
            break;
        default:
            break;
    }
}


#pragma mark -  懒加载

- (UIPickerView *)pickerView {
	if(_pickerView == nil) {
		_pickerView = [[UIPickerView alloc] initWithFrame:self.view.frame];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        [self.view addSubview: _pickerView];
	}
	return _pickerView;
}

- (UIButton *)chooseOverButton {
	if(_chooseOverButton == nil) {
		_chooseOverButton = [UIButton buttonWithType: UIButtonTypeSystem];
        _chooseOverButton.frame = CGRectMake(0, 0, 100, 50);
        _chooseOverButton.titleLabel.font = [UIFont systemFontOfSize: 20];
        [_chooseOverButton setTitle:@"确认" forState: UIControlStateNormal];
        CGPoint center = self.view.center;
        center.y = [UIScreen mainScreen].bounds.size.height - 80;
        _chooseOverButton.center = center;
        [_chooseOverButton addTarget:self action:@selector(downDanMu) forControlEvents:UIControlEventTouchUpInside];
	}
	return _chooseOverButton;
}

@end
