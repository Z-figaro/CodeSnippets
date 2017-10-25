//
//  NSObject+modelProperty.h
//  Autumn
//
//  Created by figaro on 2017/10/25.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (modelProperty)

/**
 打印出需要的网络请求数据model的属性

 @param dict model的名称（字典）
 */
+(void)propertyCodeWithDictionary:(NSDictionary *)dict;
@end
