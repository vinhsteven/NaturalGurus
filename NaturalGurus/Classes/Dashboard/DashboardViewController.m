//
//  DashboardViewController.m
//  NaturalGurus
//
//  Created by Steven on 6/16/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "DashboardViewController.h"
#import "DetailAppointmentViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController
@synthesize mainTableView;

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

-(BOOL)prefersStatusBarHidden{
    return HIDE_STATUS_BAR;
}

- (void) leftButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    [self setupUI];
    
    //allocate upcoming appointments array
    mainArray = [NSMutableArray arrayWithCapacity:1];
    
    NSString *imgUrl[] = {
        @"https://naturalgurus.com/uploads/users/2015_06_11_08_05_56_Keith%20at%20Homeopathy%20For%20Kidscr.jpeg",
        @"http://tapchianhdep.com/wp-content/uploads/2015/04/hinh-anh-hoat-hinh-tom-and-jerry-dang-yeu-nhat-1.jpg",
        @"http://tapchianhdep.com/wp-content/uploads/2015/04/hinh-anh-hoat-hinh-tom-and-jerry-dang-yeu-nhat-1.jpg"
    };

    NSString *expertName[] = {
        @"Jackie Ward",
        @"John Smith",
        @"Maria C"
    };
    
    NSString *duration[] = {
        @"10:30 am : 11:00 am",
        @"10:30 am : 11:00 am",
        @"11:00 am : 11:30 am"
    };
    
    NSString *date[] = {
        @"05/06/2015",
        @"05/07/2015",
        @"09/01/2015"
    };
    
    NSString *timezone[] = {
        @"(GMT+10)",
        @"(GMT+10)",
        @"(GMT+12)"
    };
    
    NSString *status[] = {
        @"Confirmed",
        @"Cancelled",
        @"Pending"
    };
    
    NSString *serviceName[] = {
        @"Herbal remedies advice",
        @"Allergy advice",
        @"Herbal remedies advice"
    };
    
    for (int i=0;i < sizeof(expertName)/sizeof(expertName[0]);i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imgUrl[i],@"imageUrl",expertName[i],@"expertName",duration[i],@"duration",date[i],@"date",timezone[i],@"timezone", status[i],@"status",serviceName[i],@"serviceName",nil];
        [mainArray addObject:dict];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Dashboard";
}

- (void) setupUI {
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    self.mainTableView.rowHeight = 60;
    self.mainTableView.separatorColor = [UIColor clearColor];
    self.mainTableView.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 0, 20, 16);
    [btnLeft setImage:[UIImage imageNamed:@"reveal-icon.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(leftButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem = btnItem;
    
    UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpacer.width = -5;
    
    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpacer.width = 15;
    
    self.navigationItem.leftBarButtonItems = @[leftSpacer, btnItem, rightSpacer];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    //create background view cell
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, self.mainTableView.rowHeight-6)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    bgView.layer.borderWidth = 1.0;
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    
    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    
    UILabel *lbExpertName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 21)];
    lbExpertName.font = [UIFont fontWithName:MONTSERRAT_BOLD size:14];
    lbExpertName.textColor = GREEN_COLOR;
    lbExpertName.backgroundColor = [UIColor clearColor];
    lbExpertName.text = [dict objectForKey:@"expertName"];
    [bgView addSubview:lbExpertName];
    
    UILabel *lbStatus = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width-125, 5, 100, 21)];
    lbStatus.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:12];
    lbStatus.backgroundColor = [UIColor clearColor];
    lbStatus.text = [dict objectForKey:@"status"];
    lbStatus.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:lbStatus];
    
    if ([[dict objectForKey:@"status"] isEqualToString:@"Confirmed"]) {
        lbStatus.textColor = GREEN_COLOR;
    }
    else if ([[dict objectForKey:@"status"] isEqualToString:@"Pending"]) {
        lbStatus.textColor = [UIColor colorWithRed:(float)215/255 green:(float)186/255 blue:(float)53/255 alpha:1.0];
    }
    else {
        lbStatus.textColor = [UIColor colorWithRed:(float)215/255 green:(float)53/255 blue:(float)53/255 alpha:1.0];
    }
    
    //add time label
    NSString *dateTime = [NSString stringWithFormat:@"%@, %@ %@",[dict objectForKey:@"duration"],[dict objectForKey:@"date"],[dict objectForKey:@"timezone"]];
    UILabel *lbDateTime = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, screenSize.width, 21)];
    lbDateTime.backgroundColor = [UIColor clearColor];
    lbDateTime.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    lbDateTime.text = dateTime;
    lbDateTime.textColor = [UIColor blackColor];
    [bgView addSubview:lbDateTime];
    
    [cell.contentView addSubview:bgView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.title = @"";
    
    NSMutableDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    
    DetailAppointmentViewController *controller = [[DetailAppointmentViewController alloc] initWithNibName:@"DetailAppointmentViewController" bundle:nil];
    controller.appointmentDict = dict;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
