//
//  DragView.h
//  JustTest
//
//  Created by HChong on 16/8/1.
//  Copyright © 2016年 HChong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragView : UIView <UIGestureRecognizerDelegate>

- (void)vc:(UIViewController *)vc addObserve:(id)sender;
@end
