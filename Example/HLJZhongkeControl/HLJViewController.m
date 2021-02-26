//
//  HLJViewController.m
//  HLJZhongkeControl
//
//  Created by meili19916 on 02/22/2021.
//  Copyright (c) 2021 meili19916. All rights reserved.
//

#import "HLJViewController.h"
#import "HLJZhongkeControl.h"
@interface HLJViewController ()

@end

@implementation HLJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)pushToVC:(id)sender {
    [self.navigationController pushViewController:[HLJTabViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
