//
//  HLJDeviceTableViewCell.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/26.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJDeviceTableViewCell.h"

@implementation HLJDeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidClose) name:kWebSocketDidCloseNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidSendMsgError:) name:kWebSocketdidSendMessageErrorNote object:nil];
    // Initialization code
}
-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 5;//这里间距为10，可以根据自己的情况调整
//    frame.origin.y = 10;
    frame.size.width -= 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)startButtonClicked:(UIButton*)sender {
    if ([self.button1Label.text isEqualToString:@"暂停"]) {
        int n = 0x00;
        [self sendActionCMD:@(n)];
        self.model.label1Text = @"播放";
        self.button1Label.text = self.model.label1Text;
        [self.startButton setImage:[UIImage imageNamed:@"icon_jx"] forState:UIControlStateNormal];

    }else if ([self.button1Label.text isEqualToString:@"播放"]){
        int n = 0x01;
        [self sendActionCMD:@(n)];
        self.model.label1Text = @"暂停";
        self.button1Label.text = self.model.label1Text;
        [self.startButton setImage:[UIImage imageNamed:@"icon_jx"] forState:UIControlStateNormal];

    }else if ([self.button1Label.text isEqualToString:@"上一页"]){
        int n = 0x12;
        [self sendActionCMD:@(n)];
    }
}
- (IBAction)replayButtonClicked:(id)sender {
    if ([self.button2Labe.text isEqualToString:@"下一页"]){
        int n = 0x11;
        [self sendActionCMD:@(n)];
    }else{
        int n = 0x02;
        [self sendActionCMD:@(n)];
    }
}
- (IBAction)remoteButtonClicked:(id)sender {
    if (self.controllBlock) {
        self.controllBlock(@"");
    }
}
- (IBAction)sliderValueChanged:(UISlider*)sender {
    self.volomLabel.text = [NSString stringWithFormat:@"%.f%%",sender.value];
    NSMutableDictionary *motorConfig = [NSMutableDictionary new];
    [motorConfig setObject:@"set_volume" forKey:@"cmd"];
    [motorConfig setObject:@(sender.value) forKey:@"volume"];
    [self.socket sendData:[self convertToJsonData:motorConfig]];
}

- (void)setModel:(DeviceShowModel *)model{
    _model = model;
    if ([_model.label1Text isEqualToString:@"暂停"] || [_button1Label.text isEqualToString:@"播放"]) {
        [self.startButton setImage:[UIImage imageNamed:@"icon_jx"] forState:UIControlStateNormal];
        [self.replayButton setImage:[UIImage imageNamed:@"icon_cxbf"] forState:UIControlStateNormal];
    }
    if ([_model.label1Text isEqualToString:@"上一页"]){
        [self.startButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
        [self.replayButton setImage:[UIImage imageNamed:@"icon_last"] forState:UIControlStateNormal];
    }
    self.button1Label.text = _model.label1Text.length > 0 ? _model.label1Text : @"暂停/播放";
    self.button2Labe.text = _model.label2Text.length > 0 ? _model.label2Text : @"重播";
}
- (void)setSocket:(SocketRocketUtility *)socket{
    _socket = socket;
    [_socket SRWebSocketOpenWithURLString:[NSString stringWithFormat:@"ws://%@:2420/service",self.model.ip]];
}


- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
}


- (void)SRWebSocketDidSendMsgError:(NSNotification *)note{
    NSLog(@"开启失败");

}

- (void)SRWebSocketDidClose{
    NSLog(@"关闭");

}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息

    NSString * message = note.object[@"message"];
    NSDictionary *dic = [self dictionaryWithJsonString:message];
    if (note.object[@"socket"] == self.socket) {
        if ([dic[@"cmd"] isEqualToString:@"connected"]) {
            NSLog(@"connected%@",dic);
            [self sendCMD:@"get_volume"];
            [self sendCMD:@"cmd_get_play_state"];
            if (self.socketConnectBlock) {
                self.socketConnectBlock(nil);
            }
        }else if ([dic[@"cmd"] isEqualToString:@"error"]) {
            NSLog(@"error%@",dic);

        }else if ([dic[@"cmd"] isEqualToString:@"log"]) {
            NSLog(@"log%@",dic);

        }else if ([dic[@"cmd"] isEqualToString:@"succeed"]) {
            NSDictionary *data = [self dictionaryWithJsonString:dic[@"message"]];;
            if ([dic[@"act"] isEqualToString:@"cmd_get_play_state"]) {
                NSString *showType = data[@"display"];
                
                if ([showType isEqualToString:@"PICTURE"]) {
                    self.model.label1Text = @"上一页";
                    self.model.label2Text = @"下一页";
                    [self.startButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
                    [self.replayButton setImage:[UIImage imageNamed:@"icon_last"] forState:UIControlStateNormal];
                }else if ([showType isEqualToString:@"VIDEO"]){
                    BOOL playStatus = [data[@"playState"] boolValue];
                    self.model.label1Text = playStatus ? @"暂停" : @"播放";
                    self.model.label2Text = @"重新播放";
                    [self.startButton setImage:[UIImage imageNamed:@"icon_jx"] forState:UIControlStateNormal];
                    [self.replayButton setImage:[UIImage imageNamed:@"icon_cxbf"] forState:UIControlStateNormal];
                }
                self.button1Label.text = _model.label1Text.length > 0 ? _model.label1Text : @"暂停";
                self.button2Labe.text = _model.label2Text.length > 0 ? _model.label2Text : @"重播";
            }
        }if ([dic[@"cmd"] isEqualToString:@"get_volume"]) {
            NSInteger volume = [dic[@"volume"] intValue];
            self.volomLabel.text = [NSString stringWithFormat:@"%ld%%",(long)volume];
            self.slider.value = volume;
        }
    }
}

- (void)sendCMD:(NSString*)cmd{
    NSMutableDictionary *motorConfig = [NSMutableDictionary new];
    [motorConfig setObject:cmd forKey:@"cmd"];
    [self.socket sendData:[self convertToJsonData:motorConfig]];
}
- (void)sendActionCMD:(id)cmd{
    NSMutableDictionary *motorConfig = [NSMutableDictionary new];
    [motorConfig setObject:@"cmd_set_play_state" forKey:@"cmd"];
    [motorConfig setObject:cmd forKey:@"action"];

    [self.socket sendData:[self convertToJsonData:motorConfig]];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
@end
