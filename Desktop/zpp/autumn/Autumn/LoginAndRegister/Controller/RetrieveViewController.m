//
//  RetrieveViewController.m
//  Autumn
//
//  Created by cbgolf  on 2017/10/16.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#import "RetrieveViewController.h"
#import "Header.h"
#import "UIButton+countDown.h"

@interface RetrieveViewController (){
    UIView *navView;
    BOOL isPhone;
}
- (void)initDataSource;//初始化数据源
- (void)initUserInterface;//初始化用户界面
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (strong, nonatomic) IBOutlet UIButton *verificationButton;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UITextField *checkPasswordTF;



@end

@implementation RetrieveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Init methods
- (void)initDataSource{
    
}
- (void)initUserInterface{
    
    [self initWithNavBar];
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
    QMUIButton *backButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 7+20, 26, 26);
    [backButton setImage:UIImageMake(@"fanhui") forState:UIControlStateNormal];
    backButton.adjustsImageTintColorAutomatically = NO;
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [navView addSubview:backButton];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 44)];
    CGPoint center = CGPointMake(navView.width/2, 22+20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = center;
    titleLabel.text = @"找回密码";
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

-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//验证码
- (IBAction)verificationCodeButton:(id)sender {
    
    [self checkPhoneNumber];
}

//找回密码
- (IBAction)refoundPasswordButton:(id)sender {
    if ([checkNumber checkTelNumber:_phoneNumberTF.text] && isPhone)//手机号正常并且注册过
    {
        if (![_verificationCodeTF.text isEqualToString:@"(null)"]) {//验证码不为空
            if ([checkNumber checkPassword:_passwordTF.text]) {//密码正常且不为空
                if ([_passwordTF.text isEqualToString:_checkPasswordTF.text] && ![_checkPasswordTF.text isEqualToString:@"(null)"]) {//重复密码正确
                    
                    [self refindPasswordNet];
                    
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

//协议
- (IBAction)protocolButton:(id)sender {
    
    NSString *urlText = [ NSString stringWithFormat:registerWEB];
    [ [ UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}

#pragma mark - net
- (void)checkPhoneNumber{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,checkPhoneURL];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"phone"] = _phoneNumberTF.text;
    
    if ([checkNumber checkTelNumber:_phoneNumberTF.text]) {
        [BANetManager ba_request_GETWithUrlString:url isNeedCache:NO parameters:params successBlock:^(id response) {
            
            if ([[response objectForKey:@"status"] integerValue] == 200) {
                if ([[response objectForKey:@"data"] objectForKey:@"status"]) {//已经注册是ture
                    
                    [self getVerificationCodeNet];
                    isPhone = [[response objectForKey:@"data"] objectForKey:@"status"];
                    
                } else {
                    isPhone = [[response objectForKey:@"data"] objectForKey:@"status"];
                    [SVProgressHUD showErrorWithStatus:@"手机号没有注册过！"];
                    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
                    
                    
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
- (void)getVerificationCodeNet{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,getVerificationCodeURL];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"phone"] = _phoneNumberTF.text;
    [BANetManager ba_request_POSTWithUrlString:url isNeedCache:NO parameters:params successBlock:^(id response) {
        if ([[response objectForKey:@"status"] integerValue] == 200) {
            //验证码读秒
            if (@available(iOS 11.0, *)) {
                [_verificationButton startWithTime:59 title:@"获取验证码" countDownTitle:@"秒" mainColor:[UIColor colorNamed:@"MainGreen"] countColor:[UIColor grayColor]];
            } else {
                // Fallback on earlier versions
            }
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

- (void)refindPasswordNet{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BaseURL,refindPasswordURL,_phoneNumberTF.text];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"captcha"] = _verificationCodeTF.text;
    params[@"password"] = _passwordTF.text;
    
    
    NSDictionary *headerDict = @{@"Content-Type":@"application/json",@"Accept":@"application/json"};

    [self putWithURL:url withHeader:headerDict withParams:params];
    
}

-(void)putWithURL:(NSString *)url withHeader:(NSDictionary *)header withParams:(NSDictionary *)params{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    request.HTTPMethod = @"PUT";
    
    request.allHTTPHeaderFields = header;//此处为请求头，类型为字典
    
    
    NSString *msg =  [self dictionaryToJson:params];
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = data;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([[response valueForKey:@"status"] isEqualToString:@"200"]) {
            [SVProgressHUD showSuccessWithStatus:@"成功找回密码"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"找回密码失败"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
            MyLog(@"error == %@",[response valueForKey:@"message"]);
        }
        
    }] resume];
}

#pragma mark - help

//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}
//字典转json格式字符串：
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
