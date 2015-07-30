//
//  DashboardViewController.m
//  NaturalGurus
//
//  Created by Steven on 6/16/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "DashboardViewController.h"
#import "DetailAppointmentViewController.h"
#import "WriteReviewViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController
@synthesize mainTableView;
@synthesize currentPage,lastPage;
@synthesize isLoading;

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
    
    userRole = [[ToolClass instance] getUserRole];
    
    if (userRole == isUser)
        [self reloadAppointment];
    else {
        [self reloadExpertAppointments];
    }
    
    //test
//    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnRight.frame = CGRectMake(0, 0, 20, 16);
//    [btnRight setImage:[UIImage imageNamed:@"reveal-icon.png"] forState:UIControlStateNormal];
//    [btnRight addTarget:self action:@selector(listLiveRequest) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
//    
//    self.navigationItem.rightBarButtonItem = btnItem;
    //end test
}

//test
- (void) listLiveRequest {
    BOOL isOpening = [[LiveRequestListViewController instance] isOpening];
    if (!isOpening) {
        UINavigationController *tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:[LiveRequestListViewController instance]];
        [self.navigationController presentViewController:tmpNavigationController animated:YES completion:nil];
    }
    [[LiveRequestListViewController instance] reloadLiveRequest];
}
//end test

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Dashboard";
    
    //reload current selected row to check local data, use after updating schedule
    NSArray *array = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:currentSelectedIndex inSection:0], nil];
    [self.mainTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void) setupUI {
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    [self addNavigationBottomLine];
    
    self.mainTableView.rowHeight = 60;
    self.mainTableView.separatorColor = [UIColor clearColor];
    self.mainTableView.backgroundColor = TABLE_BACKGROUND_COLOR;
    [self.mainTableView.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    
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

- (void) addNavigationBottomLine {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenSize.width, 1)];
    view.backgroundColor = LIGHT_GREY_COLOR;
    [self.navigationController.navigationBar addSubview:view];
}

- (void) handleRefresh {
    NSLog(@"Refresh Table");
    [self.mainTableView.refreshControl endRefreshing];
    if (userRole == isUser)
        [self reloadAppointment];
    else
        [self reloadExpertAppointments];
    [self.mainTableView reloadData];
}

- (void) reloadAppointment {
    currentPage = 1;
    [mainArray removeAllObjects];
    [self loadAppointments];
}

- (void) loadAppointments {
    isLoading = YES;
    
    NSString *userToken = [[ToolClass instance] getUserToken];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userToken,@"token",[NSNumber numberWithInt:10],@"per_page",[NSNumber numberWithInt:currentPage],@"page", nil];
    
    [[ToolClass instance] loadUserAppointments:params withViewController:self];
}

- (void) reloadExpertAppointments {
    currentPage = 1;
    [mainArray removeAllObjects];
    [self loadExpertAppointments];
}

- (void) loadExpertAppointments {
    isLoading = YES;
    
    NSString *userToken = [[ToolClass instance] getUserToken];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userToken,@"token",[NSNumber numberWithInt:10],@"per_page",[NSNumber numberWithInt:currentPage],@"page", nil];
    
    [[ToolClass instance] loadExpertAppointments:params withViewController:self];
}

