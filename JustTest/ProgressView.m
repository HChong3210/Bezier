//
//  ProgressView.m
//  JustTest
//
//  Created by HChong on 16/7/29.
//  Copyright © 2016年 HChong. All rights reserved.
//

/**
 可以采用两个layer一个Path也可采用一个layer两个Path
 */
#import "ProgressView.h"

@interface ProgressView()

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *backLayer;
@property (nonatomic, strong) UIBezierPath *progressPath;
@property (nonatomic, strong) UIBezierPath *backPath;
@property (nonatomic, assign) CGFloat progressValue;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, assign) BOOL isPause;
@end

@implementation ProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.isPause = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.progressLabel];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.layer addSublayer:self.backLayer];
    [self.layer addSublayer:self.progressLayer];
    
    self.backLayer.path = self.backPath.CGPath;
    self.progressLayer.path = self.progressPath.CGPath;
    
    [self circleAnimation:self.progressLayer];
}

#pragma mark - Private
- (void)animation {
    self.progressValue += 0.1;
    if (self.progressValue >= 1.f) {
        self.progressValue = 0.1f;
    }
}

- (void)circleAnimation:(CALayer*)layer {
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basic.duration = 3;
    basic.fromValue = @(0);
    basic.toValue = @(1);
//    basic.repeatCount = HUGE_VALF;
//    basic.removedOnCompletion = NO;
    basic.fillMode = kCAFillModeForwards;
    [layer addAnimation:basic forKey:@"StrokeEndKey"];
}

- (void)pauseAndStart {
    if (self.isPause == NO) {
        //取出当前动画的时间点，也就是暂停的时间点
        CFTimeInterval pausedTime = [self.progressLayer convertTime:CACurrentMediaTime() fromLayer:nil];
        //根据第一步取的暂停的时间点来设置时间偏移量，指定时间偏移量的目的是让动画定格在该时间点
        self.progressLayer.timeOffset = pausedTime;
        //将动画的运行速度设置为0，动画默认的运行速度是1.0
        self.progressLayer.speed = 0.0;
    } else {
        
        CFTimeInterval pausedTime = [self.progressLayer timeOffset];
        //让CALayer的时间继续行走
        self.progressLayer.speed = 1.0;
        //取消上次记录的停留时刻
        self.progressLayer.timeOffset = 0.0;
        //取消上次设置的时间
        self.progressLayer.beginTime = 0.0;
        //计算暂停的时间(这里也可以用CACurrentMediaTime()-pausedTime)
        CFTimeInterval timeSincePause = [self.progressLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        //设置相对于父坐标系的开始时间(往后退timeSincePause)
        self.progressLayer.beginTime = timeSincePause;
    }
    self.isPause = self.isPause == YES ? NO : YES;
}

#pragma mark - Getter
- (UIBezierPath *)backPath {
    if (!_backPath) {
        _backPath = [UIBezierPath bezierPath];
        [_backPath addArcWithCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                             radius:self.bounds.size.width / 2
                         startAngle:0
                           endAngle:M_PI * 2
                          clockwise:YES];
    }
    return _backPath;
}

- (UIBezierPath *)progressPath {
    if (!_progressPath) {
        _progressPath = [UIBezierPath bezierPath];
        [_progressPath addArcWithCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                         radius:self.bounds.size.width / 2
                     startAngle:0
                       endAngle:M_PI * 2
                      clockwise:YES];
    }
    return _progressPath;
}

- (CAShapeLayer *)backLayer {
    if (!_backLayer) {
        _backLayer = [CAShapeLayer layer];
        _backLayer.strokeColor = [UIColor whiteColor].CGColor;
        _backLayer.fillColor = nil;
        _backLayer.lineWidth = 4;
    }
    return _backLayer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = [UIColor blackColor].CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineWidth = 4;
        _progressLayer.lineDashPattern = @[@(4), @(4)];
        _progressLayer.speed = 1.0;
    }
    return _progressLayer;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.userInteractionEnabled = YES;
        _progressLabel.frame = CGRectMake(100 - 25, 100 - 10, 50, 20);
        _progressLabel.backgroundColor = [UIColor purpleColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseAndStart)];
        [_progressLabel addGestureRecognizer:tap];
    }
    return _progressLabel;
}
@end
