//
//  NSObject+modelProperty.m
//  Autumn
//
//  Created by figaro on 2017/10/25.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#import "NSObject+modelProperty.h"

@implementation NSObject (modelProperty)
+(void)propertyCodeWithDictionary:(NSDictionary *)dict
{
    NSMutableString *strM              = [NSMutableString string];
    NSMutableString *descriptionHeader = [NSMutableString stringWithFormat:@"[NSString stringWithFormat:%@\"",@"@"];
    NSMutableString *descriptionEnd    = [NSMutableString string];
    NSInteger count                    = [dict count];
    __block NSInteger index            = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                              id  _Nonnull obj,
                                              BOOL * _Nonnull stop) {
        //        NSLog(@"类型%@\n",[obj class]);
        NSString *str;
        NSString *Header;
        index ++;
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")] || [obj isKindOfClass:NSClassFromString(@"NSTaggedPointerString")] || [obj isKindOfClass:NSClassFromString(@"__NSCFConstantString")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) int %@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSArray *%@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSDictionary *%@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%d"];
        }
        if ([obj isKindOfClass:(NSClassFromString(@"NSNull"))]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@  (null);",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        [descriptionEnd appendFormat:@"_%@,",key];
        [descriptionHeader appendFormat:@"%@",Header];
        [strM appendFormat:@"\n%@",str];
    }];
    if (count == index && count > 0) {
        [descriptionHeader replaceCharactersInRange:NSMakeRange(descriptionHeader.length - 3, 3) withString:@"\","];
        [descriptionEnd replaceCharactersInRange:NSMakeRange(descriptionEnd.length - 1, 1) withString:@"];"];
    }
    NSLog(@"\n\n*******模型所有属性，自己要改下(默认空的数据为字符串)*******%@",strM);
    NSLog(@"\n\n***************重写模型的描述粘贴复制这句***************\nreture %@%@",descriptionHeader,descriptionEnd);
    
}

//作者：dadahua
//链接：http://www.jianshu.com/p/fd0dd21dd2c1
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
@end
