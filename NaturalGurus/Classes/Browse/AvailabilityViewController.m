//
//  AvailabilityViewController.m
//  NaturalGurus
//
//  Created by Steven Pham on 6/22/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "AvailabilityViewController.h"

@interface AvailabilityViewController ()

@end

@implementation AvailabilityViewController

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
    
    self.lbInstructionTitle.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    //create temporary data for next 3 days
    self.mainTableView.separatorColor = [UIColor clearColor];
    [self.mainTableView setExclusiveSections:!self.mainTableView.exclusiveSections];
    
    [self setupTableViewData];
    [self.mainTableView reloadData];
    
    for (int i=0;i < [self.headers count];i++) {
        [self.mainTableView openSection:i animated:YES];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Availability";
}

- (void) viewDidLayoutSubviews {
    
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
    
    self.data = [[NSMutableArray alloc] init];
    
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
    
    self.headers = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [sectionArray count] ; i++)
    {
        UIView* header = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, 40)];
        [header setBackgroundColor:[UIColor clearColor]];
        
        TTTAttributedLabel *lbSectionTitle = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, 40)];
//        lbSectionTitle.tag = kLabelHeaderTag;
        lbSectionTitle.backgroundColor = [UIColor whiteColor];
        lbSectionTitle.textColor = GREEN_COLOR;
        lbSectionTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        lbSectionTitle.text = [sectionArray objectAtIndex:i];
        lbSectionTitle.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [header addSubview:lbSectionTitle];
        
        //set corner radius for header section label: just top left and top right
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, lbSectionTitle.frame.size.width, lbSectionTitle.frame.size.height) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5.0, 5.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path  = maskPath.CGPath;
        lbSectionTitle.layer.mask = maskLayer;
        
        [self.headers addObject:header];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    int index = indexPath.row;
    
    UIButton *btnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
    
    if (index % 2 == 0) {
        NSDictionary *dict = [[self.data objectAtIndex:indexPath.section] objectAtIndex:index];
        NSString *title = [dict objectForKey:@"title"];
        
        
        btnButton.frame = CGRectMake(10, 0, 145, 40);
        [btnButton setBackgroundImage:[UIImage imageNamed:@"bgAvailability_0.png"] forState:UIControlStateNormal];
        [btnButton setTitle:title forState:UIControlStateNormal];
    }
    else {
        //if dont have more record, don't add button
        if (index == [[self.data objectAtIndex:indexPath.section] count]) {
            ;
        }
        else {
            NSDictionary *dict = [[self.data objectAtIndex:indexPath.section] objectAtIndex:index+1];
            NSString *title = [dict objectForKey:@"title"];
            
            
            btnButton.frame = CGRectMake(screenSize.width-155, 0, 145, 40);
            [btnButton setBackgroundImage:[UIImage imageNamed:@"bgAvailability_1.png"] forState:UIControlStateNormal];
            [btnButton setTitle:title forState:UIControlStateNormal];
        }
    }
    
    [cell.contentView addSubview:btnButton];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int totalRecord = [[self.data objectAtIndex:section] count];
    
    int numberRow;
    //recalculate record of tableview by divide totalRecord 2
    if (totalRecord % 2 == 0)
        numberRow = totalRecord / 2;
    else
        numberRow = totalRecord /2 + 1;
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

@end
