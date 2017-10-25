//
//  MGOTextField.h
//  designable
//
//  Created by minggo on 16/5/13.
//  Copyright © 2016年 minggo. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface MGOTextField : UITextField

@property(nonatomic,assign) IBInspectable CGFloat padding;
@property(nonatomic,assign) IBInspectable UIImage *leftImage;
@property(nonatomic,assign) IBInspectable CGFloat leftPadding;
@property(nonatomic,assign) IBInspectable UIImage *rightImage;
@property(nonatomic,assign) IBInspectable CGFloat rigthPadding;

@end
