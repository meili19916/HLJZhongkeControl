//
//  HLJLectureModelViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/11.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJLectureModelViewController.h"
#import "HLJDeviceTableViewCell.h"
#import "HLJHttp.h"
#import "HLJImageStepTableViewCell.h"
#import "HLJNoteStepTableViewCell.h"
#import "HLJSettingStepTableViewCell.h"
#import "HLJLedControllManager.h"
#import "UIImageView+WebCache.h"
@interface HLJLectureModelViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger currentStep;
@property (nonatomic,strong) NSMutableArray *deviceArray;

@end

@implementation HLJLectureModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"演讲模式";
    [HLJLedControllManager shared].controlSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

    self.deviceArray = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"HLJDeviceTableViewCell" bundle:nil] forCellReuseIdentifier:@"HLJDeviceTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HLJImageStepTableViewCell" bundle:nil] forCellReuseIdentifier:@"HLJImageStepTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HLJNoteStepTableViewCell" bundle:nil] forCellReuseIdentifier:@"HLJNoteStepTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HLJSettingStepTableViewCell" bundle:nil] forCellReuseIdentifier:@"HLJSettingStepTableViewCell"];
    self.currentStep = 0;
    [self sendLedContent];

    // Do any additional setup after loading the view from its nib.
}

- (void)sendLedContent{
    [[HLJLedControllManager shared] TCPConnectToHost:self.model.Steps[self.currentStep].led_set.led_ip onPort:self.model.Steps[self.currentStep].led_set.led_port];
    [[HLJLedControllManager shared] sendLed:self.model.Steps[self.currentStep].led_set.led_content];
}
- (void)getData{
//    [[HLJHttp shared] getLecureInfo:self.lectureId success:^(NSDictionary * _Nonnull data) {
//        NSLog(@"");
//    } failure:^(NSInteger code, NSString * _Nonnull error) {
//
//    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        if (self.deviceArray.count == 0) {
            NSDictionary *dic = self.model.Steps[self.currentStep].device;
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                LectureDeviceModel *model = [LectureDeviceModel yy_modelWithJSON:obj];
                model.id = key;
                [self.deviceArray addObject:model];
            }];
        }
        return self.deviceArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 350;
    }else if(indexPath.section == 1){
        return 55 + [self sizeLineFeedWithFont:15 textSizeWidht:self.view.frame.size.width-30 text:self.model.Steps[self.currentStep].des];
    }else if(indexPath.section == 2){
        return 250;
    }
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        HLJImageStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLJImageStepTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = [NSString stringWithFormat:@"%d/%d",self.currentStep+1,self.model.Steps.count];
        [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:self.model.Steps[self.currentStep].img]];
        cell.beforeBlock = ^(id  _Nonnull blockData) {
            weakSelf.currentStep -= 1;
            if (weakSelf.currentStep < 0) {
                weakSelf.currentStep = 0;
            }else{
                [weakSelf sendLedContent];
                [weakSelf.deviceArray removeAllObjects];
            }
            [weakSelf.tableView reloadData];
        };
        cell.nextBlock = ^(id  _Nonnull blockData) {
            weakSelf.currentStep += 1;
            if (weakSelf.currentStep >= self.model.Steps.count) {
                weakSelf.currentStep = self.model.Steps.count - 1;
            }else{
                [weakSelf sendLedContent];
                [weakSelf.deviceArray removeAllObjects];
            }
            [weakSelf.tableView reloadData];
        };
        return cell;
    }else if (indexPath.section == 1) {
        HLJNoteStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLJNoteStepTableViewCell" forIndexPath:indexPath];
        cell.noteLabel.text = self.model.Steps[self.currentStep].des;
        return cell;
    }else if (indexPath.section == 2) {
        HLJSettingStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLJSettingStepTableViewCell" forIndexPath:indexPath];
        NSInteger onCount = 0;
        NSInteger offCount = 0;
        for (LectureLightDetailModel *model in self.model.Steps[self.currentStep].light_setting_detail) {
            if (model.control) {
                onCount ++;
            }else{
                offCount ++;
            }
        }
        [cell updateLightCountOn:onCount offCount:offCount cardText:self.model.Steps[self.currentStep].led_set.led_content];
        return cell;
    }
    
    HLJDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLJDeviceTableViewCell" forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 8.0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LectureDeviceModel *model = self.deviceArray[indexPath.row];
    cell.nameLabel.text = model.device_info.name;
    cell.slider.value = model.volume;
    cell.volomLabel.text = [NSString stringWithFormat:@"%.f%%",model.volume];
    cell.voiceChangedBlock = ^(id  _Nonnull blockData) {
        
    };
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
