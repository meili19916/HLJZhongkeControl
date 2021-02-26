//
//  HLJRemoteControlViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/22.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJRemoteControlViewController.h"
#import "GCDAsyncUdpSocket.h"
#include <zlib.h>
#import <Toast/UIView+Toast.h>
//发数据接口:1322  搜udp广播端口:1233
@interface HLJRemoteControlViewController ()<GCDAsyncUdpSocketDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;
@property (nonatomic,strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic,strong) GCDAsyncUdpSocket *controlSocket;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (nonatomic,strong) NSMutableDictionary *deviceArray;
@property (nonatomic,strong) UIView *deviceListView;
@property (nonatomic,strong) UITableView *deviceTableView;
@property (weak, nonatomic) IBOutlet UIView *controlBackView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIView *voiceBackView;
@property (weak, nonatomic) IBOutlet UIView *scorllBackView;
@property (weak, nonatomic) IBOutlet UIButton *inputTextButton;

@property (weak, nonatomic) IBOutlet UIImageView *tapBackView;
@property (weak, nonatomic) IBOutlet UILabel *notifyLabel;


@property (nonatomic,strong) UILongPressGestureRecognizer *longGes1;
@end

@implementation HLJRemoteControlViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    [_udpSocket close];
    _udpSocket = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.deviceArray = [NSMutableDictionary new];
    [self UDPConnect];
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(switchButtonLongGes:)];
    [self.switchButton addGestureRecognizer:longGes];
    self.sureButton.layer.cornerRadius = 60;
    self.sureButton.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor;
    self.sureButton.layer.borderWidth = 1;
    
    self.controlBackView.layer.cornerRadius = 120;
    self.controlBackView.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor;
    self.controlBackView.layer.borderWidth = 1;
    
    self.homeButton.layer.cornerRadius = 33;
    self.homeButton.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor;
    self.homeButton.layer.borderWidth = 1;
    
    self.backButton.layer.cornerRadius = 33;
    self.backButton.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor;
    self.backButton.layer.borderWidth = 1;
    
    self.inputTextButton.layer.cornerRadius = 33;
    self.inputTextButton.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor;
    self.inputTextButton.layer.borderWidth = 1;
    
    self.voiceBackView.layer.cornerRadius = 33;
    self.voiceBackView.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor;
    self.voiceBackView.layer.borderWidth = 1;
    self.voiceBackView.layer.masksToBounds = YES;

    
    self.scorllBackView.layer.cornerRadius = 33;
    self.scorllBackView.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor;
    self.scorllBackView.layer.borderWidth = 1;
    self.scorllBackView.layer.masksToBounds = YES;
    
    self.switchButton.layer.cornerRadius = 33;
    self.switchButton.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor;
    self.switchButton.layer.borderWidth = 1;
    
    
    [self.segmentView setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]} forState:UIControlStateNormal];
    [self.segmentView setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.89]} forState:UIControlStateSelected];
    
    

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];

    [self.tapBackView addGestureRecognizer:tapGesture];
    
    self.longGes1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapGesture:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.tapBackView addGestureRecognizer:panGesture];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)segementChanged:(id)sender {
    if (self.segmentView.selectedSegmentIndex == 0) {
        self.notifyLabel.hidden = YES;
        self.tapBackView.hidden = YES;
        self.controlBackView.hidden = NO;
    }else if (self.segmentView.selectedSegmentIndex == 1) {
        self.notifyLabel.hidden = YES;
        self.tapBackView.hidden = NO;
        self.controlBackView.hidden = YES;
        [self.tapBackView removeGestureRecognizer:self.longGes1];
        
    }else if (self.segmentView.selectedSegmentIndex == 2) {
        self.notifyLabel.hidden = NO;
        self.tapBackView.hidden = NO;
        self.controlBackView.hidden = YES;
        [self.tapBackView addGestureRecognizer:self.longGes1];
        
    }
}

- (void)panGesture:(UIPanGestureRecognizer*)gesture{
    CGPoint point = [gesture translationInView:self.view];
    CGPoint volocity = [gesture velocityInView:self.view];

    NSInteger x =  point.x;
    NSInteger y =  point.y;
    NSInteger scale = 3;
    NSData *data = [[NSString stringWithFormat:@"move %d %d",x, y] dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"---------------------------&&& %d %d %d %d",,x,y);
    [self.controlSocket sendData:data withTimeout:1 tag:1];
    if (gesture.state == UIGestureRecognizerStateChanged){
        
    }
}

- (void)longTapGesture:gesture{
    NSData *data = [@"longClick" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];
}

- (void)tapGesture:gesture{
    NSData *data = [@"click" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];
}

