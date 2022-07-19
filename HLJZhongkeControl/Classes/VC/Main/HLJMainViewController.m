//
//  HLJMainViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/24.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJMainViewController.h"
#import "Cell/HLJNotifyCollectionViewCell.h"
#import "HLJLedControllViewController.h"
#import "HLJCardViewController.h"
#import "MQTTClientModel.h"
#include <zlib.h>
#import "UIView+Toast.h"
#import "RelateList/HLJRelateListViewController.h"
#import "HLJHeaderCollectionReusableView.h"
#import "HLJMQTTCollectionReusableView.h"
#import "HLJLectureModelCollectionViewCell.h"
#import "RoleViewController.h"
#import "HLJLectureModelViewController.h"

@import CoreNFC;

@interface HLJMainViewController ()<MQTTClientModelDelegate,UICollectionViewDelegate,UICollectionViewDataSource,NFCNDEFReaderSessionDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) NSArray *deviceArray;
@property (nonatomic,strong) HLJDeviceModel *currentDevice;
@property (nonatomic,strong) NFCNDEFReaderSession *session;
@property (nonatomic, strong) UUIDModel *model;
@property (nonatomic,strong) LectureModel *lectureModel;
@property (nonatomic,assign) NSInteger MQTTStatus;
@property (nonatomic, strong) NSString *currentCompany;
@property (nonatomic,strong) NSArray *lightArray;
@property (nonatomic,strong) NSArray *ledArray;

@end

