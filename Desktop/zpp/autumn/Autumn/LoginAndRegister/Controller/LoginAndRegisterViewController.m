//
//  LoginAndRegisterViewController.m
//  Autumn
//
//  Created by cbgolf  on 2017/10/12.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
#import "Header.h"
#import "MainTabbarController.h"
#import "URLFile.h"
@interface LoginAndRegisterViewController ()<UITextFieldDelegate>{
    UIView *navView;
    
}

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *retrieveButton;
@property (weak, nonatomic) IBOutlet MGOTextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet MGOTextField *passWordTF;
@property (strong, nonatomic) IBOutlet UIButton *secureButton;

- (void)initDataSource;//初始化数据源
- (void)initUserInterface;//初始化用户界面
@end

@implementation LoginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDataSource];
    [self initUserInterface];
    
//    NSLog(@"phone == %@",_phoneNumberTF.text);
}


#pragma mark - Init methods
- (void)initDataSource{
    
}
- (void)initUserInterface{
    
    //button样式
    [self.registerButton setImagePosition:LXMImagePositionTop spacing:4];
    [self.retrieveButton setImagePosition:LXMImagePositionTop spacing:4];
    
    [self initWithNavBar];
    
    
}
#pragma mark - UI
- (void)initWithNavBar {
    navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, 44)];
    navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 20, 30, 30);
    [backButton setImage:[UIImage imageNamed:@"fanhui"]  forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:29];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navView addSubview:backButton];
}
#pragma mark - 点击事件
- (void)back {
    //跳转回到主页面
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MainTabbarController *main = [board instantiateViewControllerWithIdentifier:@"MainVC"];
//    [self presentViewController:main animated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)register:(id)sender {
    
}

- (IBAction)retrieve:(id)sender {
    
}
- (IBAction)login:(id)sender {
    [self loginNet];
    
}
- (IBAction)secure:(id)sender {
    self.passWordTF.secureTextEntry = !self.passWordTF.secureTextEntry;
    
    
    if (_secureButton.selected) {
        _secureButton.selected = !_secureButton.selected;
        [_secureButton setImage:UIImageMake(@"kejian") forState:UIControlStateNormal];
    } else {
        NSLog(@"mima");
        _secureButton.selected = !_secureButton.selected;
        [_secureButton setImage:UIImageMake(@"bukejian") forState:UIControlStateNormal];
        
    }
    [self.passWordTF becomeFirstResponder];
}

#pragma mark - net
- (void)loginNet{
    //特殊的接口:login
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"phone"] = _phoneNumberTF.text ;
    //todo: 输入加密的密码
    params[@"password"] = [DES3EncryptUtil encrypt:_passWordTF.text];
    
    [HttpManager get:@"api/app/authenticate/user" headerSets:nil parameters:params complete:^(id response) {
        NSDictionary *responseDic = (NSDictionary *)response;
        NSLog(@"login result -- %@",responseDic);
        if ([[responseDic objectForKey:@"code"] integerValue] == 200){
            NSString *token = [[response objectForKey:@"header"] objectForKey:@"X-Auth-Token"];
                        [ShareUserModel setUserID:_phoneNumberTF.text];
                        [ShareUserModel setPwd:_passWordTF.text];
                        [ShareUserModel setUserToken:token];
            [ShareUserModel setUserLogin:@"yes"];
            //跳转页面
            [self dismissViewControllerAnimated:YES completion:nil];
                        NSLog(@"token == %@",token);
        } else{
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } fail:^(id response) {
        [SVProgressHUD showErrorWithStatus:@"登录不成功"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    }];

}


#pragma mark - help
//键盘协议
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 收起键盘
    [self.view endEditing:YES];
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
