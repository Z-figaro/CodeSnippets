//
//  AppDelegate.h
//  Autumn
//
//  Created by 张鹏 on 2017/9/30.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 页面适配:x
 */
@property float autoSizeScaleX;

/**
 页面适配:y
 */
@property float autoSizeScaleY;

/**
 storyboard页面适配方法
 
 @param allView 输入self.view
 */
+ (void)storyBoradAutoLay:(UIView *)allView;
@end

