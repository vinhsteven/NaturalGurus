//
//  BookLiveViewController.m
//  NaturalGurus
//
//  Created by Steven Pham on 7/17/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "BookLiveViewController.h"
#import "PaymentViewController.h"

@interface BookLiveViewController ()

@end

@implementation BookLiveViewController

+ (BookLiveViewController *) instance {
    static BookLiveViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithNibName:@"BookLiveViewController" bundle:nil];
    });
    
    return sharedInstance;
}

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
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    self.txtMessage.backgroundColor = [UIColor clearColor];
}

- (void) viewDidLayoutSubviews {
    if (myIndicatorView == nil) {
        myIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        myIndicatorView.center = CGPointMake(self.txtMessage.center.x, self.txtMessage.frame.origin.y+self.txtMessage.frame.size.height + 20);
        [self.view addSubview:myIndicatorView];
        myIndicatorView.hidden = YES;
        [myIndicatorView startAnimating];
    }
}

- (void) closeView {
    self.isOpening = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) showCloseButton {
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 0, 24, 24);
    [btnLeft setImage:[UIImage imageNamed:@"btnClose.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem = btnItem;
}

- (void) reloadInput {
    myIndicatorView.hidden = NO;
    self.isOpening = YES;
    
    countDown = 120;
    
    self.lbTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:18];
    self.lbTitle.numberOfLines = 2;
    self.lbTitle.text = [NSString stringWithFormat:@"%d SECONDS LEFT",countDown];
    
    self.txtMessage.text = @"Thank you for your requesting a live appointment. We have given the expert just under 2 minutes to confirm that he/she can attend the appointment.\n\nIf the expert confirms before the above timer expires, you will be prompted for payment and will immediately enter the meeting room for your session.\n\nIf they do not reply you can schedule an appointment for later or choose another expert.";
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownTimer) userInfo:nil repeats:YES];
}

- (void) countDownTimer {
    countDown--;
    
    self.lbTitle.text = [NSString stringWithFormat:@"%d SECONDS LEFT",countDown];
    
    if (countDown == 0) {
        [timer invalidate];
        timer = nil;
        
        myIndicatorView.hidden = YES;
        
        self.lbTitle.text = @"WE'RE SORRY, BUT THERE WAS NO REPLY FROM THE EXPERT.";
        
        self.txtMessage.text = @"You can always schedule an appointment for later or choose another expert.";
        
        [self showCloseButton];
    }
}

- (void) expertDecline {
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    myIndicatorView.hidden = YES;
    self.lbTitle.text = @"WE'RE SORRY, BUT THE EXPERT HAS INDICATED THEY ARE NOT AVAILABLE AT THE MOMENT.";
    self.lbTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:15];
    self.lbTitle.numberOfLines = 3;
    
    self.txtMessage.text = @"You can always schedule an appointment for later or choose another expert.";
    
    [self showCloseButton];
}

- (void) expertAccept {
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    PaymentViewController *controller = [[PaymentViewController alloc] initWithNibName:@"PaymentViewController" bundle:nil];
    controller.scheduleDict = self.scheduleDict;
    [self.navigationController pushViewController:controller animated:YES];
    
    [self showCloseButton];
}

- (void) handleAfterPaymentSuccess:(long)orderId {
    DetailAppointmentViewController *controller = [[DetailAppointmentViewController alloc] initWithNibName:@"DetailAppointmentViewController" bundle:nil];
    controller.isPushNotification = YES;
    controller.appointmentId = orderId;
    [self.navigationController pushViewController:controller animated:YES];
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 0, 24, 24);
    [btnLeft setImage:[UIImage imageNamed:@"btnClose.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    controller.navigationItem.leftBarButtonItem = btnItem;
}

@end
