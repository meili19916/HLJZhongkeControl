//
//  HLJHttp.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/26.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJHttp.h"

@implementation HLJHttp
+(HLJHttp *)shared {
    static HLJHttp *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"http://exhibition.rfidtrace.com/data"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        client = [[HLJHttp alloc] initWithBaseURL:baseURL sessionConfiguration:config];
        client.requestSerializer = [AFHTTPRequestSerializer serializer];
        client.responseSerializer = [AFJSONResponseSerializer serializer];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        client.user = [HLJUserModel yy_modelWithJSON:[userDefaults objectForKey:@"userModel"]];
        if (!client.user) {
            client.user = [[HLJUserModel alloc] init];
        }
    });
    return client;
}
-(void)post:(NSString *)path data:(id)data success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure finally:(void (^)(void))finally{
    NSString *url = [NSString stringWithFormat:@"http://exhibition.rfidtrace.com/data/app/v2/%@",path];
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
   
    if(self.user.token != nil){
        [self.requestSerializer setValue:self.user.token forHTTPHeaderField:@"X-Access-Token"];
    }
    if(data != nil){
        [args addEntriesFromDictionary:data];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self POST:url parameters:args headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSInteger code = [[responseObject objectForKey:@"meta"] integerValue];
        NSMutableDictionary *responseData = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        [responseData.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSNull class]]) {
                [responseData removeObjectForKey:[responseData allKeysForObject:obj].firstObject];
            }
        }];
        if (code == 10000) {
            if ([self.delegate respondsToSelector:@selector(pushToLoginView)]) {
                [self.delegate pushToLoginView];
            }
        }else if (code != 0){
            failure(code,[responseData objectForKey:@"error"]);
        }else{
            success(responseData);
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(200,@"网络连接错误");
        }];
}

- (void)get:(NSString *)path data:(id)data success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure finally:(void (^)(void))finally{

    NSString *url = [NSString stringWithFormat:@"http://exhibition.rfidtrace.com/data/app/v2/%@",path];
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    if(self.user.token != nil){
        [self.requestSerializer setValue:self.user.token forHTTPHeaderField:@"X-Access-Token"];
    }
    [self.requestSerializer setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"] isEqualToString:@"en"] ? @"en" : @"zh-cn" forHTTPHeaderField:@"X-Access-Language"];

    if(data != nil){
        [args addEntriesFromDictionary:data];
    }
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self GET:url parameters:args headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         NSInteger code = [[responseObject objectForKey:@"meta"] integerValue];
         NSMutableDictionary *responseData = [NSMutableDictionary dictionaryWithDictionary:responseObject];
         [responseData.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj isKindOfClass:[NSNull class]]) {
                 [responseData removeObjectForKey:[responseData allKeysForObject:obj].firstObject];
             }
         }];
         if (code == 10000) {
             if ([self.delegate respondsToSelector:@selector(pushToLoginView)]) {
                 [self.delegate pushToLoginView];
             }
         }else if (code != 0){
             failure(code,[responseData objectForKey:@"error"]);
         }else{
             success(responseData);
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(200,@"网络连接错误");
    }];
}
-(void)getUUIDInfo:(NSString*)uuid success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure {
    [self get:[NSString stringWithFormat:@"uuid_relation/list/%@",uuid] data:nil success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSInteger code, NSString *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(code,error);
        
    } finally:^{
    }];
}

-(void)login:(NSDictionary*)data success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure {
    [self post:@"admin/login" data:data success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSInteger code, NSString *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(code,error);
        
    } finally:^{
    }];
}

-(void)sms:(NSDictionary*)data success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure {
    [self post:@"login/sms" data:data success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSInteger code, NSString *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(code,error);
        
    } finally:^{
    }];
}

-(void)getDeviceList:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure {
    [self post:@"device_type/device-top" data:nil success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSInteger code, NSString *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(code,error);
        
    } finally:^{
    }];
}

-(void)getTurnList:(NSDictionary*)data success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure {
    [self post:@"turn/list" data:data success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSInteger code, NSString *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(code,error);
        
    } finally:^{
    }];
}
-(void)getPartnerList:(NSString*)partnerId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure{
    [self post:@"partner/list" data:@{@"parent":partnerId} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSInteger code, NSString *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(code,error);
        
    } finally:^{
    }];
}

-(void)getLecureInfo:(NSString*)lectureId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure {
    [self get:[NSString stringWithFormat:@"demos_script/%@",lectureId] data:nil success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSInteger code, NSString *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(code,error);
        
    } finally:^{
    }];
}

-(void)getDeviceShowList:(NSDictionary*)data success:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure {
    [self post:@"device/list" data:data success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSInteger code, NSString *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(code,error);
        
    } finally:^{
    }];
}

-(void)getUserInfo:(void (^)(NSDictionary *data))success failure:(void (^)(NSInteger code,NSString *error))failure {
    [self get:@"admin/info" data:nil success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSInteger code, NSString *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(code,error);
        
    } finally:^{
    }];
}
@end
