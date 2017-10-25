//
//  RegisterViewController.m
//  Autumn
//
//  Created by cbgolf  on 2017/10/16.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#import "RegisterViewController.h"
#import "Header.h"
#import "UIButton+countDown.h"
#import "HttpManager.h"

@interface RegisterViewController ()<UITextFieldDelegate>{
    UIView *navView;
    BOOL isPhone;
    
}
- (void)initDataSource;//初始化数据源
- (void)initUserInterface;//初始化用户界面
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
@property (strong, nonatomic) IBOutlet UITextField *checkPassWordTF;
@property (strong, nonatomic) IBOutlet UIButton *verificationCodeButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *noticeButton;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithNavBar];
    
    
    [self initDataSource];
    [self initUserInterface];
    
}


#pragma mark - Init methods
- (void)initDataSource{
//    [self getRSA];
}
- (void)initUserInterface{
    _phoneNumberTF.delegate = self;
    _passWordTF.delegate = self;
    _verificationCodeTF.delegate = self;
    _checkPassWordTF.delegate = self;
}
#pragma mark - UI

- (void)initWithNavBar {
    navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, 44+20)];
    if (@available(iOS 11.0, *)) {
        navView.backgroundColor = [[UIColor colorNamed:@"MainGreen"] colorWithAlphaComponent:1.0];
    } else {
        // Fallback on earlier versions
         navView.backgroundColor = K_MAINCOLOR;
    }
    [self.view addSubview:navView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 7+20, 26, 26);
    [backButton setImage:UIImageMake(@"fanhui") forState:UIControlStateNormal];
//    backButton.adjustsImageTintColorAutomatically = NO;
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [navView addSubview:backButton];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 44)];
    CGPoint center = CGPointMake(navView.width/2, 22+20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = center;
    titleLabel.text = @"注册账号";
    titleLabel.textColor = UIColorWhite;
    titleLabel.font = UIFontLightMake(19);
    [navView addSubview:titleLabel];
//    QMUIButton *shareButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
//    [shareButton setImage:UIImageMake(@"shareButton") forState:UIControlStateNormal];
//    shareButton.adjustsImageTintColorAutomatically = NO;
//    shareButton.frame = CGRectMake(screenwidth - 45, 7+20, 30, 30);
//    [shareButton addTarget:self action:@selector(handleShare)];
//    [navView addSubview:shareButton];
    [navView layoutIfNeeded];
}

#pragma mark - action

