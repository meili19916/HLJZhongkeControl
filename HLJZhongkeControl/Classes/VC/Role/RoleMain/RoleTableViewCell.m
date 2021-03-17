//
//  RoleTableViewCell.m
//  zhongkePlatform
//
//  Created by Juan on 2020/12/7.
//

#import "RoleTableViewCell.h"

@implementation RoleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (IBAction)selectButtonClicked:(id)sender {
    if (self.selectBlock) {
        self.selectBlock(@"");
    }
}

@end
