//
//  HLJLedControllManager.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/25.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLJLedControllManager : NSObject<GCDAsyncSocketDelegate>
@property (nonatomic,strong) NSMutableArray *SEDN_CMD;
@property (nonatomic,strong) GCDAsyncSocket *controlSocket;
@property (nonatomic,strong) NSString *host;
@property (nonatomic,assign) NSInteger port;

+(HLJLedControllManager *)shared;
- (void)TCPConnectToHost:(NSString*)host onPort:(NSInteger)port;
- (void)openLed;
-(void)closeLed;
- (void)sendLed:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
