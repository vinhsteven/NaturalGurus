//
//  AvailabilityViewController.m
//  NaturalGurus
//
//  Created by Steven Pham on 6/22/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "AvailabilityViewController.h"
#import "ScheduleAppointmentViewController.h"

@interface AvailabilityButton : UIButton

@property (strong,nonatomic) NSDictionary *dataDict;

@end

@implementation AvailabilityButton


@end

@interface AvailabilityViewController ()

@end

@implementation AvailabilityViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    mainArray = [NSMutableArray arrayWithCapacity:1];
    
    self.lbInstructionTitle.backgroundColor = [UIColor whiteColor];
    
    //create temporary data for next 3 days
    self.mainTableView.separatorColor = [UIColor clearColor];
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    [self.mainTableView setExclusiveSections:!self.mainTableView.exclusiveSections];
    
    self.data = [NSMutableArray arrayWithCapacity:1];
    self.headers = [NSMutableArray arrayWithCapacity:1];
    
    [self reloadAvailabilities];
    
//    [self setupTableViewData];
//    [self.mainTableView reloadData];
//
//    for (int i=0;i < [self.headers count];i++) {
//        [self.mainTableView openSection:i animated:YES];
//    }
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Availability";
}

- (void) viewDidLayoutSubviews {
//    //example
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.lbInstructionTitle.frame.size.width, self.lbInstructionTitle.frame.size.height) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(self.lbInstructionTitle.frame.size.height/2, self.lbInstructionTitle.frame.size.height/2)];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.path  = maskPath.CGPath;
//    self.lbInstructionTitle.layer.mask = maskLayer;
//    //
}

- (void) reloadAvailabilities {
    [self.headers removeAllObjects];
    [self.data removeAllObjects];
    isFirstLoading = YES;
    
    //get today
    fromDate = [NSDate date];
    
    //init date
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 2;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    
    toDate    = [theCalendar dateByAddingComponents:dayComponent toDate:fromDate options:0];
    
    NSString *fromDateStr   = [ToolClass dateByFormat:@"yyyy-MM-dd" date:fromDate];
    NSString *toDateStr     = [ToolClass dateByFormat:@"yyyy-MM-dd" date:toDate];
    
    [self loadAvailabilitiesByFromDate:fromDateStr toDate:toDateStr];
}

- (void) loadAvailabilitiesByFromDate:(NSString*)_fromDate toDate:(NSString*)_toDate {
    isLoading = YES;
    
    long expertId = [[ToolClass instance] getExpertId];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.timezoneValueString,@"timezone",[NSNumber numberWithBool:self.isFree],@"free",[NSNumber numberWithInt:self.duration],@"duration",_fromDate,@"from_date",_toDate,@"to_date", nil];
    [[ToolClass instance] loadAvailabilitiesByExpertId:expertId params:params withViewController:self];
}

- (void) reorganizeAvailabilities:(NSDictionary*)dataDict {
    unsigned long startIndex = [self.headers count];
    
    //get all dates for response data
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
    
    for (int i=0;i < [[dataDict allKeys] count];i++) {
        NSString *dateStr = [[dataDict allKeys] objectAtIndex:i];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dateStr,@"date", nil];
        [sectionArray addObject:dict];
    }
    
    //arrage the date by from date - to date
    NSSortDescriptor *value = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [sectionArray sortUsingDescriptors:[NSArray arrayWithObjects:value, nil]];
    
    for (int i=0;i < [sectionArray count];i++) {
        UIView* header = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenSize.width, 40)];
        [header setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lbSectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenSize.width/2-20, 30)];
        
        lbSectionTitle.backgroundColor = [UIColor colorWithRed:(float)245/255 green:(float)245/255 blue:(float)245/255 alpha:1.0];
        lbSectionTitle.textColor = [UIColor blackColor];
        lbSectionTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        lbSectionTitle.text = [[sectionArray objectAtIndex:i] objectForKey:@"date"];
        lbSectionTitle.textAlignment = NSTextAlignmentCenter;
        [header addSubview:lbSectionTitle];
        
        
        //create round edge for left and right side
        lbSectionTitle.layer.cornerRadius  = lbSectionTitle.frame.size.height/2;
        lbSectionTitle.layer.masksToBounds = YES;
        
        [self.headers addObject:header];
        
        //set position for title label
        lbSectionTitle.center = CGPointMake(screenSize.width/2, lbSectionTitle.center.y);
        
        //set border color for title label in header section. Here is Mon, Jun 25
        lbSectionTitle.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
        lbSectionTitle.layer.borderWidth = 1;
    }
    
    //loop all date and get time for it
    for (int i=0;i < [sectionArray count];i++) {
        NSString *dateStr = [[sectionArray objectAtIndex:i] objectForKey:@"date"];
        //get all time array from this date
        NSArray *timeArray = [dataDict objectForKey:dateStr];
        NSMutableArray* section = [NSMutableArray arrayWithCapacity:1];
        
        if ([timeArray count] > 0) {
            for (int j=0;j < [timeArray count];j++) {
                NSDictionary *timeDict = [timeArray objectAtIndex:j];
                
                NSString *title = [NSString stringWithFormat:@"%@ - %@",[timeDict objectForKey:@"from_time2"],[timeDict objectForKey:@"to_time2"]];
                NSDictionary *tmpDict = [NSDictionary dictionaryWithObjectsAndKeys:[timeDict objectForKey:@"id"],@"id",[timeDict objectForKey:@"from_time"],@"from_time",[timeDict objectForKey:@"to_time"],@"to_time",[timeDict objectForKey:@"timezone"],@"timezone",[timeDict objectForKey:@"free"],@"free",[timeDict objectForKey:@"date_from"],@"date_from",[timeDict objectForKey:@"date_to"],@"date_to",title,@"title", nil];
                [section addObject:tmpDict];
            }
        }
        [self.data addObject:section];
    }
    
