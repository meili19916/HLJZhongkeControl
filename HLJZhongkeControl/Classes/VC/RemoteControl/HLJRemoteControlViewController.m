//
//  HLJRemoteControlViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/22.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJRemoteControlViewController.h"
#import "GCDAsyncUdpSocket.h"

//发数据接口:1322  搜udp广播端口:1233
@interface HLJRemoteControlViewController ()<GCDAsyncUdpSocketDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;
@property (nonatomic,strong) GCDAsyncUdpSocket *udpSocket;

@end

@implementation HLJRemoteControlViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    [_udpSocket close];
    _udpSocket = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self UDPConnect];

    // Do any additional setup after loading the view from its nib.
}
- (void)UDPConnect{
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError * error = nil;
    [_udpSocket bindToPort:23333 error:&error];
    
    if (error) {//监听错误打印错误信息
//        [self.view makeToast:error.description duration:3 position:CSToastPositionCenter];
        [_udpSocket beginReceiving:&error];
        NSLog(@"error:%@",error);
    }else {//监听成功则开始接收信息
        [_udpSocket beginReceiving:&error];
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.view makeToast:[NSString stringWithFormat:@"收到广播:%@",string] duration:3 position:CSToastPositionCenter];

    NSArray *array = [string componentsSeparatedByString:@"="];
    if (array.count > 0) {
        array = [[array lastObject] componentsSeparatedByString:@";end"];
        if (array.count > 0) {
            string =  (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)[array firstObject], CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:string options:0];
            NSData* unzip = [self gzipInflate:decodedData];
            string = [[NSString alloc] initWithData:unzip encoding:NSUTF8StringEncoding];
            NSString *addressString = [GCDAsyncUdpSocket hostFromAddress:address];
            if ([addressString containsString:@":"]) {
                addressString = [[addressString componentsSeparatedByString:@":"] lastObject];
            }
            NSLog(@"接收到%@的消息:%@",addressString,string);//自行转换格式吧
//            for(RelayModel *model in self.dataArray){
//                if ([model.ip isEqualToString:addressString]) {
//                    return;
//                }
//            }
//            RelayModel *model = [RelayModel new];
//            model.chin_name = string;
//            model.ip = addressString;
//            [self.dataArray addObject:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }
}

#pragma mark zip

- (NSData *)gzipDeflate:(NSString*)str

{
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    if ([data length] == 0) return data;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[data bytes];
    strm.avail_in = [data length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = [compressed length] - strm.total_out;
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}

- (NSData *)gzipInflate:(NSData*)data
{
    if ([data length] == 0) return data;
    
    unsigned full_length = [data length];
    unsigned half_length = [data length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[data bytes];
    strm.avail_in = [data length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK)
        return nil;
    
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END)
            done = YES;
        else if (status != Z_OK)
            break;
    }
    if (inflateEnd (&strm) != Z_OK)
        return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)selectEquipment:(id)sender {
}
- (IBAction)up:(id)sender {
}
- (IBAction)down:(id)sender {
}
- (IBAction)left:(id)sender {
}
- (IBAction)right:(id)sender {
}
- (IBAction)homePage:(id)sender {
}
- (IBAction)back:(id)sender {
}
- (IBAction)menu:(id)sender {
}
- (IBAction)voiceUP:(id)sender {
}
- (IBAction)voiceDown:(id)sender {
}
- (IBAction)scrollUp:(id)sender {
}
- (IBAction)scrollDown:(id)sender {
}
- (IBAction)switch:(id)sender {
}
- (IBAction)screen:(id)sender {
}

@end