- (IBAction)notice:(id)sender {
    
    
    NSString *urlText = [ NSString stringWithFormat:registerWEB];
   [ [ UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}
-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)verificationCode:(id)sender {
    MyLog(@"phone == %@",_phoneNumberTF.text);
    [self checkPhoneNumber];
}

//注册完成做一次登录,直接跳转到首页
- (IBAction)registerAction:(id)sender {
    if ([checkNumber checkTelNumber:_phoneNumberTF.text] && isPhone)//手机号正常并且没有注册过
    {
        if (![_verificationCodeTF.text isEqualToString:@"(null)"]) {//验证码不为空
            if ([checkNumber checkPassword:_passWordTF.text]) {//密码正常且不为空
                if ([_passWordTF.text isEqualToString:_checkPassWordTF.text] && ![_checkPassWordTF.text isEqualToString:@"(null)"]) {//重复密码正确
                    
                    [self registerNet];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:@"密码前后不一致"];
                    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
                }
            } else {
                [SVProgressHUD showErrorWithStatus:@"请输入正确的密码"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的验证码"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } else {
        //如果获取验证码之后,又离开了该页面.isphone 是否注册过,为否;所以要重新点击获取验证码;重新验证
        if (!isPhone) {
            [SVProgressHUD showErrorWithStatus:@"请点击获取验证码,重新获取验证码"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
        
    }
}



#pragma mark - net
//checkPhone --- getVerificationCode 手机号是否注册---得到验证码
- (void)checkPhoneNumber{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,checkPhoneURL];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"phone"] = _phoneNumberTF.text;
    
    if ([checkNumber checkTelNumber:_phoneNumberTF.text]) {
        [BANetManager ba_request_GETWithUrlString:url isNeedCache:NO parameters:params successBlock:^(id response) {
            
            if ([[response objectForKey:@"status"] integerValue] == 200) {
                if ([[response objectForKey:@"data"] objectForKey:@"status"]) {//已经注册是ture
                    
                    isPhone = [[response objectForKey:@"data"] objectForKey:@"status"];
                    [SVProgressHUD showErrorWithStatus:@"手机号已经注册"];
                    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
                    
                } else {
                    
                    [self getVerificationCode];
                    isPhone = [[response objectForKey:@"data"] objectForKey:@"status"];
                    
                }
            }
        } failureBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            
        }];
    } else {
        
        //验证码请求不成功
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    }
    
}
- (void)getVerificationCode{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,getVerificationCodeURL];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"phone"] = _phoneNumberTF.text;
    [BANetManager ba_request_POSTWithUrlString:url isNeedCache:NO parameters:params successBlock:^(id response) {
        if ([[response objectForKey:@"status"] integerValue] == 200) {
            //验证码读秒
            [_verificationCodeButton startWithTime:59 title:@"获取验证码" countDownTitle:@"秒" mainColor:[UIColor colorNamed:@"MainGreen"] countColor:[UIColor grayColor]];
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"验证码发送失败"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"验证码发送失败"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

- (void)loginNet{
    //特殊的接口:login
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"phone"] = _phoneNumberTF.text ;
    //todo: 输入加密的密码
    params[@"password"] = [DES3EncryptUtil encrypt:_passWordTF.text];
    
    [HttpManager get:@"api/app/authenticate/user" headerSets:nil parameters:params complete:^(id response) {
        NSDictionary *responseDic = (NSDictionary *)response;
        
        if ([[responseDic objectForKey:@"code"] integerValue] == 200){
            
            NSString *token = [[response objectForKey:@"header"] objectForKey:@"X-Auth-Token"];
            [ShareUserModel setUserID:_phoneNumberTF.text];
            [ShareUserModel setPwd:_passWordTF.text];
            [ShareUserModel setUserToken:token];
            [ShareUserModel setUserLogin:@"yes"];
            //跳转页面
            NSLog(@"token == %@",token);
            [self backHome];
        } else{
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } fail:^(id response) {
        [SVProgressHUD showErrorWithStatus:@"登录不成功"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    }];
    
}

- (void)registerNet{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,registerURL];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"phone"] = _phoneNumberTF.text ;
    //todo:输入加密的密码
    params[@"password"] = [DES3EncryptUtil encrypt:_passWordTF.text];
    params[@"captcha"] = _verificationCodeTF.text ;
    params[@"loginType"] = @"IOS" ;
    [BANetManager ba_request_POSTWithUrlString:url isNeedCache:NO parameters:params successBlock:^(id response) {
        
        if ([[response objectForKey:@"status"] integerValue] == 200) {
            [self loginNet];
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"注册不成功"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
    
}
//暂时不用RSA,使用DES加密密码
//- (void)getRSA{
//    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,getRSAURL];
//
//    [BANetManager ba_request_GETWithUrlString:url isNeedCache:NO parameters:nil successBlock:^(id response) {
//        if ([[response objectForKey:@"status"] integerValue] == 200) {
//            NSDictionary *data = response[@"data"];
//            mod = [NSString stringWithFormat:@"%@",data[@"module"]];
//            exp = (NSUInteger*)[data[@"empoent"] integerValue];
//            NSLog(@"data = %@",data);
//        } else {
//            [SVProgressHUD showErrorWithStatus:@"获取token信息错误"];
//            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
//        }
//    } failureBlock:^(NSError *error) {
//
//        [SVProgressHUD showErrorWithStatus:@"网络错误"];
//        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
//    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//
//    }];
//}
#pragma mark - 页面跳转

-(void)backHome{
    
    [self performSegueWithIdentifier:@"backBooking" sender:self];
}



#pragma mark - help
//fix：没有完成限制字符数量
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneNumberTF) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    
    if (textField == self.verificationCodeTF) {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
    
    if (textField == self.passWordTF) {
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }
    if (textField == self.checkPassWordTF) {
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }
}
//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
