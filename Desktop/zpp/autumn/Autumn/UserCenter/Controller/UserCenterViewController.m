//
//  UserCenterViewController.m
//  Autumn
//
//  Created by cbgolf  on 2017/10/11.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#import "UserCenterViewController.h"
#import "LoginAndRegisterViewController.h"
#import "Header.h"
@interface UserCenterViewController ()<UITabBarControllerDelegate>
- (void)initDataSource;//初始化数据源
- (void)initUserInterface;//初始化用户界面
@property (nonatomic, strong) NSDictionary  *userModelDic;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *chaDian;
@property (weak, nonatomic) IBOutlet UILabel *ballAge;
@property (weak, nonatomic) IBOutlet UILabel *totalSession;
@property (weak, nonatomic) IBOutlet UILabel *totalCourse;
@property (weak, nonatomic) IBOutlet UILabel *bestScore;
@property (weak, nonatomic) IBOutlet UILabel *littleBird;
@property (weak, nonatomic) IBOutlet UILabel *laoYing;
@property (weak, nonatomic) IBOutlet UILabel *xinTianWong;
@property (weak, nonatomic) IBOutlet UILabel *oneShot;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *sortValue;
@property (weak, nonatomic) IBOutlet UILabel *couponNumber;


@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDataSource];
    [self initUserInterface];
}


//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    
//    if (tabBarController.selectedIndex == 2) {//我的
//        //todo:if the user is logined. push to base.if not, go to loginAndRegister.
//        NSLog(@"tabbar push to loginVC");
//        UIStoryboard *board = [UIStoryboard storyboardWithName:@"loginAndRegister" bundle:nil];
//        LoginAndRegisterViewController *loginVC = [board instantiateViewControllerWithIdentifier:@"loginAndRegisterViewController"];
//        [self presentViewController:loginVC animated:YES completion:nil];
//        
//    } else {
//        
//        return YES;
//    }
//    NSLog(@"tabbar push to loginVC");
//    return NO;
//}

#pragma mark - Init methods
- (void)initDataSource{
    
    [self getUserInfo];
}
- (void)initUserInterface{

}
#pragma mark - Net
-(void)getUserInfo{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,getUserInfoURL];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"X-Auth-Token"] =[ShareUserModel getToken] ;
    
    // 自定义添加请求头
    NSDictionary *headerDict = params;
    BANetManagerShare.httpHeaderFieldDictionary = headerDict;
    
    [BANetManager ba_request_GETWithUrlString:url isNeedCache:NO parameters:nil successBlock:^(id response) {
       
        userModel *model = [[userModel alloc] initWithDictionary:[response valueForKey:@"data"] error:nil];
        _userModelDic = [model toDictionary];
        NSLog(@"dic = %@",_userModelDic);
        
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}
-(void)getUserScore{
    
}

#pragma mark - action

- (IBAction)changeUserInfo:(id)sender {
}
- (IBAction)checkScore:(id)sender {
}
- (IBAction)dingDanButton:(id)sender {
}
- (IBAction)memberButton:(id)sender {
}
- (IBAction)inviteButton:(id)sender {
}
- (IBAction)systemButton:(id)sender {
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