//    [self.mainTableView reloadData];
    
//    for (int i=0;i < [self.headers count];i++) {
//        [self.mainTableView openSection:i animated:NO];
//    }
    
    unsigned long endIndex   = startIndex + [sectionArray count];
    
    if (isFirstLoading) {
        [self.mainTableView reloadData];
    }
    else {
        //show drop down animation effect
        NSMutableIndexSet* indexSetsToInsert = [NSMutableIndexSet indexSet];
        
        for (unsigned long i=startIndex;i < endIndex;i++) {
            [indexSetsToInsert addIndexes:[NSIndexSet indexSetWithIndex:i]];
        }
        
        [self.mainTableView beginUpdates];
        [self.mainTableView insertSections:indexSetsToInsert withRowAnimation:UITableViewRowAnimationTop];
        
        [self.mainTableView endUpdates];
    }
    
    //open section review
    for (unsigned long i=startIndex;i < endIndex;i++) {
        [self.mainTableView openSection:i animated:YES];
    }
    
    isLoading = NO;
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!isLoading) {
        if (self.mainTableView.contentOffset.y > (self.mainTableView.contentSize.height - self.mainTableView.bounds.size.height))
        {
            
            isFirstLoading = NO;
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = 1;
            
            NSCalendar *theCalendar = [NSCalendar currentCalendar];
            
            NSDate *newFromDate    = [theCalendar dateByAddingComponents:dayComponent toDate:toDate options:0];
            
            //add 2 next days
            dayComponent.day = 2;
            
            NSDate *newToDate = [theCalendar dateByAddingComponents:dayComponent toDate:newFromDate options:0];
            
            //assign toDate
            toDate = newToDate;
            
            NSString *fromDateStr   = [ToolClass dateByFormat:@"yyyy-MM-dd" date:newFromDate];
            NSString *toDateStr     = [ToolClass dateByFormat:@"yyyy-MM-dd" date:newToDate];
            
            [self loadAvailabilitiesByFromDate:fromDateStr toDate:toDateStr];
        }
    }
}

