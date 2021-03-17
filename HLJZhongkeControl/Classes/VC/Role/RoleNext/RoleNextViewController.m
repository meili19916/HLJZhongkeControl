//
//  RoleNextViewController.m
//  zhongkePlatform
//
//  Created by Juan on 2020/12/8.
//

#import "RoleNextViewController.h"
#import "RoleTableViewCell.h"
#import "HLJHttp.h"
#import "UIView+Toast.h"
@interface RoleNextViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *reloadArray;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) NSString *selectName;

@end

@implementation RoleNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"角色切换";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancle:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sure:)];
    self.selectIndex = -1;
    [self.tableView registerNib:[UINib nibWithNibName:@"RoleTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tempArray = [NSMutableArray new];
    self.reloadArray = [NSMutableArray new];
    [self getData];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 70)];
    [self.view addSubview:self.scrollView];
    CGFloat startX = 0;
    for (NSInteger i = 0;i < self.selectArray.count;i ++) {
        UUIDModelMulitInfo *model = self.selectArray[i];
        UIFont *font;
        if (i == 2) {
            font =  [UIFont fontWithName:@"PingFangSC-Semibold" size: 15];
        }else{
            font = [UIFont systemFontOfSize:15];
        }
        CGFloat width = [self widthLineFeedWithFont:font textSizeHeight:100 text:model.name];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, self.scrollView.frame.size.height)];
        label.font = font;
        label.text = model.name;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(startX, 0, width + 15, self.scrollView.frame.size.height);
        [button addSubview:label];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        if (i == 2) {
            label.textColor = [UIColor yellowColor];
        }else{
            label.textColor = [UIColor blackColor];
            [button setImage:[UIImage imageNamed:@"icon_arrow_y"] forState:UIControlStateNormal];
        }
        [self.scrollView addSubview:button];
        startX += button.frame.size.width;
        self.scrollView.contentSize = CGSizeMake(button.frame.size.width + button.frame.origin.x , self.scrollView.frame.size.height);
        self.scrollView.contentOffset = CGPointMake(button.frame.size.width + button.frame.origin.x - self.view.frame.size.width, 0);
    }
//
    // Do any additional setup after loading the view from its nib.
}


