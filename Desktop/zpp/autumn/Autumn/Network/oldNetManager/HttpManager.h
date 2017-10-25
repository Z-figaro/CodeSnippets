//
//  HttpManager.h
//  iTailor
//
//  Created by han shuai on 2016/10/19.
//  Copyright © 2016年 hanshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^httpcomplete)(id response);
typedef void(^httpfail)(id response);

@interface HttpManager : NSObject

+ (AFHTTPSessionManager *)sharedAFHTTPSessionManager;

+ (NSURLSessionUploadTask *)post:(NSString *)url headerSets:(NSDictionary *)sets postBody:(NSDictionary *)postBody complete:(httpcomplete)complete fail:(httpfail)fail;

+ (NSURLSessionDataTask *)postraw:(NSString *)url headerSets:(NSDictionary *)sets postBody:(NSDictionary *)postBody complete:(httpcomplete)complete fail:(httpfail)fail;

+ (NSURLSessionDataTask *)get:(NSString *)url headerSets:(NSDictionary *)sets parameters:(NSDictionary *)parameters complete:(httpcomplete)complete fail:(httpfail)fail;

+ (NSURLSessionDataTask *)getExternalLinks:(NSString *)url headerSets:(NSDictionary *)sets parameters:(NSDictionary *)parameters complete:(httpcomplete)complete fail:(httpfail)fail;

+ (NSURLSessionDataTask *)put:(NSString *)url headerSets:(NSDictionary *)sets parameters:(NSDictionary *)parameters complete:(httpcomplete)complete fail:(httpfail)fail;

+ (NSURLSessionDataTask *)deleteWith:(NSString *)url headerSets:(NSDictionary *)sets parameters:(NSDictionary *)parameters complete:(httpcomplete)complete fail:(httpfail)fail;

+ (NSString *)joinUrl:(NSString *)url;
+ (NSString *)joinImgUrl:(NSString *)url;
+ (NSString *)host;

@end
