//
//  HLJTabViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/24.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJTabViewController.h"
#import "HLJMainViewController.h"
#import "HLJDeviceViewController.h"
#import "HLJMineViewController.h"
#import "HLJHttp.h"
#import "HLJLoginPageViewController.h"
@interface HLJTabViewController ()<UITabBarControllerDelegate,HLJHttpDelegate>

@end

@implementation HLJTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self addChildViewControllers];
    [HLJHttp shared].delegate = self;
    if ([HLJHttp shared].user.token.length == 0) {
        [self pushToLoginView];
    }
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)pushToLoginView{
    if ([self.navigationController.viewControllers.lastObject isKindOfClass:[HLJLoginPageViewController class]]) {
        return;
    }
    [self.navigationController pushViewController:[HLJLoginPageViewController new] animated:YES];
}


- (void)addChildViewControllers{
    //图片大小建议32*32
    [self addChildrenViewController:[HLJMainViewController new] andTitle:@"首页" andImageName:@"icon_sy_df" andSelectImage:@"icon_sy_pre"];
    [self addChildrenViewController:[HLJDeviceViewController new] andTitle:@"设备" andImageName:@"icon_sb_df" andSelectImage:@"icon_sb_pre"];
    [self addChildrenViewController:[HLJMineViewController new] andTitle:@"我的" andImageName:@"icon_wd_df" andSelectImage:@"icon_wd_wd"];
}

- (void)addChildrenViewController:(UIViewController *)childVC andTitle:(NSString *)title andImageName:(NSString *)imageName andSelectImage:(NSString *)selectedImage{
    UIImage *iconImage = [UIImage imageNamed:imageName];
    iconImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.image =iconImage;
    UIImage *iconImageSel = [UIImage imageNamed:selectedImage];
    iconImageSel = [iconImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage =  iconImageSel;
    childVC.title = title;
    [self addChildViewController:childVC];
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
