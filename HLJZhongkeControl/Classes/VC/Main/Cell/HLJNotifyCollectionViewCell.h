//
//  HLJNotifyCollectionViewCell.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/25.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLJNotifyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lab1Label;
@property (weak, nonatomic) IBOutlet UILabel *lab2Label;
@property (weak, nonatomic) IBOutlet UILabel *lab3Label;
@property (weak, nonatomic) IBOutlet UILabel *lab4Label;

@end

NS_ASSUME_NONNULL_END
