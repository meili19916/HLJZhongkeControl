//
//  RoleViewController.m
//  zhongkePlatform
//
//  Created by Juan on 2020/12/7.
//

#import "RoleViewController.h"
#import "RoleTableViewCell.h"
#import "RoleNextViewController.h"
#import "HLJHttp.h"
#import "UIView+Toast.h"

@interface RoleViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *reloadArray;
@property (nonatomic, strong) NSMutableArray *searchArray;

@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) NSString *selectName;

@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation RoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"角色切换";
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sure:)];
    self.dataArray = [NSMutableArray new];
    self.selectIndex = -1;
    [self.tableView registerNib:[UINib nibWithNibName:@"RoleTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tempArray = [NSMutableArray new];
    self.reloadArray = [NSMutableArray new];
    [self requestData];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];

    UISearchBar *searchBar = self.searchController.searchBar;
    searchBar.placeholder = @"搜索角色";
    searchBar.backgroundColor = [UIColor colorWithRed:(float)131/255 green:(float)131/255 blue:(float)131/255 alpha:1];
    searchBar.layer.cornerRadius = 20;
    searchBar.backgroundImage = [UIImage new];
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor clearColor];
    [headerView addSubview:searchBar];
//    self.tableView.tableHeaderView = headerView;
    // Do any additional setup after loading the view from its nib.
}
- (void)requestData{
            for (NSInteger i = 0;i < self.model.mulit_info.count;i ++) {
                UUIDModelMulitInfo *model =self.model.mulit_info[i];
                model.level = 0;
                [self.dataArray addObject:model];
                [self.tempArray addObject:model];
                [self.reloadArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [self.tableView reloadData];
}
- (void)cancle:sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
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
    if (tableView == self.searchTableView) {
        return self.searchArray.count;
    }
    return self.tempArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
            }
        UUIDModelMulitInfo *model = self.searchArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }
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
        weakSelf.selectName = model.name;
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
    cell.arrowImage.hidden = !model.has_children;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchTableView) {
        UUIDModelMulitInfo *model = self.searchArray[indexPath.row];
        self.selectName = model.name;
        self.selectIndex = indexPath.row;
        if (self.selectBlock) {
            self.selectBlock(model);
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
    }
    UUIDModelMulitInfo *model = self.tempArray[indexPath.row];
    if (!model.has_children) {
        self.selectIndex = indexPath.row;
        [self.tableView reloadData];
        self.selectName = model.name;
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

#pragma mark ---- UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (!searchController.active) {
        return;
    }
//    self.filterString = searchController.searchBar.text;
    self.searchTableView.hidden = NO;
    if (!self.searchArray) {
        self.searchArray = [NSMutableArray new];
    }
    [self.searchArray removeAllObjects];
    NSString *inputStr = searchController.searchBar.text;
    [self updateSearchData:self.dataArray text:inputStr];
    [self.searchTableView reloadData];
}

- (void)updateSearchData:(NSArray*)array text:(NSString*)text{
   
//    for (NSInteger i = 0; i < array.count; i ++) {
//        CompanyTreeModel *model = array[i];
//        if ([model.name containsString:text]) {
//            [self.searchArray addObject:model];
//        }
//        [self updateSearchData:model.items text:text];
//    }
}
- (void)willDismissSearchController:(UISearchController *)searchController
{
    // 点击cancel的时候 数组还原 刷新表
//    self.visibleResults = self.allResults;
    self.searchTableView.hidden = YES;
}

-(void)didDismissSearchController:(UISearchController *)searchController
{
    self.searchTableView.hidden = YES;
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
