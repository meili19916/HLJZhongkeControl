//
//  HLJImageStepTableViewCell.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/11.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJImageStepTableViewCell.h"

@implementation HLJImageStepTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)beforeButtonClicked:(id)sender {
    if (self.beforeBlock) {
        self.beforeBlock(@"");
    }
}
- (IBAction)nextButtonClicked:(id)sender {
    if (self.nextBlock) {
        self.nextBlock(@"");
    }
}

@end
