//
//  HLJSettingStepTableViewCell.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/12.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLJSettingStepTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (void)updateLightCountOn:(NSInteger)onCount offCount:(NSInteger)offCont cardText:(NSString*)cardText;
@end

NS_ASSUME_NONNULL_END
