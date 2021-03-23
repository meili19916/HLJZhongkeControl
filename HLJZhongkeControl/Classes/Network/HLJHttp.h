//
//  HLJHttp.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/26.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFImageDownloader.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HLJUserModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HLJHttpDelegate<NSObject>
- (void)pushToLoginView;
@end
@interface HLJHttp : AFHTTPSessionManager
@property (nonatomic, weak) id <HLJHttpDelegate>delegate;
@property (nonatomic, strong) HLJUserModel *user;
+(HLJHttp *)shared;


-(void)getUUIDInfo:(NSString*)uuid success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure;

-(void)login:(NSDictionary*)data success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure;

-(void)sms:(NSDictionary*)data success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure;

-(void)getDeviceList:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure;

-(void)getTurnList:(NSDictionary*)data success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure;

-(void)getPartnerList:(NSString*)partnerId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure;

-(void)getLecureInfo:(NSString*)lectureId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure;

-(void)getDeviceShowList:(NSDictionary*)data success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure;
-(void)getUserInfo:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure;
@end

NS_ASSUME_NONNULL_END
