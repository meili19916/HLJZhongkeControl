//
//  HLJImageStepTableViewCell.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/11.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^HLJImageStepTableViewCellBlock)(id blockData);

@interface HLJImageStepTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (nonatomic,copy) HLJImageStepTableViewCellBlock beforeBlock;
@property (nonatomic,copy) HLJImageStepTableViewCellBlock nextBlock;

@end

NS_ASSUME_NONNULL_END
