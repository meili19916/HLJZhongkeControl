//
//  HLJMainViewController.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/24.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJBaseViewController.h"
#import "HLJHttp.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLJMainViewController :HLJBaseViewController
- (void)postMQTTMessage:(UUIDModel*)model;
@end

NS_ASSUME_NONNULL_END
