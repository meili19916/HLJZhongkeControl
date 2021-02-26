//
//  HLJMainViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/24.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJMainViewController.h"
#import "Cell/HLJNotifyCollectionViewCell.h"
@interface HLJMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation HLJMainViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNavigationBarView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HLJNotifyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HLJNotifyCollectionViewCell"];
    self.flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width- 30)/2 , 120);
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    // Do any additional setup after loading the view from its nib.
}

- (void)addNavigationBarView{
    
    if (!self.locationButton) {
        self.locationButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,30)];
        [self.locationButton setImage:[UIImage imageNamed:@"icon_dw_tm"] forState:UIControlStateNormal];
        [self.locationButton setTitle:@"" forState:UIControlStateNormal];
        self.locationButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.locationButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.locationButton addTarget:self action:@selector(navigationRight2ButtonClick:)forControlEvents:UIControlEventTouchUpInside];
    }
    [self.locationButton setTitle:@"展厅名称" forState:UIControlStateNormal];
   CGFloat width = [self widthLineFeedWithFont:self.locationButton.titleLabel.font textSizeHeight:30 text:self.locationButton.currentTitle];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width >= 80 ? 100 : width + 20 , 30)];
    
    [view addSubview:self.locationButton];
    self.locationButton.frame = CGRectMake(self.locationButton.frame.origin.x, self.locationButton.frame.origin.y, view.frame.size.width, self.locationButton.frame.size.height);
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.tabBarController.navigationItem.leftBarButtonItem = item2;
    self.tabBarController.title = @"";
}

#pragma collectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
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
        cell.lab2Label.text = @"0";
        cell.lab3Label.text = @"熄灭";
        cell.lab4Label.text = @"0";
    }else if (indexPath.row == 1) {
        cell.titleLabel.text = @"电源控制";
        cell.lab1Label.text = @"关闭";
        cell.lab2Label.text = @"0";
        cell.lab3Label.text = @"打开";
        cell.lab4Label.text = @"0";
    }else if (indexPath.row == 2) {
        cell.titleLabel.text = @"字符卡设置";
        cell.lab1Label.text = @"关闭";
        cell.lab2Label.hidden = YES;
        cell.lab3Label.hidden = YES;
        cell.lab4Label.hidden = YES;
    }else if (indexPath.row == 3) {
        cell.titleLabel.text = @"区域信息";
        cell.lab1Label.text = @"当前位置";
        cell.lab2Label.text = @"成都";
        cell.lab3Label.hidden = YES;
        cell.lab4Label.hidden = YES;
    }
    return cell;
}


- (void)navigationRight2ButtonClick:sender{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
