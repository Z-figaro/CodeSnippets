//
//  ZPPTextField.m
//  XFitClub
//
//  Created by figaro on 2017/4/6.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//


#import "ZPPTextField.h"
IB_DESIGNABLE
#define Default_FontColor RGBCOLOR(81, 204, 251, 1)
@implementation ZPPTextField

////通过代码创建
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setUpUI];
//    }
//    return self;
//}
////通过xib创建
//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    [self setUpUI];
//}

- (void)setUpUI
{
    //    设置border
        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = _cornerRadius;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;
    //字体大小
    self.font = [UIFont systemFontOfSize:15];
    //字体颜色
    self.textColor = [UIColor colorNamed:@"FontColor"];;
    //光标颜色
    self.tintColor= self.textColor;
    //占位符的颜色和大小
    [self setValue:Default_FontColor forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    // 不成为第一响应者
    [self resignFirstResponder];
}
/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    [self setValue:self.textColor forKeyPath:@"_placeholderLabel.textColor"];
    return [super becomeFirstResponder];
}

/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    return [super resignFirstResponder];
}
//控制placeHolder的位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+_Padding, bounds.origin.y, bounds.size.width -_Padding, bounds.size.height);
    return inset;
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+_Padding, bounds.origin.y, bounds.size.width -_Padding, bounds.size.height);
    return inset;
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x +_Padding, bounds.origin.y, bounds.size.width -_Padding, bounds.size.height);
    return inset;
}

#pragma mark - set
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;//不要使用self.cornerRadius = cornerRadius;这样会死循环
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}



@end
