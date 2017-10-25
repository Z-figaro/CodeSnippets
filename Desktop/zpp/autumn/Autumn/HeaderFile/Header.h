//
//  Header.h
//  Autumn
//
//  Created by cbgolf  on 2017/10/12.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#ifndef Header_h
#define Header_h

//强弱
#define weakify(var)   __weak typeof(var) weakSelf = var
#define strongify(var) __strong typeof(var) strongSelf = var

//COLOR
#define K_MAINCOLOR RGBCOLOR(87, 175, 158, 1)   //MainGreen
//URL
#import "URLFile.h"
//常用文件
#import "ZPPAccountTool.h"                         //用户缓存信息
#import "UIButton+LXMImagePosition.h"                 //button图文位置工具
#import "UIView+Extensions.h"                          //view获取高宽等等
#import "QMUIKit.h"                                     //腾讯出的一套UI框架
#import "UIView+TargetAction.h"                        //给view添加点击事件
#import "BANetManager.h"                     //网络请求框架
#import "checkNumber.h"                                 //检查字符串的正则
#import <SVProgressHUD/SVProgressHUD.h>                 //提示框架
#import "DES3EncryptUtil.h"                             //des加密
#import <AFNetworking/AFNetworking.h>
#import "HttpManager.h"
#import "NSObject+modelProperty.h"                  //打印出model属性list
//model
#import "userModel.h"
//UI库
#import "MGOLabel.h"
#import "MGOButton.h"
#import "MGOTextField.h"
#import "UIView+MGO.h"

#endif /* Header_h */