- (void) reorganizeAppointments:(NSArray*)array {
    unsigned long startIndex = [mainArray count];
    unsigned long endIndex   = startIndex + [array count];
    
    //sort array by date asc
    NSSortDescriptor *value = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    array = [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:value, nil]];
    
    for (int i=0;i < [array count];i++) {
        NSDictionary *dict = [array objectAtIndex:i];
        NSString *name = userRole == isUser ? [dict objectForKey:@"expert"] : [dict objectForKey:@"name"];
        NSString *date       = [dict objectForKey:@"date"];
        
        NSString *fromTime   = [dict objectForKey:@"from_time"];
        NSString *toTime     = [dict objectForKey:@"to_time"];
        NSString *timezone   = [dict objectForKey:@"client_timezone"];
        
        NSString *fromDateTime = [NSString stringWithFormat:@"%@ %@",date,fromTime];
        NSString *toDateTime = [NSString stringWithFormat:@"%@ %@",date,toTime];
        
        date = [ToolClass dateByTimezone:timezone andDate:fromDateTime];
        fromTime = [ToolClass timeByTimezone:timezone andDateAndTime:fromDateTime];
        toTime   = [ToolClass timeByTimezone:timezone andDateAndTime:toDateTime];
        
        NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:name,@"name",[dict objectForKey:@"duration"],@"duration",date,@"date",timezone,@"timezone",[dict objectForKey:@"state"],@"status",[dict objectForKey:@"id"],@"appointmentId",[dict objectForKey:@"expert_id"],@"expertId",fromTime,@"from_time",toTime,@"to_time",[dict objectForKey:@"total"],@"total",[dict objectForKey:@"video_session"],@"video_session",[dict objectForKey:@"video_password"],@"video_password",[dict objectForKey:@"about"],@"about",[dict objectForKey:@"avatar"],@"avatar",[dict objectForKey:@"client_avatar"],@"client_avatar",[dict objectForKey:@"video_state"],@"video_state",[dict objectForKey:@"email"],@"email",nil];
        [mainArray addObject:newDict];
    }
    
    //hide hud progress
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
    currentPage++;
    isLoading = NO;
    
    if ([mainArray count] == [array count]) {
        [self.mainTableView reloadData];
    }
    else {
        //show drop down animation effect
        NSMutableArray* indexPathsToInsert = [NSMutableArray arrayWithCapacity:1];
        
        for (unsigned long i=startIndex;i < endIndex;i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [self.mainTableView beginUpdates];
        [self.mainTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationTop];
        [self.mainTableView endUpdates];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!isLoading && currentPage <= lastPage) {
        if (self.mainTableView.contentOffset.y >= (self.mainTableView.contentSize.height - self.mainTableView.bounds.size.height))
        {
            if (userRole == isUser)
                [self loadAppointments];
            else
                [self loadExpertAppointments];
        }
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    //create background view cell
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, self.mainTableView.rowHeight-6)];
    bgView.tag = kBGVIEW_TAG;
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    bgView.layer.borderWidth = 1.0;
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    
    NSMutableDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    
    UILabel *lbExpertName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 190, 21)];
    lbExpertName.font = [UIFont fontWithName:MONTSERRAT_BOLD size:14];
    lbExpertName.textColor = GREEN_COLOR;
    lbExpertName.backgroundColor = [UIColor clearColor];
    lbExpertName.text = [dict objectForKey:@"name"];
    [bgView addSubview:lbExpertName];
    
    
    int status = [[dict objectForKey:@"status"] intValue];
    NSString *statusString;
    UIColor *statusColor;
    switch (status) {
        case isPending:
            statusString = @"Pending";
            statusColor = [UIColor colorWithRed:(float)215/255 green:(float)186/255 blue:(float)53/255 alpha:1.0];
            break;
        case isApproved:
            statusString = @"Approved";
            statusColor  = GREEN_COLOR;
            break;
        case isDeclined:
            statusString = @"Declined";
            statusColor  = RED_COLOR;
            break;
        case isExpired:
            statusString = @"Expired";
            statusColor  = RED_COLOR;
            break;
        default:
            break;
    }
    
    //check if this appointment is finished
    int video_state = [[dict objectForKey:@"video_state"] intValue];
    if (video_state == 1){
        statusString = @"Finished";
        statusColor  = ORANGE_COLOR;
    }
    
    UILabel *lbStatus = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width-125, 5, 100, 21)];
    lbStatus.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:12];
    lbStatus.backgroundColor = [UIColor clearColor];
    lbStatus.text = statusString;
    lbStatus.textColor = statusColor;
    lbStatus.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:lbStatus];
    
    
    //add time label
    NSString *fromTime  = [ToolClass convertHourToAM_PM:[dict objectForKey:@"from_time"]];
    NSString *toTime    = [ToolClass convertHourToAM_PM:[dict objectForKey:@"to_time"]];
    
    NSString *dateTime = [NSString stringWithFormat:@"%@, %@ %@",[NSString stringWithFormat:@"%@ : %@",fromTime,toTime],[dict objectForKey:@"date"],[NSString stringWithFormat:@"(%@)",[dict objectForKey:@"timezone"]]];
    UILabel *lbDateTime = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, screenSize.width, 21)];
    lbDateTime.backgroundColor = [UIColor clearColor];
    lbDateTime.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    lbDateTime.text = dateTime;
    lbDateTime.textColor = [UIColor blackColor];
    [bgView addSubview:lbDateTime];
    
    [cell.contentView addSubview:bgView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.title = @"";
    
    currentSelectedIndex = (int)indexPath.row;
    NSMutableDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    
    DetailAppointmentViewController *controller = [[DetailAppointmentViewController alloc] initWithNibName:@"DetailAppointmentViewController" bundle:nil];
    controller.appointmentId   = [[dict objectForKey:@"appointmentId"] longValue];
    controller.appointmentDict = dict;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *bgView = [cell.contentView viewWithTag:kBGVIEW_TAG];
    bgView.backgroundColor = LIGHT_GREY_COLOR;
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *bgView = [cell.contentView viewWithTag:kBGVIEW_TAG];
    bgView.backgroundColor = [UIColor whiteColor];
    return indexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
