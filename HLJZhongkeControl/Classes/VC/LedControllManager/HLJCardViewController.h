//
//  HLJCardViewController.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/1.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJBaseViewController.h"
@class HLJCardModel;
NS_ASSUME_NONNULL_BEGIN

@interface HLJCardViewController : HLJBaseViewController
@property (nonatomic,strong) NSArray <HLJCardModel*>*dataArray;
@end

NS_ASSUME_NONNULL_END
