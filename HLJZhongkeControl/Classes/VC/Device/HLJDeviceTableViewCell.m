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
    // Initialization code
}
-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 5;//这里间距为10，可以根据自己的情况调整
    frame.origin.y = 10;
    frame.size.width -= 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)startButtonClicked:(id)sender {
    if (self.startBlock) {
        self.startBlock(nil);
    }
}
- (IBAction)replayButtonClicked:(id)sender {
    if (self.replayBlock) {
        self.replayBlock(nil);
    }
}
- (IBAction)remoteButtonClicked:(id)sender {
    if (self.controllBlock) {
        self.controllBlock(nil);
    }
}
- (IBAction)sliderValueChanged:(UISlider*)sender {
    if (self.controllBlock) {
        self.controllBlock(@(sender.value));
    }
}

@end
