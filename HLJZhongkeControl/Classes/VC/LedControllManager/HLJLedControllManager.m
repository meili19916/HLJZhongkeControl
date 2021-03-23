//
//  HLJLedControllManager.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/25.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJLedControllManager.h"

@implementation HLJLedControllManager
+(HLJLedControllManager *)shared {
    static HLJLedControllManager *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [HLJLedControllManager new];
        client.SEDN_CMD = [NSMutableArray new];
        [client.SEDN_CMD addObjectsFromArray:@[@"FF FF FF FF FF FF 00 00 00 00 78 34 01 00 29 BC FD 00 00 00 00 00 00 ",
                        @"14 00 ",@"01 00 01 02 06 01 ",
                        @"CE D2 B0 AE D6 D0 BA BD C8 ED BC FE ",
                        @"45 8C ",
                        @"A5"]];
        
    });
    return client;
}

- (void)TCPConnectToHost:(NSString*)host onPort:(NSInteger)port{
    NSError * error = nil;
    self.host = host;
    self.port = port;
    [self.controlSocket connectToHost:host onPort:port error:&error];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"TCP链接成功");
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"TCP链接失败");
    [self TCPConnectToHost:self.host onPort:self.port];
}

- (void)openLed{
    NSString *openCmd = @"FF FF FF FF FF FF 00 00 00 00 78 34 01 00 21 00 00 00 00 00 00 00 00 00 00 A0 D4 A5";
    [self.controlSocket writeData:[self hexToByteData:openCmd] withTimeout:-1 tag:0];
}

-(void)closeLed{
    NSString *closeCmd = @"FF FF FF FF FF FF 00 00 00 00 78 34 01 00 22 00 00 00 00 00 00 00 00 00 00 AF 90 A5";
    [self.controlSocket writeData:[self hexToByteData:closeCmd] withTimeout:-1 tag:0];
}

- (void)sendLed:(NSString *)text{
    int len = text.length;
    text =  [self unicode_to_GB2312string:text];
    NSString *temp = text;
    self.SEDN_CMD[1] = [self toHexString:8+len*2];
    self.SEDN_CMD[2] = [@"01 00 01 02 06 01 " stringByAppendingString:[self toHexString:len*2]];
    self.SEDN_CMD[3] = temp;
    NSString *strSendText = @"";
    for (NSString *str in self.SEDN_CMD) {
        strSendText = [strSendText stringByAppendingString:str];
    }
    NSString *strCRC = [self toHexString:[self get_CRC_Sum:strSendText]];
    self.SEDN_CMD[4] = strCRC;
    strSendText = @"";
    for (NSString *str in self.SEDN_CMD) {
        strSendText = [strSendText stringByAppendingString:str];
    }
    [self.controlSocket writeData:[self hexToByteData:strSendText] withTimeout:-1 tag:0];
 }

- (NSString*)toHexString:(int)hexNumber{
    NSString *hexStr = [NSString stringWithFormat:@"%x", hexNumber];
    if ([hexStr length] % 2  == 1) {
        hexStr = [NSString stringWithFormat:@"0%@", hexStr];
    }
    if ([hexStr length]  == 2) {
        hexStr = [NSString stringWithFormat:@"00%@", hexStr];
    }
    if ([hexStr length]  > 4) {
        hexStr = [hexStr substringWithRange:NSMakeRange(hexStr.length - 5, 4)];
    }
    hexStr = [NSString stringWithFormat:@"%@ %@ ",[hexStr substringWithRange:NSMakeRange(2, 2)] ,[hexStr substringWithRange:NSMakeRange(0, 2)] ];
    return [hexStr uppercaseString];
}


- (NSString *)bytesToHex:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

- (NSString *)byteToHex:(Byte )b
{
    NSString *hexStr = [NSString stringWithFormat:@"%x", b & 0xff];
    return hexStr.uppercaseString;
}

