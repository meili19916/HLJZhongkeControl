//
//  HLJRelateListViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/5.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJRelateListViewController.h"
#import "UIView+Toast.h"
#import "HLJMainViewController.h"
@interface HLJRelateListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HLJRelateListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"展厅";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view from its nib.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    HLJDeviceModel *model = [HLJDeviceModel yy_modelWithJSON:self.dataArray[indexPath.row]];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLJDeviceModel *model = [HLJDeviceModel yy_modelWithJSON:self.dataArray[indexPath.row]];
    if (self.selectDeviceBlock) {
        self.selectDeviceBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
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
