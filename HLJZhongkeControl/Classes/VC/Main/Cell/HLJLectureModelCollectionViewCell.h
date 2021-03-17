//
//  HLJLectureModelCollectionViewCell.h
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/11.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^HLJLectureModelCollectionViewCellBlock)(id blockData);

NS_ASSUME_NONNULL_BEGIN

@interface HLJLectureModelCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (copy, nonatomic)  HLJLectureModelCollectionViewCellBlock leftBtttonBlock;
@property (copy, nonatomic)  HLJLectureModelCollectionViewCellBlock rightBtttonBlock;

@end

NS_ASSUME_NONNULL_END
