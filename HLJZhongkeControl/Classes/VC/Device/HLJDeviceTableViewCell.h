//
//  HLJDeviceTableViewCell.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/26.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLJHttp.h"
#import "SocketRocketUtility.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^HLJCommonBlock)(id blockData);

@interface HLJDeviceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic,copy) HLJCommonBlock socketConnectBlock;
@property (nonatomic,copy) HLJCommonBlock startBlock;
@property (nonatomic,copy) HLJCommonBlock replayBlock;
@property (nonatomic,copy) HLJCommonBlock controllBlock;
@property (nonatomic,copy) HLJCommonBlock voiceChangedBlock;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *volomLabel;
@property (weak, nonatomic) IBOutlet UILabel *button1Label;
@property (weak, nonatomic) IBOutlet UILabel *button2Labe;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;
@property (nonatomic,strong) DeviceShowModel *model;
@property (nonatomic,strong) SocketRocketUtility *socket;
@end

NS_ASSUME_NONNULL_END
