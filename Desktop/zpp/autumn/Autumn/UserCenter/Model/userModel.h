//
//  userModel.h
//  Autumn
//
//  Created by figaro on 2017/10/25.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface userModel : JSONModel
@property (nonatomic, strong) NSString *phoneInfo;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *profileNumber;
@property (nonatomic, strong) NSString *isOnline;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSNumber *lastUpdate;
@property (nonatomic, strong) NSString *invitationCode;
@property (nonatomic, copy) NSString *mobilePhoneNumber;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSNumber *balance;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *bestGrades;
@property (nonatomic, strong) NSNumber *createdDate;
@property (nonatomic, strong) NSString *ballAge;
@property (nonatomic, copy) NSString *mobilePhoneNumberReplaced;
@property (nonatomic, strong) NSString *isEnable;
@property (nonatomic, copy) NSString *invitationCodeOfMy;
@property (nonatomic, copy) NSString *headPicture;
@property (nonatomic, strong) NSNumber *couponNumber;
@property (nonatomic, strong) NSString *ballBrand;
@property (nonatomic, strong) NSString *defaultDeliveryInfoId;
@property (nonatomic, strong) NSString *integral;
@end
