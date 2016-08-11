//
//  TestView.m
//  JustTest
//
//  Created by HChong on 16/8/4.
//  Copyright © 2016年 HChong. All rights reserved.
//

#import "TestView.h"
#import "POP.h"

@interface TestView()

//@property (nonatomic, strong) CAShapeLayer *constantLayer;
//@property (nonatomic, strong) CAShapeLayer *removeLayer;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGPoint constantPoint;
@property (nonatomic, assign) CGFloat constantRadius;
@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, assign) CGFloat touchRadius;
@end

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.constantPoint = CGPointMake(100, 200);
        self.constantRadius = 10;
        self.touchRadius = 15;
        [self addSubview:self.label];
        self.touchPoint = self.label.center;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self createConstantLabel];
//    [self createRemoveableLabel];
    [self createLine];
}

#pragma mark - Private
- (void)panAction:(UITapGestureRecognizer *)sender {
    self.touchPoint = [sender locationInView:self];
    NSLog(@"touch Point : %f, %f", _touchPoint.x, _touchPoint.y);
    
    UIView *touchView = sender.view;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            break;
        }
        case UIGestureRecognizerStateChanged:{
            touchView.center = self.touchPoint;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            self.touchPoint = [sender locationInView:self];
            [self springAnimation:self.label fromPoint:self.touchPoint toPoint:self.constantPoint];
            break;
        }
        default:
            break;
    }
    [self setNeedsDisplay];
}

//初始位置
- (void)createConstantLabel {
    [self createCircleWithRadius:self.constantRadius color:[UIColor yellowColor] center:self.constantPoint];
}

//跟随手势移动的位置
- (void)createRemoveableLabel {
    [self createCircleWithRadius:self.touchRadius color:[UIColor blueColor] center:self.touchPoint];
}

- (void)createLine {
    float circle1_x = self.constantPoint.x;
    float circle1_y = self.constantPoint.y;
    float circle2_x = self.touchPoint.x;
    float circle2_y = self.touchPoint.y;
    float _distance = sqrt(powf(circle1_x - circle2_x, 2) + powf(circle1_y - circle2_y, 2));

    //连心线x轴的夹角
    float angle1 = atan((circle2_y - circle1_y) / (circle1_x - circle2_x));
    //连心线和公切线的夹角
    float angle2 = asin((self.constantRadius - self.touchRadius) / _distance);
    //切点到圆心和x轴的夹角
    float angle3 = M_PI_2 - angle1 - angle2;
    float angle4 = M_PI_2 - angle1 + angle2;
    
    //    NSLog(@"angle1:%f, angle2:%f, angle3:%f ", angle1, angle2, angle3);
    
    float offset1_X = cos(angle3) * self.constantRadius;
    float offset1_Y = sin(angle3) * self.constantRadius;
    float offset2_X = cos(angle3) * self.touchRadius;
    float offset2_Y = sin(angle3) * self.touchRadius;
    float offset3_X = cos(angle4) * self.constantRadius;
    float offset3_Y = sin(angle4) * self.constantRadius;
    float offset4_X = cos(angle4) * self.touchRadius;
    float offset4_Y = sin(angle4) * self.touchRadius;
    
    float p1_x = circle1_x - offset1_X;
    float p1_y = circle1_y - offset1_Y;
    float p2_x = circle2_x - offset2_X;
    float p2_y = circle2_y - offset2_Y;
    float p3_x = circle1_x + offset3_X;
    float p3_y = circle1_y + offset3_Y;
    float p4_x = circle2_x + offset4_X;
    float p4_y = circle2_y + offset4_Y;
    
    CGPoint p1 = CGPointMake(p1_x, p1_y);
    CGPoint p2 = CGPointMake(p2_x, p2_y);
    CGPoint p3 = CGPointMake(p3_x, p3_y);
    CGPoint p4 = CGPointMake(p4_x, p4_y);
    
    //画切线
    //    [_path moveToPoint:p1];
    //    [self drawLineStartAt:p1 EndAt:p2];
    //    [_path moveToPoint:p3];
    //    [self drawLineStartAt:p3 EndAt:p4];
    
    //连心线中点坐标(用来作为控制点）
    //    CGPoint d_center = CGPointMake((circle1_x + circle2_x) / 2, (circle1_y + circle2_y) / 2);
    
    //TX设计师描述的控制点算法
    CGPoint p1_center_p4 = CGPointMake((p1_x + p4_x) / 2, (p1_y + p4_y) / 2);
    CGPoint p2_center_p3 = CGPointMake((p2_x + p3_x) / 2, (p2_y + p3_y) / 2);
    
    [self drawBezierCurveStartAt:p1 EndAt:p2 controlPoint:p2_center_p3];
    [self drawLineStartAt:p2 EndAt:p4];
    [self drawBezierCurveStartAt:p4 EndAt:p3 controlPoint:p1_center_p4];
    [self drawLineStartAt:p3 EndAt:p1];
    
    [_path moveToPoint:p1];
    [_path closePath];
    
    [_path fill];
}