-(char)hexToByte:(NSString *)str{
    int intByte = (int)strtoul([str UTF8String],0,16);
    char byte = (char)intByte;
    return byte;

}
- (NSString*)unicode_to_GB2312string:(NSString*)texU{
    int  iTemp, iLen = 0;
    Byte buffer[1024];
    NSString *text = texU;
    NSString *str,*temp=@"";
    for (int i = 0; i <text.length; i ++) {
        temp = [text substringWithRange:NSMakeRange(i, 1)];
        iTemp = [temp characterAtIndex:0];
        if (iTemp <128) {
            buffer[iLen] = 0x00;
            buffer[iLen+1] = ([temp UTF8String][0] & 0xFF);
        }else{
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSData* testData = [temp dataUsingEncoding:enc];
      //在转byte
            Byte*testByte = (Byte*)[testData bytes];
            Byte bData[] = {};
            for(int i=0;i<[testData length];i++)
            {
                bData[i] = testByte[i];
            }
            buffer[iLen] = bData[0];
            buffer[iLen+1] = bData[1];
        }
        iLen += 2;
    }
    temp = @"";
    for (int i = 0; i < iLen; i++){
        str = [self byteToHex:buffer[i]].uppercaseString;
        temp = [temp stringByAppendingString:(str.length == 1 ? [@"0" stringByAppendingString:str] : str)];
        temp = [temp stringByAppendingString:@" "];
    }
    return temp;
}

- (int)get_CRC_Sum:(NSString*)strTemp{
    int CRCFull = 0xFFFF;
    int CRCLSB =0;
    int i = 0, j = 0;
    NSArray *strArray = [strTemp componentsSeparatedByString:@" "];
    NSArray *byteArray = [self hexToIntArray:strTemp];
    int iLen = strArray.count;
    for (i = 10; i < iLen - 3; i++){
        int byte = [byteArray[i] intValue];
        CRCFull = (CRCFull ^ byte);
        for (j = 0; j < 8; j++){
            CRCLSB = (Byte)((CRCFull & 0x0001) & 0xFFFF);
            CRCFull = ((CRCFull >> 1) & 0x7FFF) & 0xFFFF;
            if (CRCLSB == 1)
                CRCFull = (CRCFull ^ 0xA001) & 0xFFFF;
        }
    }
    return CRCFull;
}

- (NSArray*)hexToIntArray:(NSString*)inHex{
    inHex = [inHex stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ((inHex.length % 2) != 0) {
        inHex = [inHex stringByAppendingString:@" "];
    }
    NSMutableArray *returnBytes = [NSMutableArray new];
    for (int i = 0 ; i < inHex.length/2; i ++) {
        NSCharacterSet  *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *str = [[inHex substringWithRange:NSMakeRange(i*2, 2)] stringByTrimmingCharactersInSet:set];
        int byte = (int)strtoul([str UTF8String],0,16) & 0XFFFF;
        [returnBytes addObject:@(byte)];
    }
    return returnBytes;
}

- (NSArray*)hexToByteArray:(NSString *)inHex{
    inHex = [inHex stringByReplacingOccurrencesOfString:@" " withString:@""];
    int hexlen = inHex.length;
    NSMutableArray *result;
    if (hexlen % 2 == 1) {
        hexlen ++;
        result = [[NSMutableArray alloc] init];
        inHex = [@"0" stringByAppendingString:inHex];
    }else{
        result = [NSMutableArray new];
    }
    for (int i = 0; i < hexlen; i += 2) {
        [result addObject:@([self hexToByte:[inHex substringWithRange:NSMakeRange(i , 2)]])];
    }
    return result;
}

- (NSData*)hexToByteData:(NSString *)inHex{
    inHex = [inHex stringByReplacingOccurrencesOfString:@" " withString:@""];
    int hexlen = inHex.length;
    NSMutableData *result = [NSMutableData new];
    if (hexlen % 2 == 1) {
        hexlen ++;
        result = [[NSMutableArray alloc] init];
        inHex = [@"0" stringByAppendingString:inHex];
    }
    for (int i = 0; i < hexlen; i += 2) {
        Byte byte = [self hexToByte:[inHex substringWithRange:NSMakeRange(i , 2)]];
        Byte * a = malloc(1);
        a[0] = byte;
        [result appendBytes:a length:1];
    }
    return result;
}
@end
