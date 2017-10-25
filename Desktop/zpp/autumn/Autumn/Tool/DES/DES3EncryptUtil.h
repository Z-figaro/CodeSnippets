//
//  DES3EncryptUtil.h
//  tabbar
//
//  Created by cbgolf  on 2017/10/20.
//  Copyright © 2017年 cbgolf . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3EncryptUtil : NSObject
// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;
@end
