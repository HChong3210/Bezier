//
//  MyViewController3.m
//  JustTest
//
//  Created by HChong on 16/8/1.
//  Copyright © 2016年 HChong. All rights reserved.
//

#import "MyViewController3.h"
#import "TestView.h"

@interface MyViewController3 ()

@property (nonatomic, strong) TestView *testView;
@end

@implementation MyViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.testView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
}

#pragma mark - Private


#pragma mark - Getter && Setter
- (TestView *)testView {
    if (!_testView) {
        _testView = [[TestView alloc] initWithFrame:self.view.frame];
        _testView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.0];
    }
    return _testView;
}
@end
