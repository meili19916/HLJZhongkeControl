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
@interface HLJCardViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *textString;
@property (nonatomic,strong) UILabel *placehoulderLabel;

@end

@implementation HLJCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"迎宾屏设置";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"firstCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"save"];
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    [leftbutton setTitle:@"历史记录" forState:UIControlStateNormal];
    leftbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightitem= [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.rightBarButtonItem=rightitem;
    // Do any additional setup after loading the view from its nib.
}

- (void)rightButtonClicked:sender{
    [self.navigationController pushViewController:[HLJCardListViewController new] animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 64;
    }else if(indexPath.section == 1){
        return 120;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *imageName = @"icon_ybpm";
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell" forIndexPath:indexPath];
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.imageView.image = [UIImage imageNamed:imageName];
        cell.textLabel.text = @"迎宾屏电源";
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 54, 10, 44, 44)];
        switchButton.tag = indexPath.row;
        [switchButton addTarget:self action:@selector(swichChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchButton];
        

        return cell;
    }else if(indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.imageView.image = [UIImage imageNamed:imageName];
        cell.textLabel.text = @"电源名称";
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 50 - 20, 120)];
        textView.delegate = self;
        textView.text = self.textString;
        textView.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:textView];
        
        if (self.textString.length == 0) {
            if (!self.placehoulderLabel) {
                self.placehoulderLabel = [[UILabel alloc] initWithFrame:CGRectMake(textView.frame.origin.x + 3, textView.frame.origin.y + 7, 100, 20)];
                self.placehoulderLabel.text = @"请输入迎宾词";
                self.placehoulderLabel.font = [UIFont systemFontOfSize:14];
            }
            [cell.contentView addSubview:self.placehoulderLabel];
        }
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"save" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =  [UIColor colorWithRed:(float)35/255 green:(float)111/255 blue:(float)226/255 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    label.textColor = [UIColor whiteColor];
    label.text = @"保存";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:15];
    [cell.contentView addSubview:label];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        [[HLJLedControllManager shared] sendLed:self.textString];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    self.placehoulderLabel.hidden = textView.text.length > 0;
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
