//
//  HLJBaseViewController.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/22.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^HLJCommonBlock)(id blockData);

@interface HLJBaseViewController : UIViewController

- (CGFloat)sizeLineFeedWithFont:(CGFloat)fontSize textSizeWidht:(CGFloat)widht text:(NSString*)text;
- (CGFloat)heightLineFeedWithFont:(UIFont*)font textSizeWidht:(CGFloat)widht text:(NSString*)text;
- (CGFloat)widthLineFeedWithFont:(UIFont*)font textSizeHeight:(CGFloat)height text:(NSString*)text;
@end

NS_ASSUME_NONNULL_END
