//
//  userModel.m
//  Autumn
//
//  Created by figaro on 2017/10/25.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#import "userModel.h"

@implementation userModel
//这个方法是把所有的属性全部设置为可选值，这样就算后台传过来的值是空值，也没有关系
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
