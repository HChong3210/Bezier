//
//  DragView.m
//  JustTest
//
//  Created by HChong on 16/8/1.
//  Copyright © 2016年 HChong. All rights reserved.
//

#import "DragView.h"

@interface DragView()

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation DragView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self createConstantLabel];
    [self createRemoveableLabel];
    [self createLine];
}

#pragma mark - Private
- (void)createConstantLabel {
    [self createCircleWithRadius:30 color:[UIColor redColor] center:self.touchPoint];
}

- (void)createRemoveableLabel {
    [self createCircleWithRadius:40 color:[UIColor blueColor] center:self.touchPoint];
}

- (void)createLine {
    
}

- (void)createCircleWithRadius:(CGFloat)radius color:(UIColor *)color center:(CGPoint)center{
    [self.path addArcWithCenter:center radius:radius startAngle:0 endAngle:360 clockwise:YES];
    [[UIColor redColor] set];
    [self.path fill];
    self.shapeLayer.path = self.path.CGPath;
//    [self setNeedsDisplay];
}

#pragma mark - Public
- (void)vc:(UIViewController *)vc addObserve:(id)sender {
    self.viewController = (UIViewController *)vc;
    UIPanGestureRecognizer *pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [sender addGestureRecognizer:pan];
}

#pragma mark - Private
- (void)panAction:(UITapGestureRecognizer *)sender {
    self.touchPoint = [sender locationInView:self];
    NSLog(@"touch Point : %f, %f", _touchPoint.x, _touchPoint.y);
    
    UIView *touchView = sender.view;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            for (UIView *view in self.subviews) {
                [view removeFromSuperview];
            }
            [self.viewController.view addSubview:self];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            touchView.center = self.touchPoint;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            self.touchPoint = [sender locationInView:self];
            [self removeFromSuperview];
            break;
        }
        default:
            break;
    }

}

#pragma mark - Getter
-(UIBezierPath *)path {
    if (!_path) {
        _path = [UIBezierPath bezierPath];
    }
    return _path;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
    }
    return _shapeLayer;
}

@end
