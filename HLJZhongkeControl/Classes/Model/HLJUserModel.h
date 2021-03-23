//
//  HLJUserModel.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/4.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@class UUIDModelMulitInfo,UUIDModelExtend,UUIDPartnerInfoModel,LectureStepModel,LectureLightDetailModel,HLJDeviceModel;

NS_ASSUME_NONNULL_BEGIN

@interface HLJUserInfoImageModel : NSObject
@property (nonatomic,strong) NSString *md5;
@property (nonatomic,strong) NSString *url;
@end

@interface HLJUserInfoModel : NSObject
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *position_tag;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) HLJUserInfoImageModel *face_md5;
@end

@interface HLJUserModel : NSObject
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) HLJUserInfoModel *user_info;
@property (nonatomic,strong) HLJDeviceModel *currentDeviceModel;
@end


@interface HLJDeviceModel : NSObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *parent;
@property (nonatomic,strong) NSString *tree_code;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *order;
@property (nonatomic,strong) NSString *structure_chart;
@property (nonatomic,strong) NSString *mq_group;

@end

@interface UUIDModel : NSObject
@property (nonatomic, copy) NSArray <UUIDModelExtend*>*extend;
@property (nonatomic, copy) NSString *auto_stop;
@property (nonatomic, copy) NSString *demos_script;
//@property (nonatomic, copy) NSString *led_content;
@property (nonatomic, copy) NSString *display_resolution;
@property (nonatomic, copy) NSString *example;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *light_control_type;
@property (nonatomic, copy) NSString *led_ip;
@property (nonatomic, copy) NSString *led_port;
@property (nonatomic, assign) BOOL mulit;
@property (nonatomic, copy) NSMutableArray <UUIDModelMulitInfo*>*mulit_info;
//@property (nonatomic, strong) NSString *light_detail;

@property (nonatomic, copy) NSString *light_map;
@property (nonatomic, copy) NSString *modify_time;
@property (nonatomic, copy) NSString *must;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *open_app;
@property (nonatomic, strong) UUIDPartnerInfoModel *partner_info;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *type_code;
@property (nonatomic, copy) NSString *uuid;

@end

@interface UUIDPartnerInfoModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *parent ;
@property (nonatomic, copy) NSString *short_name;

@end

@interface UUIDModelExtend : NSObject
@property (nonatomic, copy) NSString *extend;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) NSString *imei ;
@property (nonatomic, copy) NSString *mq_id;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *open_app;

@end

@interface UUIDModelMulitInfo : NSObject
@property (nonatomic, copy) NSArray <UUIDModelExtend*>*settings;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *short_name;
@property (nonatomic, assign) BOOL has_children;
@property (nonatomic, copy) NSString *parent;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, copy) NSMutableArray <UUIDModelMulitInfo*>*items;
@end


@interface LectureModel : NSObject
@property (nonatomic, copy) NSDictionary *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *exhibition;
@property (nonatomic, strong) NSArray <LectureStepModel*>*Steps;

@end
@interface LectureLedSetModel : NSObject
@property (nonatomic, copy) NSString *led_port;
@property (nonatomic, copy) NSString *led_content;
@property (nonatomic, copy) NSString *led_ip;

@end

@interface LectureStepModel : NSObject
@property (nonatomic, copy) NSDictionary *device;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *device_id;
@property (nonatomic, strong) LectureLedSetModel *led_set;
@property (nonatomic, copy) NSDictionary *light_map;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, strong) NSArray <LectureLightDetailModel*>*light_setting_detail;
@end



@interface LectureLightDetailModel : NSObject
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL control;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, assign) NSInteger no;
@end

@interface LectureDeviceInfoModel : NSObject
@property (nonatomic, copy) NSString *device_id;
@property (nonatomic, copy) NSString *imei;
@property (nonatomic, copy) NSString *mq_id;
@property (nonatomic, copy) NSString *name;
@end
@interface LectureDeviceModel : NSObject
@property (nonatomic, copy) NSString *device_id;
@property (nonatomic, strong) LectureDeviceInfoModel *device_info;
@property (nonatomic, copy) NSString *display_resolution;
@property (nonatomic, copy) NSArray *example;
@property (nonatomic, copy) NSString *extend;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, assign) BOOL must;
@property (nonatomic, assign) NSInteger note;
@property (nonatomic, copy) NSString *open_app;
@property (nonatomic, copy) NSString *play;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) float volume;
@property (nonatomic, copy) NSString *id;
@end


@interface DeviceShowModel : NSObject
@property (nonatomic, copy) NSString *led_port;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mq_id;
@property (nonatomic, copy) NSArray *formats;
@property (nonatomic, assign) BOOL use_led;
@property (nonatomic, assign) NSInteger show_type;
@property (nonatomic, copy) NSString *iei;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) NSInteger search_display;
@property (nonatomic, copy) NSString *mq_group;
@property (nonatomic, copy) NSString *formats_str;
@property (nonatomic, copy) NSString *setting_str;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSDictionary *default_info;
@property (nonatomic, copy) NSString *led_ip;
@property (nonatomic, copy) NSString *type_code;
@property (nonatomic, copy) NSString *exhibition_code;
@property (nonatomic, copy) NSString *led_content;
@property (nonatomic, assign) BOOL use_default;
@property (nonatomic, copy) NSString *search_name;
@property (nonatomic, assign) BOOL expand;

@end

NS_ASSUME_NONNULL_END
