//
//  HLJSettingStepTableViewCell.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/12.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJSettingStepTableViewCell.h"
#import "HLJNotifyCollectionViewCell.h"
@interface HLJSettingStepTableViewCell()
@property (nonatomic,assign) NSInteger onCount;
@property (nonatomic,assign) NSInteger offCount;
@end
@implementation HLJSettingStepTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HLJNotifyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HLJNotifyCollectionViewCell"];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.collectionView reloadData];
    // Initialization code
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width- 30)/2 , 120);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HLJNotifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLJNotifyCollectionViewCell" forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 8.0;
    cell.lab1Label.hidden = NO;
    cell.lab2Label.hidden = NO;
    cell.lab3Label.hidden = NO;
    cell.lab4Label.hidden = NO;
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"灯光设置";
        cell.lab1Label.text = @"点亮";
        cell.lab2Label.text = [NSString stringWithFormat:@"%d",self.onCount];
        cell.lab3Label.text = @"熄灭";
        cell.lab4Label.text = [NSString stringWithFormat:@"%d",self.offCount];
        cell.contentImageView.image = [UIImage imageNamed:@"icon_dgsz"];
    }else if (indexPath.row == 1) {
        cell.titleLabel.text = @"电源控制";
        cell.lab1Label.text = @"关闭";
        cell.lab2Label.text = @"0";
        cell.lab3Label.text = @"打开";
        cell.lab4Label.text = @"0";
        cell.contentImageView.image = [UIImage imageNamed:@"icon_dykz"];

    }else if (indexPath.row == 2) {
        cell.titleLabel.text = @"字符卡设置";
        cell.lab1Label.text = @"关闭";
        cell.lab2Label.hidden = YES;
        cell.lab3Label.hidden = YES;
        cell.lab4Label.hidden = YES;
        cell.contentImageView.image = [UIImage imageNamed:@"icon_zfksz"];

    }else if (indexPath.row == 3) {
        cell.titleLabel.text = @"区域信息";
        cell.lab1Label.text = @"当前位置";
        cell.lab2Label.text = @"成都";
        cell.lab3Label.hidden = YES;
        cell.lab4Label.hidden = YES;
        cell.contentImageView.image = [UIImage imageNamed:@"icon_zfksz"];
    }
    return cell;
}


- (void)updateLightCountOn:(NSInteger)onCount offCount:(NSInteger)offCont{
    self.onCount = onCount;
    self.offCount = self.offCount;
    [self.collectionView reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
