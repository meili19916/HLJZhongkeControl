//
//  HLJDeviceTableViewCell.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/26.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void (^HLJCommonBlock)(id blockData);

@interface HLJDeviceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic,copy) HLJCommonBlock startBlock;
@property (nonatomic,copy) HLJCommonBlock replayBlock;
@property (nonatomic,copy) HLJCommonBlock controllBlock;
@property (nonatomic,copy) HLJCommonBlock voiceChangedBlock;

@end

NS_ASSUME_NONNULL_END
