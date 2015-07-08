//
//  ConfirmedViewController.m
//  NaturalGurus
//
//  Created by Steven Pham on 7/8/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "ConfirmedViewController.h"

@interface ConfirmedViewController ()

@end

@implementation ConfirmedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    screenSize = [UIScreen mainScreen].bounds.size;
    
    self.navigationItem.title = @"Confirmed";
    
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 0, 20, 16);
    [btnLeft setImage:[UIImage imageNamed:@"reveal-icon.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(leftButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem = btnItem;
    
    self.lbReferFAQ.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
    self.lbReferFAQ.delegate = self; // Delegate methods are called when the user taps on a link (see `TTTAttributedLabelDelegate` protocol)
    
    self.lbReferFAQ.text = @"If you have any questions, please refer our FAQ's"; // Repository URL will be automatically detected and linked
    
    NSRange range = [self.lbReferFAQ.text rangeOfString:@"FAQ's"];
    [self.lbReferFAQ addLinkToURL:[NSURL URLWithString:@"https://naturalgurus.com/f-a-q"] withRange:range];
}

- (void) viewDidLayoutSubviews {
    if (screenSize.height == 480) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+50)];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (void) leftButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
