//
//  HLJLectureModelViewController.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/11.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJBaseViewController.h"
@class  LectureModel;
NS_ASSUME_NONNULL_BEGIN

@interface HLJLectureModelViewController : HLJBaseViewController
@property (nonatomic,copy) NSString *lectureId;
@property (nonatomic, strong) LectureModel *model;

@end

NS_ASSUME_NONNULL_END
