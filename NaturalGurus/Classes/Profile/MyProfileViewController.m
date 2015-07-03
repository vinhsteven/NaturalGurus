//
//  MyProfileViewController.m
//  NaturalGurus
//
//  Created by Steven on 6/16/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController
@synthesize imgExpertView;

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
    self.navigationItem.title = @"My Profile";
    
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    [self addNavigationBottomLine];
    
    //allocate left button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 0, 20, 16);
    [btnLeft setImage:[UIImage imageNamed:@"reveal-icon.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(leftButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem = btnItem;
    
    UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpacer.width = -5;
    
    self.navigationItem.leftBarButtonItems = @[leftSpacer, btnItem];
    
    
    //right bar button
    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpacer.width = 15;
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 19, 13);
    [btnRight setImage:[UIImage imageNamed:@"btnSave.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(handleSaveProfile) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = btnItem2;
    
    self.navigationItem.rightBarButtonItems = @[leftSpacer, btnItem2, rightSpacer];
    
    //disable all text view
    self.txtFirstName.enabled   = NO;
    self.txtLastName.enabled    = NO;
    self.txtEmail.enabled       = NO;
    self.txtCountryCode.enabled = NO;
    self.txtPhoneNumber.enabled = NO;
    
    //style for container view
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius   = 5;
    self.containerView.layer.masksToBounds  = YES;
    self.containerView.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    self.containerView.layer.borderWidth = 1;
    
    //load expert image
    //get expert image
    UIImageView *se = self.imgExpertView;
    
    NSString *imgUrl = [[ToolClass instance] getProfileImageURL];
    [self.imgExpertView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                       placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *url) {
                                  
                                  se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(EXPERT_IMAGE_WIDTH, EXPERT_IMAGE_HEIGHT) source:image];
                                  
                              }];
    //make image circle shape
    [imgExpertView.layer setCornerRadius:EXPERT_IMAGE_WIDTH/2];
    [imgExpertView.layer setMasksToBounds:YES];
    
    //handle single touch on view to dismiss keyboard if it has showed
    self.imgExpertView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    //handle tap profile picture
    UITapGestureRecognizer *profileImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEditProfileImage)];
    [self.imgExpertView addGestureRecognizer:profileImageTap];
}

- (void) viewDidLayoutSubviews {
    originalPoint = self.view.center;
}

- (void) viewWillAppear:(BOOL)animated {
    self.txtFirstName.text  = [[ToolClass instance] getUserFirstName];
    self.txtLastName.text   = [[ToolClass instance] getUserLastName];
    self.txtEmail.text      = [[ToolClass instance] getUserEmail];
}

- (void) addNavigationBottomLine {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenSize.width, 1)];
    view.backgroundColor = LIGHT_GREY_COLOR;
    [self.navigationController.navigationBar addSubview:view];
}

- (void) handleSaveProfile {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Update Profile" message:@"Your profile has updated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [dialog show];
}

- (void) handleSingleTap:(UITapGestureRecognizer*)recognizer {
    //hide keyboard if it has already showed
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtCountryCode resignFirstResponder];
    [self.txtPhoneNumber resignFirstResponder];
    
    if (screenSize.height == 480)
        self.view.center = CGPointMake(screenSize.width/2, screenSize.height/2);
}

- (void) leftButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtFirstName) {
        [self.txtLastName becomeFirstResponder];
    }
    else if (textField == self.txtLastName) {
//        [self.txtEmail becomeFirstResponder];
        [textField resignFirstResponder];
        
        if (screenSize.height == 480)
            self.view.center = CGPointMake(screenSize.width/2, screenSize.height/2);
    }
//    else if (textField == self.txtEmail) {
//        [self.txtCountryCode becomeFirstResponder];
//    }
//    else if (textField == self.txtCountryCode) {
//        [self.txtPhoneNumber becomeFirstResponder];
//    }
//    else if (textField == self.txtPhoneNumber) {
//        [textField resignFirstResponder];
//
//        if (screenSize.height == 480)
//            self.view.center = CGPointMake(screenSize.width/2, screenSize.height/2);
//    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (screenSize.height == 480)
        self.view.center = CGPointMake(screenSize.width/2, screenSize.height/2-120);
}

- (IBAction) handleEditProfile:(id)sender {
    self.txtFirstName.enabled   = YES;
    self.txtLastName.enabled    = YES;
//    self.txtEmail.enabled       = YES;
    self.txtCountryCode.enabled = YES;
    self.txtPhoneNumber.enabled = YES;
    
    [self.txtFirstName becomeFirstResponder];
}

- (void) handleEditProfileImage {
    if (self.txtFirstName.enabled) {
        NSString *other1 = @"Take Photo";
        NSString *other2 = @"Choose Existing";
        
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:other1, other2, nil];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
//    if  (buttonIndex == 0) {
//        NSLog(@"AA");
//    }
//    else if(buttonIndex == 1)
    if(buttonIndex == 0)
    {
        NSLog(@"Take a Photo");
        
        if([UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"Choose from Library");
        if([UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    UIImage *croppedImage = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(EXPERT_IMAGE_WIDTH, EXPERT_IMAGE_HEIGHT) source:image];
    
    imgExpertView.image = croppedImage;
    
    [imgExpertView.layer setCornerRadius:imgExpertView.frame.size.width/2];
    [imgExpertView.layer setMasksToBounds:YES];
    
    [self dismissModalViewControllerAnimated:YES];
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
