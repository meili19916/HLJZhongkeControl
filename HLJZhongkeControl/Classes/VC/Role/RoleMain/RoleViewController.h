//
//  RoleViewController.h
//  zhongkePlatform
//
//  Created by Juan on 2020/12/7.
//

#import "HLJBaseViewController.h"
@class  UUIDModel;
NS_ASSUME_NONNULL_BEGIN

@interface RoleViewController : HLJBaseViewController
@property (nonatomic,copy)HLJCommonBlock  selectBlock;
@property (nonatomic, strong) UUIDModel *model;

@end

NS_ASSUME_NONNULL_END
