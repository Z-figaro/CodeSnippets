//
//  MainTabbarController.m
//  Autumn
//
//  Created by cbgolf  on 2017/10/11.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#import "MainTabbarController.h"
#import "LoginAndRegisterViewController.h"

#import "Header.h"

@interface MainTabbarController ()<UITabBarControllerDelegate>

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];

    

    self.delegate = self;
   
   
}


//adjust the app start page strcture.(login or userCenter)
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
   
    if (viewController == self.viewControllers[1]) {
        /*** 赛事 ***/
        
    }
    
    if (viewController == self.viewControllers[2]) {//我的
        NSLog(@"我的被点击");
        //todo:if the user is logined. push to base.if not, go to loginAndRegister.
        if ([[ShareUserModel getUserLogin] isEqualToString:@"yes"]) {
            NSLog(@"用户已经登录");
        } else{
            [self goToLoginVC];
            return NO;
        }
    } else {
        MyLog(@"tabbar selected");
    }
    
    return YES;
}

#pragma mark - 页面跳转
-(void)goToLoginVC{
    
    NSLog(@"tabbar push to loginVC");
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"loginAndRegister" bundle:nil];
    LoginAndRegisterViewController *loginVC = [board instantiateViewControllerWithIdentifier:@"loginVC"];
    [self presentViewController:loginVC animated:YES completion:nil];
}



@end
