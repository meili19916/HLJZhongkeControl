//
//  RoleNextViewController.h
//  zhongkePlatform
//
//  Created by Juan on 2020/12/8.
//

#import "HLJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoleNextViewController : HLJBaseViewController
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSArray *selectArray;
@property (nonatomic,copy) HLJCommonBlock selectBlock;
@property (nonatomic,strong) NSString *parentID;

@end

NS_ASSUME_NONNULL_END