@implementation HLJMainViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.deviceArray.count == 0) {
        [self getData];
    }
    [self addNavigationBarView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;//透明

    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HLJNotifyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HLJNotifyCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HLJLectureModelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HLJLectureModelCollectionViewCell"];

    [self.collectionView registerNib:[UINib nibWithNibName:@"HLJHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header1"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HLJMQTTCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header2"];

    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    // Do any additional setup after loading the view from its nib.
}

- (void)getData{
    [[HLJHttp shared] getDeviceList:^(NSDictionary * _Nonnull data) {
        self.deviceArray = data[@"items"];
        self.currentDevice = [HLJDeviceModel yy_modelWithDictionary:self.deviceArray.firstObject];
        [self updateData];
        } failure:^(NSInteger code, NSString * _Nonnull error) {
            
        }];
}

- (void)updateData{
    [HLJHttp shared].user.currentDeviceModel = self.currentDevice;
    [self.locationButton setTitle:self.currentDevice.name forState:UIControlStateNormal];
    [self addNavigationBarView];
    [self mqttConnect];
    [[HLJHttp shared] getTurnList:@{@"exhibition_code":self.currentDevice.tree_code,@"turn_type":@0,@"skip":@0,@"limit":@-1} success:^(NSDictionary * _Nonnull data) {
        self.lightArray = data[@"items"];
        NSLog(@"");
    } failure:^(NSInteger code, NSString * _Nonnull error) {
        
    }];
    [[HLJHttp shared] getTurnList:@{@"exhibition_code":self.currentDevice.tree_code,@"turn_type":@1,@"skip":@0,@"limit":@-1} success:^(NSDictionary * _Nonnull data) {
        self.ledArray = data[@"items"];
        NSLog(@"");
    } failure:^(NSInteger code, NSString * _Nonnull error) {
        
    }];
}


- (void)addNavigationBarView{
    
    if (!self.locationButton) {
        self.locationButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,30)];
        [self.locationButton setTitle:@"" forState:UIControlStateNormal];
        self.locationButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.locationButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.locationButton addTarget:self action:@selector(navigationRight2ButtonClick:)forControlEvents:UIControlEventTouchUpInside];
    }
    [self.locationButton setTitle:self.currentDevice.name forState:UIControlStateNormal];

   CGFloat width = [self widthLineFeedWithFont:self.locationButton.titleLabel.font textSizeHeight:30 text:self.currentDevice.name];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width >= 300 ? 300 : width + 20 , 30)];
    [view addSubview:self.locationButton];
    self.locationButton.frame = CGRectMake(self.locationButton.frame.origin.x, self.locationButton.frame.origin.y, view.frame.size.width, self.locationButton.frame.size.height);
    
    
    UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowButton setImage:[UIImage imageNamed:@"icon_arrow_tm_y"] forState:UIControlStateNormal];
    arrowButton.frame = CGRectMake(self.locationButton.frame.origin.x + view.frame.size.width - 20, 0, 20, 30);
    [arrowButton addTarget:self action:@selector(navigationRight2ButtonClick:)forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:arrowButton];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.tabBarController.navigationItem.leftBarButtonItem = item2;
    self.tabBarController.title = @"";
    
    if (!([UIDevice currentDevice].systemVersion.floatValue >= 11.0) ||  [NFCNDEFReaderSession readingAvailable]) {
        UIButton *nfcButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,30)];
        [nfcButton setTitle:@"NFC" forState:UIControlStateNormal];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:nfcButton];
        self.tabBarController.navigationItem.rightBarButtonItem = item;
        [nfcButton addTarget:self action:@selector(startNFC:)forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma collectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (self.currentCompany.length > 0) {
        count += 1;
        if (self.model.demos_script.length > 0) {
            count += 1;
        }
    }
    
    return section == 1 ? 3 : count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section == 1) {
            // 头部
        HLJHeaderCollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:@"Header1"   forIndexPath:indexPath];
        return view;
            
    }
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section == 0) {
            // 头部
        HLJMQTTCollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:@"Header2"   forIndexPath:indexPath];
        if (self.MQTTStatus == 0 || self.MQTTStatus == 1) {
            view.statusImageView.image = [UIImage imageNamed:@"icon_wljz.png"];
            view.statusLabel.text = @"MQTT正在连接中....";
        }else if (self.MQTTStatus == 2) {
            view.statusImageView.image = [UIImage imageNamed:@"icon_ztzc.png"];
            view.statusLabel.text = @"当前服务正常!";
        }else if (self.MQTTStatus == -1) {
            view.statusImageView.image = [UIImage imageNamed:@"编组 5.png"];
            view.statusLabel.text = @"MQTT连接失败";
        }
        return view;
            
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(self.view.bounds.size.width, 60);
    }
    return CGSizeMake(self.view.bounds.size.width, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(self.view.bounds.size.width, 170);
    }
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width- 30)/2 , 120);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HLJLectureModelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLJLectureModelCollectionViewCell" forIndexPath:indexPath];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 8.0;
        __weak typeof(self) weakSelf = self;
        if (indexPath.row == 0) {
            cell.topImageView.image = [UIImage imageNamed:@"icon_dqqy.png"];
            cell.typeLabel.text = @"当前公司";
            if (self.currentCompany.length > 0) {
                cell.nameLabel.text = self.currentCompany;
            }
            [cell.leftButton setTitle:@"关联展示" forState:UIControlStateNormal];
            cell.leftBtttonBlock = ^(id blockData) {
                RoleViewController *vc =  [RoleViewController new];
                vc.model = weakSelf.model;
                vc.selectBlock = ^(UUIDModelMulitInfo *blockData) {
                    weakSelf.currentCompany = blockData.name;
                    weakSelf.lectureModel = nil;
                    [weakSelf.collectionView reloadData];
                    if (weakSelf.model.demos_script.length > 0) {
                        [weakSelf getLectureInfo];
                    }
                };
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            };
            cell.rightBtttonBlock = ^(id blockData) {
                weakSelf.currentCompany = nil;
                weakSelf.lectureModel = nil;
                [weakSelf.collectionView reloadData];
            };
        }else{
            cell.topImageView.image = [UIImage imageNamed:@"icon_yjms.png"];
            cell.typeLabel.text = @"演讲模式";
            cell.nameLabel.text = self.lectureModel.name;
            [cell.leftButton setTitle:@"进入" forState:UIControlStateNormal];
            cell.rightBtttonBlock = ^(id blockData) {
                weakSelf.lectureModel = nil;
                [weakSelf.collectionView reloadData];
            };
            cell.leftBtttonBlock = ^(id blockData) {
                HLJLectureModelViewController *vc =  [HLJLectureModelViewController new];
                vc.model = weakSelf.lectureModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
        return cell;
    }
    HLJNotifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLJNotifyCollectionViewCell" forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 8.0;
    cell.lab1Label.hidden = NO;
    cell.lab2Label.hidden = NO;
    cell.lab3Label.hidden = NO;
    cell.lab4Label.hidden = NO;
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"灯光设置";
        cell.lab1Label.text = @"点亮";
        cell.lab2Label.text = @"0";
        cell.lab3Label.text = @"熄灭";
        cell.lab4Label.text = @"0";
        cell.contentImageView.image = [UIImage imageNamed:@"icon_dgsz"];
    }else if (indexPath.row == 1) {
        cell.titleLabel.text = @"电源控制";
        cell.lab1Label.text = @"关闭";
        cell.lab2Label.text = @"0";
        cell.lab3Label.text = @"打开";
        cell.lab4Label.text = @"0";
        cell.contentImageView.image = [UIImage imageNamed:@"icon_dykz"];

    }else if (indexPath.row == 2) {
        cell.titleLabel.text = @"字符卡设置";
        cell.lab1Label.text = @"关闭";
        cell.lab2Label.hidden = YES;
        cell.lab3Label.hidden = YES;
        cell.lab4Label.hidden = YES;
        cell.contentImageView.image = [UIImage imageNamed:@"icon_zfksz"];

    }else if (indexPath.row == 3) {
        cell.titleLabel.text = @"区域信息";
        cell.lab1Label.text = @"当前位置";
        cell.lab2Label.text = @"成都";
        cell.lab3Label.hidden = YES;
        cell.lab4Label.hidden = YES;
        cell.contentImageView.image = [UIImage imageNamed:@"icon_zfksz"];

    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HLJLedControllViewController *vc = [HLJLedControllViewController new];
        vc.dataArray = self.lightArray;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        HLJLedControllViewController *vc = [HLJLedControllViewController new];
        vc.dataArray = self.ledArray;
        vc.isElectricControl = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
        HLJCardViewController *vc = [HLJCardViewController new];
        vc.dataArray = self.currentDevice.led_infos;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)navigationRight2ButtonClick:(UIButton*)sender{
//    NSString *str = sender.currentTitle;
//    NSData* en = [self zlibDeflate:str];
//    NSString *string  = [en base64EncodedStringWithOptions:0];
//    [[MQTTClientModel sharedInstance] sendDataToTopic:[NSString stringWithFormat:@"innovation_v1/message/%@/%@",self.currentDevice.mq_group,self.currentDevice.id] data:[[NSData alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]]];
    HLJRelateListViewController *vc = [HLJRelateListViewController new];
    vc.dataArray = self.deviceArray;
    vc.currentName = self.currentDevice.name;
    __weak typeof(self) weakSelf = self;
    vc.selectDeviceBlock = ^(id blockData) {
        weakSelf.currentDevice = blockData;
        [HLJHttp shared].user.currentDeviceModel = self.currentDevice;
        [weakSelf updateData];
        [weakSelf.collectionView reloadData];
    };
    [self.navigationController pushViewController: vc animated:YES];
    
}


