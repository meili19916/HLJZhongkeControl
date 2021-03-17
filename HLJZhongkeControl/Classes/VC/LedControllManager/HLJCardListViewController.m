//
//  HLJCardListViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/1.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJCardListViewController.h"
#import "HLJCardListTableViewCell.h"
@interface HLJCardListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HLJCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"迎宾词历史记录";
    [self.tableView registerNib:[UINib nibWithNibName:@"HLJCardListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HLJCardListTableViewCell"];

    // Do any additional setup after loading the view from its nib.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLJCardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLJCardListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = @"迎宾词";
    cell.timeLabel.text = @"2020.3.4 13:23";
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
