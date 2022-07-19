//
//  HLJCardViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/3/1.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJCardViewController.h"
#import "HLJCardListViewController.h"
#import "HLJLedControllManager.h"
#import "UIView+Toast.h"
#import "HLJUserModel.h"
#import "HLJRelateListViewController.h"
@interface HLJCardViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *textString;
@property (nonatomic,strong) UILabel *placehoulderLabel;
@property (nonatomic,strong) HLJCardModel *currentModel;
@property (strong, nonatomic)  NSMutableArray *cardListArray;
@property (nonatomic,strong) NSMutableArray *cardHistoryArray;
@end

@implementation HLJCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"迎宾屏设置";
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    [leftbutton setTitle:@"历史记录" forState:UIControlStateNormal];
    leftbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightitem= [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.rightBarButtonItem=rightitem;
    if (self.dataArray.count > 0) {
        self.currentModel = self.dataArray.firstObject;
        [[HLJLedControllManager shared] TCPConnectToHost:self.currentModel.ip onPort:self.currentModel.port];
    }
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.cardListArray = [NSMutableArray new];
    NSArray *hisArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"CardHistoryArray"];
    if (hisArray) {
        self.cardHistoryArray = [NSMutableArray arrayWithArray:hisArray];
    }else{
        self.cardHistoryArray = [NSMutableArray new];
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)rightButtonClicked:sender{
    [self.navigationController pushViewController:[HLJCardListViewController new] animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if(indexPath.section == 2){
        return 90;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 3 ? self.cardListArray.count : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell" ];
        if (!cell) {
            cell = [[UITableViewCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.text = self.currentModel.name;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if(indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell" ];
        if (!cell) {
            cell = [[UITableViewCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        NSString *imageName = @"icon_ybpm";
        cell.imageView.image = [UIImage imageNamed:imageName];
        cell.textLabel.text = @"迎宾屏电源";
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 54, 10, 44, 44)];
        switchButton.tag = indexPath.row;
        [switchButton addTarget:self action:@selector(swichChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchButton];
        return cell;
    }else if(indexPath.section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] init];
        }
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 50 - 20, 90)];
        textView.delegate = self;
        textView.text = self.textString;
        textView.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:textView];
        
        if (self.textString.length == 0) {
            if (!self.placehoulderLabel) {
                self.placehoulderLabel = [[UILabel alloc] initWithFrame:CGRectMake(textView.frame.origin.x + 3, textView.frame.origin.y + 7, 100, 20)];
                self.placehoulderLabel.text = @"请输入迎宾词";
                self.placehoulderLabel.textColor = [UIColor darkGrayColor];
                self.placehoulderLabel.font = [UIFont systemFontOfSize:14];
            }
            [cell.contentView addSubview:self.placehoulderLabel];
        }
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell" ];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.text = self.cardListArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        HLJRelateListViewController *vc = [HLJRelateListViewController new];
        vc.dataArray = self.dataArray;
        vc.isCard = YES;
        vc.currentName = self.currentModel.name;
        __weak typeof(self) weakSelf = self;
        vc.selectDeviceBlock = ^(id blockData) {
            weakSelf.currentModel = blockData;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 3) {
        self.textString = self.cardListArray[indexPath.row];
        [self sendText];
    }
}
- (IBAction)saveCard:(id)sender {
    [self sendText];
}

- (void)sendText{
    [[HLJLedControllManager shared] sendLed:self.textString];
    NSDate *date = [NSDate date];NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time_now = [formatter stringFromDate:date];
    NSDictionary *sendListDic = @{@"name":self.textString,@"time":time_now};
    NSArray *localArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"CardHistoryArray"];
    if (!localArray) {
        localArray = [NSArray new];
    }
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:localArray];
    [mutableArray insertObject:sendListDic atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"CardHistoryArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.cardHistoryArray insertObject:sendListDic atIndex:0];
}

- (void)textViewDidChange:(UITextView *)textView{
    self.placehoulderLabel.hidden = textView.text.length > 0;
    if (textView.text.length > 0) {
        [self.cardListArray removeAllObjects];
        for (NSDictionary *dic in self.cardHistoryArray) {
            NSString *name = dic[@"name"] ;
            if ([name containsString:textView.text] && ![self.cardListArray containsObject:name]) {
                [self.cardListArray addObject:name];
            }
        }
        if (self.cardListArray.count > 0) {
            NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:3];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.textString = textView.text;
    [self.tableView reloadData];
}

- (void)swichChanged:(UISwitch*)sender{
    if (sender.on) {
        [[HLJLedControllManager shared] openLed];
    }else{
        [[HLJLedControllManager shared] closeLed];
    }
}

- (void)openButtonclicked:(UIButton*)sender{
    
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
