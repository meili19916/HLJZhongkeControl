//
//  HLJDeviceViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/26.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJDeviceViewController.h"
#import "SocketRocketUtility.h"
#import "HLJDeviceTableViewCell.h"
#import "HLJHttp.h"
#import "HLJRemoteControlViewController.h"
#import "UIView+Toast.h"

@interface HLJDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *deviceArray;
@property (nonatomic,strong) NSMutableArray *deviceSocketArray;

@end

@implementation HLJDeviceViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.title = @"设备";
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] init];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] init];
    self.tabBarController.navigationItem.leftBarButtonItem = item2;
    self.tabBarController.navigationItem.rightBarButtonItem = item1;
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.deviceSocketArray = [NSMutableArray new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HLJDeviceTableViewCell" bundle:nil] forCellReuseIdentifier:@"HLJDeviceTableViewCell"];
    // Do any additional setup after loading the view from its nib.
}

- (void)getData{
    [self.deviceSocketArray removeAllObjects];
    [[HLJHttp shared] getDeviceShowList:@{@"type_code":[HLJHttp shared].user.currentDeviceModel.tree_code,@"status":@1,@"device_type":@"display",@"limit":@"100"} success:^(NSDictionary * _Nonnull data) {
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *dic in data[@"items"]) {
            DeviceShowModel *model = [DeviceShowModel yy_modelWithJSON:dic];
            [array addObject:model];
        }
        self.deviceArray = [NSArray arrayWithArray:array];

        for (NSInteger i = 0; i < self.deviceArray.count ; i++) {
            SocketRocketUtility *socket = [SocketRocketUtility new];
            [self.deviceSocketArray addObject:socket];
        }
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull error) {
            
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceShowModel *model =self.deviceArray[indexPath.row];
    return model.expand ? 250 : 79;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLJDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLJDeviceTableViewCell" forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 8.0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DeviceShowModel *model =self.deviceArray[indexPath.row];
    cell.model = model;
    cell.socket = self.deviceSocketArray[indexPath.row];
    cell.nameLabel.text = model.name;
    
    cell.controllBlock = ^(id  _Nonnull blockData) {
        HLJRemoteControlViewController *vc = [HLJRemoteControlViewController new];
        vc.model = model;
        vc.deviceArray = self.deviceArray;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLJDeviceTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.socket.socketReadyState != SR_OPEN) {
        [self.view makeToast:@"设备未连接" duration:3 position:CSToastPositionCenter];
    }else{
        DeviceShowModel *model =self.deviceArray[indexPath.row];
        model.expand = !model.expand;
        [tableView reloadData];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)SRWebSocketDidSendMsgError:(NSNotification *)note{
    
}

@end
