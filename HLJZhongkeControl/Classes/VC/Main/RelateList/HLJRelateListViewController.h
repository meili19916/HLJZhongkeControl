//
//  HLJRelateListViewController.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/5.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLJHttp.h"
typedef void (^DeviceBlock)(id blockData);

NS_ASSUME_NONNULL_BEGIN

@interface HLJRelateListViewController : UIViewController
@property (nonatomic,copy) NSString *currentName;
@property (nonatomic,assign) BOOL isCard;

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,copy) DeviceBlock selectDeviceBlock;
@end

NS_ASSUME_NONNULL_END
