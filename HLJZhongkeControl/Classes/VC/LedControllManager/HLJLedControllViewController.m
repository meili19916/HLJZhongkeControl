//
//  HLJLedControllViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/1.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJLedControllViewController.h"

@interface HLJLedControllViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) BOOL isAllOpen;
@end

@implementation HLJLedControllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.isElectricControl ? @"电源控制" : @"灯光控制";
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? 64 : 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *imageName = self.isElectricControl ? @"icon_dy" : @"icon_dg";
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        if (!cell) {
            cell = [UITableViewCell new];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.imageView.image = [UIImage imageNamed:imageName];
        cell.textLabel.text = @"电源";
        
        UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        openButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 120, 0, 66, 32);
        openButton.layer.masksToBounds = YES;
        openButton.layer.cornerRadius = 16;
        [openButton setTitle:@"全开" forState:UIControlStateNormal];
        [openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        openButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [openButton setTitleColor:[UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1] forState:UIControlStateNormal];

        openButton.layer.borderColor =  [UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1].CGColor;
        openButton.layer.borderWidth = 1;
        [openButton setBackgroundColor:[UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1]];
        [openButton addTarget:self action:@selector(openButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:openButton];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 120 - 70, 0, 66, 32);
        closeButton.layer.masksToBounds = YES;
        closeButton.layer.cornerRadius = 16;
        [closeButton setTitle:@"全关" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [closeButton setTitleColor:[UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1] forState:UIControlStateNormal];        closeButton.layer.borderColor =  [UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1].CGColor;
        closeButton.layer.borderWidth = 1;
        [closeButton setBackgroundColor:[UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1]];
        [closeButton addTarget:self action:@selector(closeButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:closeButton];
        
        if (self.isAllOpen) {
            openButton.selected = YES;
            [openButton setBackgroundColor:[UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1]];
            closeButton.selected = NO;
            [closeButton setBackgroundColor:[UIColor whiteColor]];
        }else{
            closeButton.selected = YES;
            [closeButton setBackgroundColor:[UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1]];
            openButton.selected = NO;
            [openButton setBackgroundColor:[UIColor whiteColor]];
        }
        
        openButton.center = CGPointMake(openButton.center.x, 32);
        closeButton.center = CGPointMake(closeButton.center.x, 32);

        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [UITableViewCell new];
    }
    NSDictionary *data = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.text = data[@"name"];
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 54, 5, 44, 44)];
    switchButton.tag = indexPath.row;
    switchButton.onTintColor = [UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1];
    [switchButton addTarget:self action:@selector(swichChanged:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:switchButton];
    return cell;
}

- (void)swichChanged:(UISwitch*)sender{
    NSDictionary *data = self.dataArray[sender.tag];

}

- (void)openButtonclicked:(UIButton*)sender{
    if (!sender.selected) {
        self.isAllOpen = !self.isAllOpen;
        [self.tableView reloadData];
    }
}
- (void)closeButtonclicked:(UIButton*)sender{
    if (!sender.selected) {
        self.isAllOpen = !self.isAllOpen;
        [self.tableView reloadData];
    }
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
