//
//  EventViewController.m
//  Autumn
//
//  Created by figaro on 2017/10/25.
//  Copyright © 2017年 cbgolf. All rights reserved.
//

#import "EventViewController.h"
#import "userModel.h"
@interface EventViewController ()

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userModel *model = [[userModel alloc] init];
    NSLog(@"model == %@",model.nickName);
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
