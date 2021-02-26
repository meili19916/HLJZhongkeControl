//
//  HLJDeviceViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/26.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJDeviceViewController.h"

#import "HLJDeviceTableViewCell.h"
@interface HLJDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *deviceArray;
@end

@implementation HLJDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deviceArray=@[@"1",@"2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HLJDeviceTableViewCell" bundle:nil] forCellReuseIdentifier:@"HLJDeviceTableViewCell"];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLJDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLJDeviceTableViewCell" forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 8.0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
