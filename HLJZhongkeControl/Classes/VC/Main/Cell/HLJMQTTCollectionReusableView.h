//
//  HLJMQTTCollectionReusableView.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/10.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLJMQTTCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@end

NS_ASSUME_NONNULL_END
