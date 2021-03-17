//
//  HLJLectureModelCollectionViewCell.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/11.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJLectureModelCollectionViewCell.h"

@implementation HLJLectureModelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)leftButtonClicked:(id)sender {
    if (self.leftBtttonBlock) {
        self.leftBtttonBlock(nil);
    }
}
- (IBAction)rightButtonClicke:(id)sender {
    if (self.rightBtttonBlock) {
        self.rightBtttonBlock(nil);
    }
}

@end
