//
//  HLJNoteStepTableViewCell.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/11.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJNoteStepTableViewCell.h"

@implementation HLJNoteStepTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
