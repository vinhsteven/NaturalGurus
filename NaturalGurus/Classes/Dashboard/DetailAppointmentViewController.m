//
//  DetailAppointmentViewController.m
//  NaturalGurus
//
//  Created by Steven on 6/16/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "DetailAppointmentViewController.h"

@interface DetailAppointmentViewController ()

@end

@implementation DetailAppointmentViewController
@synthesize appointmentDict;
@synthesize mainScrollView;
@synthesize btnEnter,btnCancel;
@synthesize lbStatus;
@synthesize detailContainerView;
@synthesize btnCollapseExpand;

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

-(BOOL)prefersStatusBarHidden{
    return HIDE_STATUS_BAR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    screenSize = [[UIScreen mainScreen] bounds].size;
    
//    btnEnter.center = CGPointMake(screenSize.width/2-10-btnEnter.frame.size.width/2, btnEnter.frame.origin.y);
//    btnCancel.center = CGPointMake(screenSize.width/2+10+btnCancel.frame.size.width/2, btnCancel.frame.origin.y);
    
    //get appointment data
    NSString *status = [appointmentDict objectForKey:@"status"];
    lbStatus.text = status;
    if ([status isEqualToString:@"Confirmed"])
        lbStatus.textColor = [UIColor greenColor];
    else
        lbStatus.textColor = [UIColor redColor];
    
    //set Service name label text
    self.lbServiceName.text = [appointmentDict objectForKey:@"serviceName"];
    
    //get expert image
    UIImageView *se = self.imgExpertView;
    
    NSString *imgUrl = [appointmentDict objectForKey:@"imageUrl"];
    [self.imgExpertView setImageWithURL:[NSURL URLWithString:imgUrl]
                       placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  
                                  se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(EXPERT_IN_LIST_WIDTH, EXPERT_IN_LIST_HEIGHT) source:image];
                                  
                              }];
    
}

- (void) viewWillAppear:(BOOL)animated {
    //check for iphone 4,4s
    if (screenSize.height == 480)
        [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height+200)];
    else
        [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height-44)];
}

- (IBAction) handleCollapseExpandView:(id)sender {
    if (!detailContainerView.hidden) {
        [btnCollapseExpand setBackgroundImage:[UIImage imageNamed:@"btnExpand.png"] forState:UIControlStateNormal];
        
        //restore
        [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height-44)];
    }
    else {
        [btnCollapseExpand setBackgroundImage:[UIImage imageNamed:@"btnCollapse.png"] forState:UIControlStateNormal];
        
        //check for iphone 4,4s
        if (screenSize.height == 480)
            [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height+200)];
        else
            [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height-44)];
    }
    detailContainerView.hidden = !detailContainerView.hidden;
}

- (IBAction) handleEnterRoom:(id)sender {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Enter Appointment" message:@"You are about to enter the meeting room." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",@"Cancel", nil];
    [dialog show];
}

- (IBAction) handleCancelAppointment:(id)sender {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Important" message:@"Cancellation will incur a 10% penalty fee." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",@"Cancel", nil];
    [dialog show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
