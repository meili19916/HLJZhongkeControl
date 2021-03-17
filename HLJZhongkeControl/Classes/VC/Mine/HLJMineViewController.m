//
//  HLJMineViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/1.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJMineViewController.h"
#import "HLJMineHeaderView.h"
@interface HLJMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) HLJMineHeaderView *headerView;
@end

@implementation HLJMineViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.title = @"";
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"logout"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90)];
    [view addSubview:self.headerView];
    self.tableView.tableHeaderView = view;
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 10 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:12];

        NSArray *data = @[@{@"title":@"客服",@"image":@"icon_kf"},@{@"title":@"设置",@"image":@"icon_sz"}];
        NSDictionary *dic = data[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:dic[@"image"]];
        cell.textLabel.text = dic[@"title"];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logout" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    label.textColor = [UIColor redColor];
    label.text = @"退出";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:label];
    return cell;
}

- (HLJMineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"HLJMineHeaderView" owner:self options:nil] lastObject];
        _headerView.backgroundColor = [UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1];
        _headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90);

    }
    return _headerView;
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
