//
//  MyViewController2.m
//  JustTest
//
//  Created by HChong on 16/7/29.
//  Copyright © 2016年 HChong. All rights reserved.
//

#import "MyViewController2.h"
#import "ProgressView.h"

@interface MyViewController2 ()

@property (nonatomic, strong) ProgressView *progressView;
@end

@implementation MyViewController2

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.502 blue:0.0 alpha:1.0];
    [self.view addSubview:self.progressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Getter
- (ProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[ProgressView alloc] init];
        _progressView.frame = CGRectMake(100, 200, 200, 200);
    }
    return _progressView;
}

@end
