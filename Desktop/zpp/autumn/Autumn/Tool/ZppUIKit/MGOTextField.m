//
//  MGOTextField.m
//  designable
//
//  Created by minggo on 16/5/13.
//  Copyright © 2016年 minggo. All rights reserved.
//

#import "MGOTextField.h"

@implementation MGOTextField

#pragma mark - set
//控制placeHolder的位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+_padding, bounds.origin.y, bounds.size.width -_padding, bounds.size.height);
    return inset;
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+_padding, bounds.origin.y, bounds.size.width -_padding, bounds.size.height);
    return inset;
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x +_padding, bounds.origin.y, bounds.size.width -_padding, bounds.size.height);
    return inset;
}

//textfield 的左右视图
-(void)setLeftImage:(UIImage *)leftImage{
    self.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftImgView = [[UIImageView alloc] initWithImage:leftImage];
    leftImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.leftView = leftImgView;
    
}
-(void)setRightImage:(UIImage *)rightImage{
    self.rightViewMode = UITextFieldViewModeAlways;
    UIImageView *rightImgView = [[UIImageView alloc] initWithImage:rightImage];
    rightImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.rightView = rightImgView;
    
}
-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    
    CGRect inset = CGRectMake(_leftPadding,5, bounds.size.width*0.8, bounds.size.height*0.8);
    return inset;
}
-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake( bounds.origin.x - _rigthPadding,5, bounds.size.width*0.8, bounds.size.height*0.8);
    return inset;
}


@end