#pragma mark MQTT

- (void)mqttConnect{
    [[MQTTClientModel sharedInstance] bindWithUserName:@"eh12sz3/innovation" password:@"qxCJBmqN1Yq3EjC1" cliendId:[NSUUID UUID].UUIDString isSSL:NO];
    [[MQTTClientModel sharedInstance] subscribeTopic:[NSString stringWithFormat:@"innovation_v1/message/%@/%@",self.currentDevice.mq_group,self.currentDevice.id]];
    [MQTTClientModel sharedInstance].delegate = self;
}

- (void)connectStatus:(NSString *)status{
    if ([status containsString:@"开始"]) {
        self.MQTTStatus = 0;
    }else if ([status containsString:@"连接中"]) {
        self.MQTTStatus = 1;
    }else if ([status containsString:@"成功"]) {
        self.MQTTStatus = 2;
    }else {
        self.MQTTStatus = -1;
    }
    [self.collectionView reloadData];
}


- (void)MQTTClientModel_handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"--------%@",string);
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData* unzip = [self zlibInflate:decodedData];
    string = [[NSString alloc] initWithData:unzip encoding:NSUTF8StringEncoding];
    NSLog(@"%@",string);
}


#pragma mark zip
- (NSData *)zlibInflate:(NSData *)data
{
    if ([data length] == 0) return data;
    
    NSUInteger full_length = [data length];
    NSUInteger half_length = [data length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[data bytes];
    strm.avail_in = (unsigned)[data length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit (&strm) != Z_OK) return nil;
    
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uint)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}

- (NSData *)zlibDeflate:(NSString*)string
{
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];

    if ([data length] == 0) return data;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[data bytes];
    strm.avail_in = (uint)[data length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit(&strm, Z_DEFAULT_COMPRESSION) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chuncks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uint)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData: compressed];
}


