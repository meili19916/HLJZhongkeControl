//
//  RoleTableViewCell.h
//  zhongkePlatform
//
//  Created by Juan on 2020/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^RoleTableViewCellBlock)(id blockData);

@interface RoleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIView *bottom1View;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (nonatomic,assign) NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottm1Constratin;
@property (weak, nonatomic) IBOutlet UIView *left1View;
@property (nonatomic,copy) RoleTableViewCellBlock selectBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *shortNameLabel;

@end

NS_ASSUME_NONNULL_END
