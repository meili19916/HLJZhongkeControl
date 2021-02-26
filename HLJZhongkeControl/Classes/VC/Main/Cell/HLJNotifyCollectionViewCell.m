//
//  HLJNotifyCollectionViewCell.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/25.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJNotifyCollectionViewCell.h"

@implementation HLJNotifyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 5;//这里间距为10，可以根据自己的情况调整
    frame.origin.y = 5;
    frame.size.width -= 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}
@end
