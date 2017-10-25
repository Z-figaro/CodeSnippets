//
//  URLFile.h
//  Autumn
//
//  Created by 张鹏 on 2017/10/16.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#ifndef URLFile_h
#define URLFile_h


#define BaseURL               @"http://test.cbgolf.cn/backend"




//注册登录
#define checkPhoneURL            @"/api/app/authenticate/phone"    //检查手机是否可以注册
#define loginURL                 @"/api/app/authenticate/user"  // 用户登录
//#define getRSAURL                   @"/api/app/permit/encryptions"          //暂时不使用,使用了des
#define getVerificationCodeURL   @"/api/app/profiles/captcha"    //获取验证码
#define registerURL              @"/api/app/profiles/user"       //用户注册
#define refindPasswordURL       @"/api/app/profiles/phone/"      //找回密码
#define registerWEB         @"http://c.cbgolf.cn/agreement/index.html?REG_AGREEMENT" //注册协议网页

//获得个人中心首页信息
#define getUserScoreURL         @"/api/app/playOrder/myTotals"    //获得个人中心首页信息（个人成绩查询）
#define getUserInfoURL            @"/api/app/profile"        //用户信息查询


//球场
#define getCourseListURL        @"/api/app/courses/all"             //获取球场信息













#endif /* URLFile_h */
