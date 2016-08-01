//
//  BezierView.m
//  JustTest
//
//  Created by HChong on 16/7/28.
//  Copyright © 2016年 HChong. All rights reserved.
//

#import "BezierView.h"

@interface BezierView()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CABasicAnimation *basicAnimation;
@property (nonatomic, assign) CGFloat start;
@property (nonatomic, assign) CGFloat end;
@end

@implementation BezierView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.start = M_PI * 3 / 4;
        self.end = (M_PI * 2) + M_PI_4;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)buttonAction:(id)action {
    NSLog(@"click");
}

#pragma mark - OverWrite
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.progressLayer.path = self.path.CGPath;
    [self.layer addSublayer:self.progressLayer];
    
    self.shapeLayer.path = self.path.CGPath;
    [self.layer addSublayer:self.shapeLayer];
    [self drawAnimaion];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGPathContainsPoint([self.shapeLayer path], NULL, point, ([self.shapeLayer fillRule] == kCAFillRuleEvenOdd))) {
        return [super hitTest:point withEvent:event];
    }
    return nil;
}

#pragma mark - Private
- (void)drawAnimaion {
    [self.progressLayer addAnimation:self.basicAnimation forKey:@"progressAnimation"];
}

#pragma mark - Getter
-(UIBezierPath *)path {
    if (!_path) {
        _path = [UIBezierPath bezierPath];
        [_path addArcWithCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                         radius:100
                     startAngle:self.start
                       endAngle:self.end
                      clockwise:YES];
    }
    return _path;
}

-(CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.lineWidth = 8;
//        _shapeLayer.lineCap = kCALineCapRound;
        [_shapeLayer setLineDashPattern:@[@(5), @(5)]];//间隔 宽度
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _shapeLayer;
}

-(CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.lineWidth = 8;
        _progressLayer.strokeColor = [UIColor blueColor].CGColor;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _progressLayer;
}

- (CABasicAnimation *)basicAnimation {
    if (!_basicAnimation) {
        _basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _basicAnimation.toValue = [NSNumber numberWithFloat:self.end];
        _basicAnimation.duration = 1;
        _basicAnimation.cumulative = YES;
        _basicAnimation.repeatCount = HUGE_VALF;
    }
    return _basicAnimation;
}


@end
