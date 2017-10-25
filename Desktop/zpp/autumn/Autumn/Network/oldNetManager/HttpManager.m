//
//  HttpManager.m
//  iTailor
//
//  Created by han shuai on 2016/10/19.
//  Copyright © 2016年 hanshuai. All rights reserved.
//

#import "HttpManager.h"
//#import "Config.h"

//static NSString *hostUrl = @"http://192.168.1.112:8080/";//开发
//static NSString *hostUrl = @"http://192.168.1.210:8080/";//韩冰
static NSString *hostUrl = @"http://test.cbgolf.cn/";//测试
//static NSString *hostUrl = @"http://api.cbgolf.cn/";//外网
//static NSString *hostUrl = @"http://192.168.1.200:8080/";//韩冰K

static NSString *imghostUrl = @"http://itailor.oss-cn-beijing.aliyuncs.com";

static AFHTTPSessionManager *manager ;

@implementation HttpManager

+ (AFHTTPSessionManager *)sharedAFHTTPSessionManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    return manager;
}

+ (NSURLSessionUploadTask *)post:(NSString *)url headerSets:(NSDictionary *)sets postBody:(NSDictionary *)postBody complete:(httpcomplete)complete fail:(httpfail)fail
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[HttpManager joinUrl:[NSString stringWithFormat:@"backend/%@",url]] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSString *key in postBody.allKeys) {
            if ([[postBody objectForKey:key] isKindOfClass:[NSArray class]]) {
                [formData appendPartWithFormData:[NSKeyedArchiver archivedDataWithRootObject:[postBody objectForKey:key]] name:key];
            }
            else
            {
                [formData appendPartWithFormData:[[postBody objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding] name:key];
            }
        }
    } error:nil];
    
    AFHTTPSessionManager *manager = [HttpManager sharedAFHTTPSessionManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.f;

    for (NSString *key in [sets allKeys]) {
//        [manager.requestSerializer setValue:[sets objectForKey:key] forHTTPHeaderField:key];
        [request setValue:[sets objectForKey:key] forHTTPHeaderField:key];
    }

    NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
            NSData *errData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            id responseObj = nil;
            if (errData) {
                responseObj = [NSJSONSerialization JSONObjectWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                if (responseObj == nil) {
                    responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
                }
            }
            else
            {
                responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
            }
            if (statusCode == 401 || statusCode == 40101 || [[responseObj objectForKey:@"status"] integerValue]) {

//                [Config storeUserInfo:nil];
                [self postLoginNotification:statusCode];
            }
            
            if (fail) {
                fail(@{@"code":[NSNumber numberWithInteger:statusCode],@"msg":[responseObj objectForKey:@"message"]});
            }
        }
        else
        {
            NSDictionary *responseData = [self handleResponseComplete:response responseObject:responseObject];
            if (complete) {
                complete(responseData);
            }
        }
    }];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)postraw:(NSString *)url headerSets:(NSDictionary *)sets postBody:(NSDictionary *)postBody complete:(httpcomplete)complete fail:(httpfail)fail
{
    AFHTTPSessionManager *manager = [HttpManager sharedAFHTTPSessionManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.f;

    for (NSString *key in [sets allKeys]) {
        [manager.requestSerializer setValue:[sets objectForKey:key] forHTTPHeaderField:key];
    }

    NSURLSessionDataTask *task = [manager POST:[HttpManager joinUrl:[NSString stringWithFormat:@"backend/%@",url]] parameters:postBody progress:^(NSProgress * _Nonnull uploadProgress) {
        //这里可以获取到目前的数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseData = [self handleComplete:task responseObject:responseObject];
        if (complete) {
            complete(responseData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSInteger statusCode = [((NSHTTPURLResponse*)task.response) statusCode];
        NSData *errData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        id responseObj = nil;
        if (errData) {
            responseObj = [NSJSONSerialization JSONObjectWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (responseObj == nil) {
                responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
            }
        }
        else
        {
            responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
        }
        if (statusCode == 401 || statusCode == 40101 || [[responseObj objectForKey:@"status"] integerValue]) {

//            [Config storeUserInfo:nil];
            [self postLoginNotification:statusCode];
        }
        
        if (fail) {
            fail(@{@"code":[NSNumber numberWithInteger:statusCode],@"msg":[responseObj objectForKey:@"message"]});
        }
    }];
    
    return task;
}


+ (NSURLSessionDataTask *)get:(NSString *)url parameters:(NSDictionary *)parameters complete:(httpcomplete)complete fail:(httpfail)fail
{
    AFHTTPSessionManager *manager = [HttpManager sharedAFHTTPSessionManager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.f;

    NSURLSessionDataTask *task = [manager GET:[HttpManager joinUrl:[NSString stringWithFormat:@"backend/%@",url]] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseData = [self handleComplete:task responseObject:responseObject];
        if (complete) {
            complete(responseData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [((NSHTTPURLResponse*)task.response) statusCode];
        NSData *errData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        id responseObj = nil;
        if (errData) {
            responseObj = [NSJSONSerialization JSONObjectWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (responseObj == nil) {
                responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
            }
        }
        else
        {
            responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
        }
        if (statusCode == 401 || statusCode == 40101 || [[responseObj objectForKey:@"status"] integerValue]) {

//            [Config storeUserInfo:nil];
            [self postLoginNotification:statusCode];
        }
        
        if (fail) {
            fail(@{@"code":[NSNumber numberWithInteger:statusCode],@"msg":[responseObj objectForKey:@"message"]});
        }
    }];
    return task;
}

+ (NSURLSessionDataTask *)get:(NSString *)url headerSets:(NSDictionary *)sets parameters:(NSDictionary *)parameters complete:(httpcomplete)complete fail:(httpfail)fail
{
    AFHTTPSessionManager *manager = [HttpManager sharedAFHTTPSessionManager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.f;
  
    for (NSString *key in [sets allKeys]) {
        [manager.requestSerializer setValue:[sets objectForKey:key] forHTTPHeaderField:key];
    }
    
    NSURLSessionDataTask *task = [manager GET:[HttpManager joinUrl:[NSString stringWithFormat:@"backend/%@",url]] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseData = [self handleComplete:task responseObject:responseObject];
        if (complete) {
            complete(responseData);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSInteger statusCode = [((NSHTTPURLResponse*)task.response) statusCode];
        NSData *errData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        id responseObj = nil;
        if (errData) {
            responseObj = [NSJSONSerialization JSONObjectWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (responseObj == nil) {
                responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
            }
        } else {
            responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
        }
        
        if (statusCode == 401 || statusCode == 40101 || [[responseObj objectForKey:@"status"] integerValue]) {

//            [Config storeUserInfo:nil];
            [self postLoginNotification:statusCode];
        }
        
        if (fail) {
            fail(@{@"code":[NSNumber numberWithInteger:statusCode],@"msg":[responseObj objectForKey:@"message"]});
        }
    }];
    
    return task;
}

+ (NSURLSessionDataTask *)getExternalLinks:(NSString *)url headerSets:(NSDictionary *)sets parameters:(NSDictionary *)parameters complete:(httpcomplete)complete fail:(httpfail)fail
{
    AFHTTPSessionManager *manager = [HttpManager sharedAFHTTPSessionManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.f;
    
    for (NSString *key in [sets allKeys]) {
        [manager.requestSerializer setValue:[sets objectForKey:key] forHTTPHeaderField:key];
    }
    
    NSURLSessionDataTask *task = [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseData = [self handleComplete:task responseObject:responseObject];
        if (complete) {
            complete(responseData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [((NSHTTPURLResponse*)task.response) statusCode];
        NSData *errData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        id responseObj = nil;
        if (errData) {
            responseObj = [NSJSONSerialization JSONObjectWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (responseObj == nil) {
                responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
            }
        }
        else
        {
            responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
        }
        if (statusCode == 401 || statusCode == 40101 || [[responseObj objectForKey:@"status"] integerValue]) {

//            [Config storeUserInfo:nil];
            [self postLoginNotification:statusCode];
        }
        
        if (fail) {
            fail(@{@"code":[NSNumber numberWithInteger:statusCode],@"msg":[responseObj objectForKey:@"message"]});
        }
    }];
    return task;
}


+ (NSURLSessionDataTask *)put:(NSString *)url headerSets:(NSDictionary *)sets parameters:(NSDictionary *)parameters complete:(httpcomplete)complete fail:(httpfail)fail
{
    AFHTTPSessionManager *manager = [HttpManager sharedAFHTTPSessionManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.f;

    for (NSString *key in [sets allKeys]) {
        [manager.requestSerializer setValue:[sets objectForKey:key] forHTTPHeaderField:key];
    }

    NSURLSessionDataTask *task = [manager PUT:[HttpManager joinUrl:[NSString stringWithFormat:@"backend/%@",url]] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseData = [self handleComplete:task responseObject:responseObject];
        if (complete) {
            complete(responseData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [((NSHTTPURLResponse*)task.response) statusCode];
        NSData *errData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        id responseObj = nil;
        if (errData) {
            responseObj = [NSJSONSerialization JSONObjectWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (responseObj == nil) {
                responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
            }
        }
        else
        {
            responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
        }
        if (statusCode == 401 || statusCode == 40101 || [[responseObj objectForKey:@"status"] integerValue]) {

//            [Config storeUserInfo:nil];
            [self postLoginNotification:statusCode];
        }
        
        if (fail) {
            fail(@{@"code":[NSNumber numberWithInteger:statusCode],@"msg":[responseObj objectForKey:@"message"]});
        }
    }];
    return task;
}

+ (NSURLSessionDataTask *)deleteWith:(NSString *)url headerSets:(NSDictionary *)sets parameters:(NSDictionary *)parameters complete:(httpcomplete)complete fail:(httpfail)fail
{
    AFHTTPSessionManager *manager = [HttpManager sharedAFHTTPSessionManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.f;
    
    for (NSString *key in [sets allKeys]) {
        [manager.requestSerializer setValue:[sets objectForKey:key] forHTTPHeaderField:key];
    }
    
    NSURLSessionDataTask *task = [manager DELETE:[HttpManager joinUrl:[NSString stringWithFormat:@"backend/%@",url]] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseData = [self handleComplete:task responseObject:responseObject];
        if (complete) {
            complete(responseData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [((NSHTTPURLResponse*)task.response) statusCode];
        NSData *errData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        id responseObj = nil;
        if (errData) {
            responseObj = [NSJSONSerialization JSONObjectWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (responseObj == nil) {
                responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
            }
        }
        else
        {
            responseObj = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误",@"message", nil];
        }
        if (statusCode == 401 || statusCode == 40101 || [[responseObj objectForKey:@"status"] integerValue]) {

//            [Config storeUserInfo:nil];
            [self postLoginNotification:statusCode];
        }
        
        if (fail) {
            fail(@{@"code":[NSNumber numberWithInteger:statusCode],@"msg":[responseObj objectForKey:@"message"]});
        }
    }];
    return task;
}

+ (NSString *)joinUrl:(NSString *)url
{
    return [hostUrl stringByAppendingString:url];
}

+ (NSString *)joinImgUrl:(NSString *)url
{
    return [imghostUrl stringByAppendingString:url];
}

+ (NSString *)host
{
    return hostUrl;
}

+ (NSDictionary *)handleResponseComplete:(NSURLResponse *)response responseObject:(id)responseObject
{
    NSInteger statusCode = [((NSHTTPURLResponse*)response) statusCode];
    NSDictionary *header = [((NSHTTPURLResponse*)response) allHeaderFields];
    BOOL isJsonType = [[header objectForKey:@"Content-Type"] hasPrefix:@"application/json"];
    id responseObj = nil;
    if (isJsonType) {
        responseObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    }
    else
    {
        responseObj = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    }
    if (statusCode>=200 && statusCode <=299) {
        statusCode = 200;
    }
    NSDictionary *responseData = @{@"code":[NSNumber numberWithInteger:statusCode],@"header":header == nil ? @{} :header,@"response":responseObj == nil ? [NSNull null] : responseObj};
    return responseData;
}

+ (NSDictionary *)handleComplete:(NSURLSessionDataTask *)task responseObject:(id)responseObject
{
    NSInteger statusCode = [((NSHTTPURLResponse*)task.response) statusCode];
    NSDictionary *header = [((NSHTTPURLResponse*)task.response) allHeaderFields];
    BOOL isJsonType = [[header objectForKey:@"Content-Type"] hasPrefix:@"application/json"];
    id responseObj = nil;
    if (isJsonType) {
        responseObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    }
    else
    {
        responseObj = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    }
    
    if (statusCode>=200 && statusCode <=299) {
        statusCode = 200;
    }
    NSDictionary *responseData = @{@"code":[NSNumber numberWithInteger:statusCode],@"header":header == nil ? @{} :header,@"response":responseObj == nil ? [NSNull null] : responseObj};
    return responseData;
}

+ (void)postLoginNotification:(NSInteger)statusCode
{
    if (statusCode == 401 || statusCode == 40101) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CBGOLFShowChangeLogin" object:nil];
    }
}

@end
