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
#import "MQTTClientModel.h"

@interface HLJTabViewController ()<UITabBarControllerDelegate,MQTTClientModelDelegate>

@end

@implementation HLJTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self addChildViewControllers];
    // Do any additional setup after loading the view from its nib.
}

- (void)initMQTT{
    [[MQTTClientModel sharedInstance] bindWithUserName:@"eh12sz3/innovation" password:@"qxCJBmqN1Yq3EjC1" cliendId:[NSUUID UUID].UUIDString isSSL:NO];
    [[MQTTClientModel sharedInstance] subscribeTopic:@"innovation"];
    [MQTTClientModel sharedInstance].delegate = self;
}
- (void)addChildViewControllers{
    //图片大小建议32*32
    [self addChildrenViewController:[HLJMainViewController new] andTitle:@"首页" andImageName:@"icon_sy_def" andSelectImage:@"icon_sy_pre"];
    [self addChildrenViewController:[HLJDeviceViewController new] andTitle:@"设备" andImageName:@"icon_gzt_def" andSelectImage:@"icon_gzt_pre"];
    [self addChildrenViewController:[UIViewController new] andTitle:@"我的" andImageName:@"icon_wd_def" andSelectImage:@"icon_wd_pre"];
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