- (void)startNFC:(id)sender {
    [self startNFC];
}

- (void)startNFC{
    if (@available(iOS 11.0, *)) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0 && [NFCNDEFReaderSession readingAvailable]) {
            if (@available(iOS 11.0, *)) {
                self.session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:nil invalidateAfterFirstRead:NO];
                [self.session beginSession];
                
            } else {
                // Fallback on earlier versions
            }
            self.session.alertMessage = @"请将产品靠近手机";
            
        }else{
            [self.view makeToast:@"该设备不支持NFC功能" duration:3 position:CSToastPositionCenter];
        }
    } else {
        [self.view makeToast:@"该设备不支持NFC功能" duration:3 position:CSToastPositionCenter];
        // Fallback on earlier versions
    }
}

#pragma mark - NFCReaderSessionDelegate
// Check invalidation reason from the returned error. A new session instance is required to read new tags.
// 识别出现Error后会话会自动终止，此时就需要程序重新开启会话
- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error  API_AVAILABLE(ios(11.0)){
    // error明细参考NFCError.h
    NSLog(@"dd");
}

// Process detected NFCNDEFMessage objects
- (void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages  API_AVAILABLE(ios(11.0)){
    // 数组messages中是NFCNDEFMessage对象
    // NFCNDEFMessage对象中有一个records数组，这个数组中是NFCNDEFPayload对象
    // 参考NFCNDEFMessage、NFCNDEFPayload类
    // 解析数据
    [self.session invalidateSession];
    for (NFCNDEFMessage *message in messages) {
        for (NFCNDEFPayload *playLoad in message.records) {
            NSString *searchText = [[NSString alloc] initWithData:playLoad.payload encoding:NSUTF8StringEncoding];
            searchText = [searchText stringByReplacingOccurrencesOfString:@"\x01" withString:@""];
            searchText = [searchText stringByReplacingOccurrencesOfString:@"\x02" withString:@""];
            searchText = [searchText stringByReplacingOccurrencesOfString:@"en" withString:@""];
            if(searchText.length > 0){
                [[HLJHttp shared] getUUIDInfo:[searchText uppercaseString] success:^(NSDictionary *data) {
                    [self.view hideToastActivity];
                    self.model = [UUIDModel yy_modelWithJSON:data[@"item"]];
                    if([self.model.format isEqualToString:@"partner"]){
                        if(self.model.mulit){
                            self.currentCompany = self.model.mulit_info.firstObject.name;
                        }else if(self.model.partner_info){
                            self.currentCompany = self.model.partner_info.name;
                        }
                        [self postMQTTMessage:data[@"item"]];


                    }else{
                        [self postMQTTMessage:data[@"item"]];
                    }
                    if (self.model.demos_script.length > 0) {
                        [self getLectureInfo];
                    }
                    [self.collectionView reloadData];
                } failure:^(NSInteger code, NSString *error) {
                    [self.view makeToast:error duration:3 position:CSToastPositionCenter];
                }];
            }
        }
    }
}

- (void)getLectureInfo{
    [[HLJHttp shared] getLecureInfo:self.model.demos_script success:^(NSDictionary * _Nonnull data) {
            self.lectureModel = [LectureModel yy_modelWithJSON:data[@"item"]];
            [self.collectionView reloadData];
        } failure:^(NSInteger code, NSString * _Nonnull error) {
            NSLog(@"Get Lecture data error ");
        }];
}

- (void)showList{
//    NSMutableArray *titleArray = [NSMutableArray new];
//    for (UUIDModelMulitInfo *data in self.model.mulit_info) {
//        [titleArray addObject:data.name];
//    }
//    HLJRelateListViewController *vc = [HLJRelateListViewController new];
//    vc.dataArray = self.model.mulit_info;
//    vc.model = self.model;
//    [self.navigationController pushViewController:vc animated:YES];


}

- (void)postMQTTMessage:(NSDictionary*)model{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *str = [model yy_modelToJSONString];
        NSData* en = [self zlibDeflate:str];
        NSString *string  = [en base64EncodedStringWithOptions:0];
        NSString *msg = [NSString stringWithFormat:@"innovation_v1/message/%@/%@",self.currentDevice.mq_group,self.currentDevice.id];
        [[MQTTClientModel sharedInstance] sendDataToTopic:msg data:[[NSData alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]]];
    });
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
