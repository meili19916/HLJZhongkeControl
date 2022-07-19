//
//  HLJRemoteControlViewController.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/22.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLJUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLJRemoteControlViewController : UIViewController

@property (nonatomic,strong) DeviceShowModel *model;
@property (nonatomic,strong) NSArray *deviceArray;
@end

NS_ASSUME_NONNULL_END
