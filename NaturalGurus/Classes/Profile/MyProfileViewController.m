//
//  MyProfileViewController.m
//  NaturalGurus
//
//  Created by Steven on 6/16/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "MyProfileViewController.h"

enum {
    kDetailProfileSection = 0,
    kPreferencesSection
};

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController
@synthesize mainTableView;
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
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 0, 22, 9);
    [btnLeft setImage:[UIImage imageNamed:@"reveal-icon.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(leftButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = btnItem;
    
    //allocate firstname, last name, email
    txtFirstName = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, screenSize.width-5, 41)];
    txtFirstName.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    txtFirstName.placeholder = @"First name";
    txtFirstName.borderStyle = UITextBorderStyleNone;
    txtFirstName.returnKeyType = UIReturnKeyNext;
    txtFirstName.delegate = self;
    txtFirstName.backgroundColor = [UIColor lightGrayColor];
    
    txtLastName = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, screenSize.width-5, 41)];
    txtLastName.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    txtLastName.placeholder = @"Last name";
    txtLastName.borderStyle = UITextBorderStyleNone;
    txtLastName.returnKeyType = UIReturnKeyNext;
    txtLastName.delegate = self;

    txtEmail = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, screenSize.width-5, 41)];
    txtEmail.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    txtEmail.placeholder = @"Email address";
    txtEmail.borderStyle = UITextBorderStyleNone;
    txtEmail.returnKeyType = UIReturnKeyNext;
    txtEmail.delegate = self;
    
    txtCountryCode = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 100, 41)];
    txtCountryCode.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    txtCountryCode.placeholder = @"Country code";
    txtCountryCode.borderStyle = UITextBorderStyleNone;
    txtCountryCode.returnKeyType = UIReturnKeyNext;
    txtCountryCode.delegate = self;
    
    txtPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(txtCountryCode.frame.size.width+5, 0, screenSize.width-txtCountryCode.frame.size.width-5, 41)];
    txtPhoneNumber.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    txtPhoneNumber.placeholder = @"Phone number";
    txtPhoneNumber.borderStyle = UITextBorderStyleNone;
    txtPhoneNumber.returnKeyType = UIReturnKeyDone;
    txtPhoneNumber.delegate = self;
    
    btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //allocate 2 switches
    switchPushNotification = [[UISwitch alloc] initWithFrame:CGRectMake(screenSize.width-80, 5, 51, 31)];
    switchPushNotification.on = YES;
    
    switchSMS = [[UISwitch alloc] initWithFrame:CGRectMake(screenSize.width-80, 5, 51, 31)];
    switchSMS.on = YES;
    
    //load expert image
    //get expert image
    UIImageView *se = self.imgExpertView;
    
    NSString *imgUrl = @"https://naturalgurus.com/uploads/users/2015_06_11_08_05_56_Keith%20at%20Homeopathy%20For%20Kidscr.jpeg";
    [self.imgExpertView setImageWithURL:[NSURL URLWithString:imgUrl]
                       placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  
                                  se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(EXPERT_IMAGE_WIDTH, EXPERT_IMAGE_HEIGHT) source:image];
                                  
                              }];
    //make image circle shape
    [imgExpertView.layer setCornerRadius:EXPERT_IMAGE_WIDTH/2];
    [imgExpertView.layer setMasksToBounds:YES];
    
    //allocate save button
    btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(0, 0, 195, 30);
    btnSave.center = CGPointMake(screenSize.width/2, 23);
    [btnSave setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
    [btnSave setBackgroundImage:[ToolClass imageFromColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(handleSaveProfile) forControlEvents:UIControlEventTouchUpInside];
    
    //handle single touch on view to dismiss keyboard if it has showed
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void) handleSaveProfile {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Update Profile" message:@"Your profile has updated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [dialog show];
}

- (void) handleSingleTap:(UITapGestureRecognizer*)recognizer {
    //hide keyboard if it has already showed
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtCountryCode resignFirstResponder];
    [txtPhoneNumber resignFirstResponder];
}

- (void) leftButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark UITableViewDelegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberRowsInSection = 0;
    switch (section) {
        case kDetailProfileSection:
            numberRowsInSection = 4;
            break;
        case kPreferencesSection:
            numberRowsInSection = 3;
            break;
        default:
            break;
    }
    return numberRowsInSection;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    switch (indexPath.section) {
        case kDetailProfileSection:
            if (indexPath.row == 0)
                [cell.contentView addSubview:txtFirstName];
            else if (indexPath.row == 1)
                [cell.contentView addSubview:txtLastName];
            else if (indexPath.row == 2)
                [cell.contentView addSubview:txtEmail];
            else if (indexPath.row == 3) {
                [cell.contentView addSubview:txtCountryCode];
                [cell.contentView addSubview:txtPhoneNumber];
            }
            break;
        case kPreferencesSection:
        {
            if (indexPath.row == 0) {
                UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, screenSize.width-5, 41)];
                lbTitle.backgroundColor = [UIColor clearColor];
                lbTitle.font = [UIFont fontWithName:DEFAULT_FONT size:13];
                lbTitle.text = @"Receive push notifications";
                [cell.contentView addSubview:lbTitle];
                
                [cell.contentView addSubview:switchPushNotification];
            }
            else if (indexPath.row == 1){
                UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, screenSize.width-5, 41)];
                lbTitle.backgroundColor = [UIColor clearColor];
                lbTitle.font = [UIFont fontWithName:DEFAULT_FONT size:13];
                lbTitle.text = @"Receive SMS messages";
                [cell.contentView addSubview:lbTitle];
                
                [cell.contentView addSubview:switchSMS];
            }
            else {
                [cell.contentView addSubview:btnSave];
            }
                
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerTitle = @"";
    switch (section) {
        case kDetailProfileSection:
        {
            headerTitle = @"Details";
            break;
        }
        case kPreferencesSection:
            headerTitle = @"Preferences";
            break;
        default:
            break;
    }
    return headerTitle;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == txtFirstName) {
        [txtLastName becomeFirstResponder];
    }
    else if (textField == txtLastName) {
        [txtEmail becomeFirstResponder];
    }
    else if (textField == txtEmail) {
        [txtCountryCode becomeFirstResponder];
    }
    else if (textField == txtCountryCode) {
        [txtPhoneNumber becomeFirstResponder];
    }
    else if (textField == txtPhoneNumber) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction) handleEditProfileImage:(id)sender {
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
