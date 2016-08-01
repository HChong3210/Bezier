//
//  ViewController.m
//  JustTest
//
//  Created by HChong on 16/7/28.
//  Copyright © 2016年 HChong. All rights reserved.
//

#import "MyViewController1.h"
#import "DrugRemoveLabel.h"
#import "BezierView.h"

@interface MyViewController1 ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) DrugRemoveLabel *redLabel;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) BezierView *bezierView;
@end

@implementation MyViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.label];
    [self.label addSubview:self.redLabel];
    
    [self.view addSubview:self.bezierView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(100, 100, 100, 100);
        _label.backgroundColor = [UIColor greenColor];
    }
    return _label;
}

-(DrugRemoveLabel *)redLabel {
    if (!_redLabel) {
        _redLabel = [[DrugRemoveLabel alloc] initWithContent:@"100"];
    }
    return _redLabel;
}

-(BezierView *)bezierView {
    if (!_bezierView) {
        _bezierView = [[BezierView alloc] init];
        _bezierView.frame = CGRectMake(100, 300, 200, 200);
    }
    return _bezierView;
}

@end
