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
    
    self.navigationItem.title = @"Dashboard";
    
    self.mainTableView.rowHeight = 60;
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 0, 22, 9);
    [btnLeft setImage:[UIImage imageNamed:@"reveal-icon.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(leftButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = btnItem;
    
    //allocate upcoming appointments array
    mainArray = [NSMutableArray arrayWithCapacity:1];
    
    NSString *imgUrl[] = {
        @"https://naturalgurus.com/uploads/users/2015_06_11_08_05_56_Keith%20at%20Homeopathy%20For%20Kidscr.jpeg",
        @"http://tapchianhdep.com/wp-content/uploads/2015/04/hinh-anh-hoat-hinh-tom-and-jerry-dang-yeu-nhat-1.jpg"
    };

    NSString *expertName[] = {
        @"Jackie Ward",
        @"John Smith"
    };
    
    NSString *duration[] = {
        @"10:30 am : 11:00 am",
        @"10:30 am : 11:00 am"
    };
    
    NSString *date[] = {
        @"05/06/2015",
        @"05/07/2015"
    };
    
    NSString *timezone[] = {
        @"(GMT+10)",
        @"(GMT+10)"
    };
    
    NSString *status[] = {
        @"Confirmed",
        @"Pending"
    };
    
    NSString *serviceName[] = {
        @"Herbal remedies advice",
        @"Allergy advice"
    };
    
    for (int i=0;i < sizeof(expertName)/sizeof(expertName[0]);i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imgUrl[i],@"imageUrl",expertName[i],@"expertName",duration[i],@"duration",date[i],@"date",timezone[i],@"timezone", status[i],@"status",serviceName[i],@"serviceName",nil];
        [mainArray addObject:dict];
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    
    UILabel *lbExpertName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 21)];
    lbExpertName.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    lbExpertName.backgroundColor = [UIColor clearColor];
    lbExpertName.text = [dict objectForKey:@"expertName"];
    [cell.contentView addSubview:lbExpertName];
    
    UILabel *lbStatus = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width-105, 5, 100, 21)];
    lbStatus.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    lbStatus.backgroundColor = [UIColor clearColor];
    lbStatus.text = [dict objectForKey:@"status"];
    lbStatus.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:lbStatus];
    
    if ([[dict objectForKey:@"status"] isEqualToString:@"Confirmed"]) {
        lbStatus.textColor = [UIColor greenColor];
    }
    else {
        lbStatus.textColor = [UIColor redColor];
    }
    
    //add time label
    NSString *dateTime = [NSString stringWithFormat:@"%@, %@ %@",[dict objectForKey:@"duration"],[dict objectForKey:@"date"],[dict objectForKey:@"timezone"]];
    UILabel *lbDateTime = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, screenSize.width, 21)];
    lbDateTime.backgroundColor = [UIColor clearColor];
    lbDateTime.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    lbDateTime.text = dateTime;
    lbDateTime.textColor = [UIColor blueColor];
    [cell.contentView addSubview:lbDateTime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