- (void) setupTableViewData {
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
    
    //init date
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    
    NSDate *today = [NSDate date];
    NSDate *tomorrow    = [theCalendar dateByAddingComponents:dayComponent toDate:today options:0];
    NSDate *next2dates  = [theCalendar dateByAddingComponents:dayComponent toDate:tomorrow options:0];
    
    NSString *dateFormat = @"EEE, MMM dd";
    NSString *todayStr      = [ToolClass dateByFormat:dateFormat date:today];
    NSString *tomorrowStr   = [ToolClass dateByFormat:dateFormat date:tomorrow];
    NSString *next2DatesStr = [ToolClass dateByFormat:dateFormat date:next2dates];
    
    [sectionArray addObject:todayStr];
    [sectionArray addObject:tomorrowStr];
    [sectionArray addObject:next2DatesStr];
    
    
    for (int i=0;i < [sectionArray count];i++) {
        //init section data
        NSMutableArray* section = [NSMutableArray arrayWithCapacity:1];
        
        int randomRecord = arc4random()%10;
        
        //create time for each date (section is Date, row is Time)
        int duration = 30;
        int startHour = arc4random()%24;
        int startMin  = 0;

        int endHour;
        int endMin;
        
        for (int j=0;j < randomRecord;j++) {
            endMin = startMin + duration;
            if (endMin > duration) {
                endHour = startHour + 1;
                endMin  = 0;
            }
            else {
                endHour = startHour;
                startMin += duration;
            }
            
            NSString *time = [NSString stringWithFormat:@"%02d:%02d - %02d:%02d",startHour,startMin,endHour,endMin];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:time,@"title", nil];
            [section addObject:dict];
        }
        
        [self.data addObject:section];
    }
    
    for (int i = 0 ; i < [sectionArray count] ; i++)
    {
        UIView* header = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenSize.width, 40)];
        [header setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lbSectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenSize.width/2-20, 30)];

        lbSectionTitle.backgroundColor = [UIColor colorWithRed:(float)245/255 green:(float)245/255 blue:(float)245/255 alpha:1.0];
        lbSectionTitle.textColor = [UIColor blackColor];
        lbSectionTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        lbSectionTitle.text = [sectionArray objectAtIndex:i];
        lbSectionTitle.textAlignment = NSTextAlignmentCenter;
        [header addSubview:lbSectionTitle];
        
        
        //create round edge for left and right side
        lbSectionTitle.layer.cornerRadius  = lbSectionTitle.frame.size.height/2;
        lbSectionTitle.layer.masksToBounds = YES;
        
        [self.headers addObject:header];
        
        //set position for title label
        lbSectionTitle.center = CGPointMake(screenSize.width/2, lbSectionTitle.center.y);
        
        //set border color for title label in header section. Here is Mon, Jun 25
        lbSectionTitle.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
        lbSectionTitle.layer.borderWidth = 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.headers count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    int totalRecord = (int)[[self.data objectAtIndex:indexPath.section] count];
    
    if (totalRecord > 0) {
        int index = (int)indexPath.row*2;
        
        AvailabilityButton *btnButton = [AvailabilityButton buttonWithType:UIButtonTypeCustom];
        [btnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        
        NSDictionary *dict = [[self.data objectAtIndex:indexPath.section] objectAtIndex:index];
        NSString *title = [dict objectForKey:@"title"];
        
        btnButton.dataDict = dict;
        btnButton.frame = CGRectMake(10, 0, 145, 40);
        if (self.isFree)
            [btnButton setBackgroundImage:[UIImage imageNamed:@"bgFreeAvailability_0.png"] forState:UIControlStateNormal];
        else
            [btnButton setBackgroundImage:[UIImage imageNamed:@"bgAvailability_0.png"] forState:UIControlStateNormal];
        [btnButton setTitle:title forState:UIControlStateNormal];
        [btnButton addTarget:self action:@selector(handleSelectAvailability:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnButton];
        
        //check for the next index
        if (index+1 == [[self.data objectAtIndex:indexPath.section] count]) {
            //dont have more record
        }
        else {
            NSDictionary *dict2 = [[self.data objectAtIndex:indexPath.section] objectAtIndex:index+1];
            
            NSString *title2 = [dict2 objectForKey:@"title"];
            //add button
            AvailabilityButton *btnButton2 = [AvailabilityButton buttonWithType:UIButtonTypeCustom];
            btnButton2.dataDict = dict2;
            [btnButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnButton2.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
            btnButton2.frame = CGRectMake(screenSize.width-155, 0, 145, 40);
            if (self.isFree)
                [btnButton2 setBackgroundImage:[UIImage imageNamed:@"bgFreeAvailability_1.png"] forState:UIControlStateNormal];
            else
                [btnButton2 setBackgroundImage:[UIImage imageNamed:@"bgAvailability_1.png"] forState:UIControlStateNormal];
            [btnButton2 setTitle:title2 forState:UIControlStateNormal];
            [btnButton2 addTarget:self action:@selector(handleSelectAvailability:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnButton2];
            
        }
    }
    else {
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, 40)];
        lbTitle.backgroundColor = [UIColor colorWithRed:(float)245/255 green:(float)245/255 blue:(float)245/255 alpha:1];
        lbTitle.font = [UIFont fontWithName:DEFAULT_FONT size:13];
        lbTitle.text = @"Expert is not available on this day";
        lbTitle.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:lbTitle];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int totalRecord = (int)[[self.data objectAtIndex:section] count];
    
    int numberRow;
    //recalculate record of tableview by divide totalRecord 2
    if (totalRecord % 2 == 0)
        numberRow = totalRecord / 2;
    else
        numberRow = totalRecord /2 + 1;
    
    //if don't have record, add 1 row to show title No Expert is available
    if (totalRecord == 0)
        return 1;
    return numberRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.headers objectAtIndex:section];
}

#pragma mark HANDLE EVENT
- (void) handleSelectAvailability:(AvailabilityButton*)sender {
    ((ScheduleAppointmentViewController*)self.parent).timeDict = sender.dataDict;
    [((ScheduleAppointmentViewController*)self.parent).btnViewAvailability setTitle:[NSString stringWithFormat:@"%@ %@",[sender.dataDict objectForKey:@"date_from"],[sender.dataDict objectForKey:@"title"]] forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
