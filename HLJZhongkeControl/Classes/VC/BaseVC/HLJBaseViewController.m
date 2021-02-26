//
//  HLJBaseViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/22.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJBaseViewController.h"

@interface HLJBaseViewController ()

@end

@implementation HLJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (CGFloat)sizeLineFeedWithFont:(CGFloat)fontSize textSizeWidht:(CGFloat)widht text:(NSString*)text{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, widht, 0)];
    textView.text = text;
    textView.font = [UIFont systemFontOfSize:fontSize];
    CGSize size = CGSizeMake(widht, MAXFLOAT);
    CGSize constraint = [textView sizeThatFits:size];
    return constraint.height;
}

- (CGFloat)heightLineFeedWithFont:(UIFont*)font textSizeWidht:(CGFloat)widht text:(NSString*)text{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, widht, 0)];
    textView.text = text;
    textView.font = font;
    CGSize size = CGSizeMake(widht, MAXFLOAT);
    CGSize constraint = [textView sizeThatFits:size];
    return constraint.height;
}
- (CGFloat)widthLineFeedWithFont:(UIFont*)font textSizeHeight:(CGFloat)height text:(NSString*)text{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
    textView.text = text;
    textView.font = font;
    CGSize size = CGSizeMake(MAXFLOAT, height);
    CGSize constraint = [textView sizeThatFits:size];
    return constraint.width;
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
