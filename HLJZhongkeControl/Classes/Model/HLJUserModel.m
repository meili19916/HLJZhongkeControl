//
//  HLJUserModel.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/4.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJUserModel.h"
@implementation HLJUserInfoImageModel
@end
@implementation HLJUserInfoModel
@end
@implementation HLJUserModel

@end
@implementation HLJDeviceModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"led_infos" : [HLJCardModel class]};
}
@end
@implementation UUIDModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"extend" : [UUIDModelExtend class],@"mulit_info":[UUIDModelMulitInfo class]};
}
@end
@implementation UUIDModelExtend

@end
@implementation UUIDModelMulitInfo

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"settings" : [UUIDModelExtend class]};
}
@end
@implementation UUIDPartnerInfoModel

@end
@implementation LectureModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"Steps" : [LectureStepModel class]};
}
@end
@implementation LectureLedSetModel

@end
@implementation LectureStepModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"light_setting_detail" : [LectureLightDetailModel class]};
}

-(NSString *)img{
    if (_img.length > 0 && ![_img containsString:@"http://"]) {
        return [NSString stringWithFormat:@"https://exhibition.rfidtrace.com/data/ali-file/%@",_img];
    }
    return _img;
}
@end
@implementation LectureLightDetailModel


@end
@implementation LectureDeviceInfoModel


@end
@implementation LectureDeviceModel


@end
@implementation DeviceShowModel

@end
@implementation HLJCardModel

@end