- (void)UDPConnect{
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError * error = nil;
    [_udpSocket bindToPort:12333 error:&error];
    
    if (error) {//监听错误打印错误信息
//        [self.view makeToast:error.description duration:3 position:CSToastPositionCenter];
        [_udpSocket beginReceiving:&error];
        NSLog(@"error:%@",error);
    }else {//监听成功则开始接收信息
        [_udpSocket beginReceiving:&error];
    }
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error{
    [self.view makeToast:@"UDP未链接" duration:3 position:CSToastPositionCenter];

}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error{
    [self.view makeToast:@"UDP链接关闭" duration:3 position:CSToastPositionCenter];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    [self.view makeToast:@"指令发送失败" duration:3 position:CSToastPositionCenter];

}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
    NSLog(@"链接成功");//自行转换格式吧
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    if (sock == self.udpSocket) {
        [self reciveBroadPostData:data fromAddress:address];
    }
}

- (void)reciveBroadPostData:(NSData*)data fromAddress:(NSData *)address{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    [self.view makeToast:[NSString stringWithFormat:@"收到广播:%@",string] duration:3 position:CSToastPositionCenter];

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
            if (self.deviceArray.allValues.count == 0) {
                self.controlSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
                NSError * error = nil;
                [self.controlSocket connectToHost:addressString onPort:1322 error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.deviceNameLabel.text = string;
                });
            }
            [self.deviceArray setObject:addressString forKey:string];
          
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
    [self showDeviceLiseView];
}
- (IBAction)up:(id)sender {
    NSData *data = [@"dpadUp" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];
}
- (IBAction)down:(id)sender {
    NSData *data = [@"dpadDown" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];

}
- (IBAction)sure:(id)sender {
    NSData *data = [@"dpadCenter" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];
}
- (IBAction)left:(id)sender {
    NSData *data = [@"dpadLeft" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];

}
- (IBAction)right:(id)sender {
    NSData *data = [@"dpadRight" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];

}
- (IBAction)homePage:(id)sender {
    NSData *data = [@"home" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];

}
- (IBAction)back:(id)sender {
    NSData *data = [@"back" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];

}
- (IBAction)menu:(id)sender {
    NSData *data = [@"recent" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];

}
- (IBAction)voiceUP:(id)sender {
    NSData *data = [@"volumeUp" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];

}
- (IBAction)voiceDown:(id)sender {
    NSData *data = [@"volumeDown" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];

}
- (IBAction)scrollUp:(id)sender {
    NSData *data = [@"pageUp" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];

}
- (IBAction)scrollDown:(id)sender {
    NSData *data = [@"pageDown" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];

}
- (IBAction)switch:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否重启设备" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertF = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:alertF];
    UIAlertAction *alertS = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSData *data = [@"reboot" dataUsingEncoding:NSUTF8StringEncoding];
        [self.controlSocket sendData:data withTimeout:3 tag:1];
    }];
    [alert addAction:alertS];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)switchButtonLongGes:sender{
    NSData *data = [@"powerDialog" dataUsingEncoding:NSUTF8StringEncoding];
    [self.controlSocket sendData:data withTimeout:3 tag:1];
}
- (IBAction)screen:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertF = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:alertF];
    UIAlertAction *alertS = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = alert.textFields.firstObject;
        NSData *data = [[NSString stringWithFormat:@"setText %@",tf.text] dataUsingEncoding:NSUTF8StringEncoding];
        [self.controlSocket sendData:data withTimeout:3 tag:1];
    }];
    [alert addAction:alertS];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
    }];
    [self presentViewController:alert animated:YES completion:nil];
    
//发送文字
}



- (UIView *)deviceListView{
    if (!_deviceListView) {
        _deviceListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        backView.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
        _deviceListView.backgroundColor = [UIColor clearColor];
        [_deviceListView addSubview:backView];
        UITapGestureRecognizer *hideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDevicView:)];
        [backView addGestureRecognizer:hideGesture];
        self.deviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _deviceListView.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2)];
        self.deviceTableView.delegate = self;
        self.deviceTableView.dataSource = self;
        self.deviceTableView.tableFooterView = [UIView new];
        self.deviceTableView.backgroundColor = [UIColor whiteColor];
        self.deviceTableView.separatorColor = [UIColor colorWithRed:238/255 green:238/255 blue:238/255 alpha:0.3];
        [_deviceListView addSubview:self.deviceTableView];
        
    }
    return _deviceListView;
}

- (void)showDeviceLiseView{
    [[UIApplication sharedApplication].keyWindow addSubview:self.deviceListView];
    [UIView animateWithDuration:0.24 animations:^{
        self.deviceListView.subviews.firstObject.alpha = 1;
        self.deviceTableView.frame = CGRectMake(0, self.deviceListView.frame.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2);
    }];
}

- (void)hideDevicView:sender{
    [UIView animateWithDuration:0.24 animations:^{
        self.deviceListView.subviews.firstObject.alpha = 0;
        self.deviceTableView.frame = CGRectMake(0, self.deviceListView.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2);
    } completion:^(BOOL finished) {
        [self.deviceListView removeFromSuperview];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceArray.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [UITableViewCell new];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = self.deviceArray.allKeys[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideDevicView:nil];
    NSError * error = nil;
    [self.controlSocket connectToHost:self.deviceArray.allValues[indexPath.row] onPort:1322 error:&error];
}
@end