- (void)drawLineStartAt:(CGPoint)startPoint EndAt:(CGPoint)endPoint {
    [_path addLineToPoint:endPoint];
}

- (void)drawBezierCurveStartAt:(CGPoint)startPoint EndAt:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint {
    [_path moveToPoint:startPoint];
    [_path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
}

- (void)springAnimation:(UIView *)view fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint{
    //计算fromPoint在view的superView为坐标系里的坐标
    CGPoint viewPoint = self.constantPoint;
    fromPoint.x = fromPoint.x - viewPoint.x + toPoint.x;
    fromPoint.y = fromPoint.y - viewPoint.y + toPoint.y;
    
    view.center = fromPoint;
    self.touchPoint = view.center;
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    anim.fromValue = [NSValue valueWithCGPoint:fromPoint];
    anim.toValue = [NSValue valueWithCGPoint:toPoint];
    
    anim.springBounciness = 4.f;    //[0-20] 弹力 越大则震动幅度越大
    anim.springSpeed = 10.f;        //[0-20] 速度 越大则动画结束越快
    anim.dynamicsMass = 3.f;        //质量
    anim.dynamicsFriction = 30.f;   //摩擦，值越大摩擦力越大，越快结束弹簧效果
    anim.dynamicsTension = 676.f;   //拉力
    
    [view pop_addAnimation:anim forKey:kPOPLayerPosition];
    
    NSLog(@"源Point = %f , %f", fromPoint.x, fromPoint.y);
    NSLog(@"目标point = %f, %f", toPoint.x, toPoint.y);
}

- (CGPoint)getGlobalCenterPositionOf:(UIView *)view {
    
    CGPoint point  = [self getGlobalPositionOf:view];
    
    float w = view.frame.size.width;
    float h = view.frame.size.height;
    
    point.x += w/2;
    point.y += h/2;
    point.y -= 64;
    
    return point;
}

- (CGPoint)getGlobalPositionOf:(UIView *)view {
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[view convertRect: view.bounds toView:window];
    return rect.origin;
}

- (void)createCircleWithRadius:(CGFloat)radius color:(UIColor *)color center:(CGPoint)center{
    [self.path addArcWithCenter:center radius:radius startAngle:0 endAngle:360 clockwise:YES];
    [color set];
    [self.path fill];
    [self.path removeAllPoints];
}

#pragma mark - Getter && Setter
- (UIBezierPath *)path {
    if (!_path) {
        _path = [UIBezierPath bezierPath];
    }
    return _path;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 50, 30)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.layer.cornerRadius = 15;
        _label.text = @"@";
        _label.layer.masksToBounds = YES;
        _label.userInteractionEnabled = YES;
        _label.center = self.constantPoint;
        _label.backgroundColor = [UIColor colorWithRed:0.0 green:0.502 blue:0.502 alpha:1];
        UIPanGestureRecognizer *pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_label addGestureRecognizer:pan];
    }
    return _label;
}
@end
