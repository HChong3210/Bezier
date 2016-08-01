//
//  DrugRemoveLabel.m
//  JustTest
//
//  Created by HChong on 16/7/28.
//  Copyright © 2016年 HChong. All rights reserved.
//

#import "DrugRemoveLabel.h"

@interface DrugRemoveLabel()

@property (nonatomic, strong) NSString *content;
@end

@implementation DrugRemoveLabel

- (instancetype)initWithContent:(NSString *)content {
    self = [super init];
    if (self) {
        self.content = content;
        
    }
    return self;
}



@end