- (void)getData{
    [[HLJHttp shared] getPartnerList:self.parentID success:^(NSDictionary * _Nonnull data) {
        NSArray *items = data[@"items"];
        for (NSInteger i = 0;i < items.count;i ++) {
            UUIDModelMulitInfo *model = items[i];
            model.level = 0;
            [self.dataArray addObject:model];
            [self.tempArray addObject:model];
            [self.reloadArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull error) {
        [self.view makeToast:error duration:2 position:CSToastPositionCenter];
    }];
}

- (void)cancle:sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure:sender{
    UUIDModelMulitInfo *model = self.tempArray[self.selectIndex];
    if (self.selectBlock) {
        self.selectBlock(model);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.tempArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    RoleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.leftView.hidden = YES;
    cell.bottomView.hidden = NO;
    UUIDModelMulitInfo *model = self.tempArray[indexPath.row];
//    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.logo.url]];
    if (model.name.length > 0) {
        cell.shortNameLabel.text = [model.name substringToIndex:1];
    }
    cell.arrowImage.highlighted = model.isExpand;
    cell.selectButton.selected = self.selectIndex == indexPath.row;
    cell.nameLabel.text = model.name;
    __weak typeof(self) weakSelf = self;
    cell.selectBlock = ^(id blockData) {
        weakSelf.selectIndex = indexPath.row;
        [weakSelf.tableView reloadData];
        self.selectName = model.name;

    };
    cell.bottomView.hidden = NO;
    if (model.level == 0) {
        cell.nameLabel.textColor = [UIColor colorWithRed:(float)44/255 green:(float)99/255 blue:(float)181/255 alpha:1];
        cell.leftView.hidden = YES;
        cell.leftConstraint.constant = 0;
        cell.bottomView.hidden = YES;
    }else{
        cell.nameLabel.textColor = [UIColor blackColor];
        cell.leftView.hidden = NO;
        cell.leftConstraint.constant = model.level *24;
    }
    cell.bottom1View.hidden = !model.isExpand;
    cell.bottm1Constratin.constant = 0;
    cell.bottomConstraint.constant = 0;
    if (model.level == 0) {
        cell.bottomConstraint.constant = 20;
    }else{
        if (self.tempArray.count == indexPath.row + 1) {
            cell.bottm1Constratin.constant = 30;
        }else{
            if (self.tempArray.count > indexPath.row + 1) {
                UUIDModelMulitInfo *models = self.tempArray[indexPath.row + 1];
                if (models.level != model.level) {
                    cell.bottm1Constratin.constant = 30;
                }
            }
        }
    }
    cell.left1View.hidden =model.level != 2;
    cell.arrowImage.hidden = model.items.count == 0;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UUIDModelMulitInfo *model = self.tempArray[indexPath.row];
    if (model.items.count <= 0) {
        return;
    }
    if (model.level >1) {
        NSMutableArray *nextArray = [NSMutableArray new];
 
        for (UUIDModelMulitInfo *tree in self.dataArray) {
            for (UUIDModelMulitInfo *nextTree in tree.items) {
                for (UUIDModelMulitInfo *next1Tree in nextTree.items) {
                    if ([next1Tree.id isEqualToString:model.id]) {
                        [nextArray addObject:tree];
                        [nextArray addObject:nextTree];
                        [nextArray addObject:next1Tree];
                        break;
                    }
                }
            }
        }
        RoleNextViewController *vc = [RoleNextViewController new];
        vc.parentID = model.id;
        vc.selectArray = nextArray;
        vc.selectBlock = ^(id blockData) {
            if (self.selectBlock) {
                self.selectBlock(blockData);
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else{
        model.isExpand = !model.isExpand;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.reloadArray removeAllObjects];
    
    if (model.isExpand) {
        if (model.items.count > 0) {
            for (NSInteger i = 0; i < model.items.count; i ++) {
                UUIDModelMulitInfo *treeModel = model.items[i];
                treeModel.level = model.level +1;
                [self.tempArray insertObject:treeModel atIndex:i +1 + indexPath.row];
                [self.reloadArray addObject:[NSIndexPath indexPathForRow:i + 1 + indexPath.row inSection:0]];
            }
            [tableView insertRowsAtIndexPaths:self.reloadArray withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self requestItems:model indexPath:indexPath];
        }
    }else{
        NSMutableArray *allArray = [NSMutableArray arrayWithArray:self.tempArray];
        for (NSInteger i = indexPath.row + 1; i < allArray.count; i ++) {
            UUIDModelMulitInfo *models = allArray[i];
            models.isExpand = NO;
            if (models.level==model.level) {
                break;
            }
            [self.tempArray removeObject:models];
            [self.reloadArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];//need reload nodes
        }
        [tableView deleteRowsAtIndexPaths:self.reloadArray withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)requestItems:(UUIDModelMulitInfo*)model indexPath:(NSIndexPath *)indexPath{
    [[HLJHttp shared] getPartnerList:model.id success:^(NSDictionary * _Nonnull data) {
        NSArray *items = data[@"items"];

        for (NSInteger i = 0; i < items.count; i ++) {
            UUIDModelMulitInfo *treeModel = [UUIDModelMulitInfo yy_modelWithJSON:items[i]];
            treeModel.level = model.level +1;
            [self.tempArray insertObject:treeModel atIndex:i +1 + indexPath.row];
            [self.reloadArray addObject:[NSIndexPath indexPathForRow:i + 1 + indexPath.row inSection:0]];
        }
        [self.tableView insertRowsAtIndexPaths:self.reloadArray withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSInteger code, NSString * _Nonnull error) {
//        self.view make
    }];
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
