//
//  LiveRequestListViewController.m
//  NaturalGurus
//
//  Created by Steven Pham on 7/22/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "LiveRequestListViewController.h"

@interface LiveRequestCell : UIView {
    NSDate *createdDate;
    NSTimer *timer;
    int countDownDuration;
    UILabel *lbTimeLeft;
    UILabel *lbAvailableTitle;
    
    UIButton *btnApprove;
    UIButton *btnDecline;
}

@property (strong,nonatomic) NSMutableDictionary *timeDict;

- (id) initWithFrame:(CGRect)frame andData:(NSMutableDictionary*)_dict;

@end

@implementation LiveRequestCell
@synthesize timeDict;

- (id) initWithFrame:(CGRect)frame andData:(NSMutableDictionary*)_dict {
    if (self = [super initWithFrame:frame]) {
        timeDict = _dict;
        
        UILabel *lbNameTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 130, 21)];
        lbNameTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        lbNameTitle.textAlignment = NSTextAlignmentRight;
        lbNameTitle.text = @"Name:";
        lbNameTitle.textColor = [UIColor lightGrayColor];
        [self addSubview:lbNameTitle];
        
        UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(lbNameTitle.frame.origin.x+lbNameTitle.frame.size.width+10, lbNameTitle.frame.origin.y, 200, 21)];
        lbName.font = [UIFont fontWithName:DEFAULT_FONT size:13];
        lbName.textAlignment = NSTextAlignmentLeft;
        lbName.text = [timeDict objectForKey:@"name"];
        lbName.textColor = [UIColor lightGrayColor];
        [self addSubview:lbName];
        
        UILabel *lbTypeTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, lbNameTitle.frame.origin.y+lbNameTitle.frame.size.height+5, 130, 21)];
        lbTypeTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        lbTypeTitle.textAlignment = NSTextAlignmentRight;
        lbTypeTitle.text = @"Type:";
        lbTypeTitle.textColor = [UIColor lightGrayColor];
        [self addSubview:lbTypeTitle];
        
        UILabel *lbType = [[UILabel alloc] initWithFrame:CGRectMake(lbTypeTitle.frame.origin.x+lbTypeTitle.frame.size.width+10, lbTypeTitle.frame.origin.y, 200, 21)];
        lbType.font = [UIFont fontWithName:DEFAULT_FONT size:13];
        lbType.textAlignment = NSTextAlignmentLeft;
        lbType.text = [timeDict objectForKey:@"type"];
        lbType.textColor = [UIColor lightGrayColor];
        [self addSubview:lbType];
        
        UILabel *lbAboutTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, lbTypeTitle.frame.origin.y+lbTypeTitle.frame.size.height+5, 130, 21)];
        lbAboutTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        lbAboutTitle.textAlignment = NSTextAlignmentRight;
        lbAboutTitle.text = @"Description:";
        lbAboutTitle.textColor = [UIColor lightGrayColor];
        [self addSubview:lbAboutTitle];
        
        UILabel *lbAbout = [[UILabel alloc] initWithFrame:CGRectMake(lbAboutTitle.frame.origin.x+lbAboutTitle.frame.size.width+10, lbAboutTitle.frame.origin.y, 200, 21)];
        lbAbout.font = [UIFont fontWithName:DEFAULT_FONT size:13];
        lbAbout.textAlignment = NSTextAlignmentLeft;
        lbAbout.text = [timeDict objectForKey:@"about"];
        lbAbout.textColor = [UIColor lightGrayColor];
        [self addSubview:lbAbout];
        
        UILabel *lbDurationTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, lbAboutTitle.frame.origin.y+lbAboutTitle.frame.size.height+5, 130, 21)];
        lbDurationTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        lbDurationTitle.textAlignment = NSTextAlignmentRight;
        lbDurationTitle.text = @"Duration:";
        lbDurationTitle.textColor = [UIColor lightGrayColor];
        [self addSubview:lbDurationTitle];
        
        UILabel *lbDuration = [[UILabel alloc] initWithFrame:CGRectMake(lbDurationTitle.frame.origin.x+lbDurationTitle.frame.size.width+10, lbDurationTitle.frame.origin.y, 200, 21)];
        lbDuration.font = [UIFont fontWithName:DEFAULT_FONT size:13];
        lbDuration.textAlignment = NSTextAlignmentLeft;
        lbDuration.text = [NSString stringWithFormat:@"%d",[[timeDict objectForKey:@"duration"] intValue]];
        lbDuration.textColor = [UIColor lightGrayColor];
        [self addSubview:lbDuration];
        
        UILabel *lbTimeLeftTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, lbDurationTitle.frame.origin.y+lbDurationTitle.frame.size.height+5, 130, 21)];
        lbTimeLeftTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        lbTimeLeftTitle.textAlignment = NSTextAlignmentRight;
        lbTimeLeftTitle.text = @"Time left to decide:";
        lbTimeLeftTitle.textColor = [UIColor lightGrayColor];
        [self addSubview:lbTimeLeftTitle];
        
        createdDate = [ToolClass dateTimeByTimezone:[timeDict objectForKey:@"timezone"] andDate:[timeDict objectForKey:@"created_at"]];
        NSString *todayStr = [ToolClass dateTimeByTimezone:[timeDict objectForKey:@"timezone"] andDate2:[NSDate date]];
        //convert to current timezone
        NSDate *currentDate = [ToolClass dateTimeByTimezone:[timeDict objectForKey:@"timezone"] andDate:todayStr];
        
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:createdDate];
        countDownDuration = 120 - timeInterval;
        
        lbTimeLeft = [[UILabel alloc] initWithFrame:CGRectMake(lbTimeLeftTitle.frame.origin.x+lbTimeLeftTitle.frame.size.width+10, lbTimeLeftTitle.frame.origin.y, 50, 21)];
        lbTimeLeft.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:16];
        lbTimeLeft.textAlignment = NSTextAlignmentLeft;
        lbTimeLeft.text = [NSString stringWithFormat:@"%.0f",timeInterval];
        lbTimeLeft.textColor = [UIColor lightGrayColor];
        [self addSubview:lbTimeLeft];
        
        UILabel *lbSecond = [[UILabel alloc] initWithFrame:CGRectMake(lbTimeLeft.frame.origin.x+lbTimeLeft.frame.size.width, lbTimeLeft.frame.origin.y, 150, 21)];
        lbSecond.font = [UIFont fontWithName:DEFAULT_FONT size:13];
        lbSecond.textAlignment = NSTextAlignmentLeft;
        lbSecond.text = @"seconds";
        lbSecond.textColor = [UIColor lightGrayColor];
        [self addSubview:lbSecond];
        
        lbAvailableTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, lbTimeLeft.frame.origin.y+30, 270, 21)];
        lbAvailableTitle.backgroundColor = [UIColor clearColor];
        lbAvailableTitle.textColor = [UIColor lightGrayColor];
        lbAvailableTitle.font = [UIFont fontWithName:DEFAULT_FONT size:14];
        lbAvailableTitle.text = @"Are you available for this appointment now?";
        [self addSubview:lbAvailableTitle];
        
        btnApprove = [UIButton buttonWithType:UIButtonTypeCustom];
        btnApprove.frame = CGRectMake(lbAvailableTitle.frame.origin.x, lbAvailableTitle.frame.origin.y+30, 80, 30);
        [btnApprove setTitle:@"Approve" forState:UIControlStateNormal];
        btnApprove.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        [btnApprove setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
        [btnApprove addTarget:self action:@selector(approveLiveRequest) forControlEvents:UIControlEventTouchUpInside];
        
        btnApprove.layer.cornerRadius = 5;
        btnApprove.layer.masksToBounds = YES;
        [self addSubview:btnApprove];
        
        btnDecline = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDecline.frame = CGRectMake(btnApprove.frame.origin.x + btnApprove.frame.size.width + 20, btnApprove.frame.origin.y, 80, 30);
        [btnDecline setTitle:@"Decline" forState:UIControlStateNormal];
        btnDecline.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        [btnDecline setBackgroundImage:[ToolClass imageFromColor:RED_COLOR] forState:UIControlStateNormal];
        [btnDecline addTarget:self action:@selector(declineLiveRequest) forControlEvents:UIControlEventTouchUpInside];
        
        btnDecline.layer.cornerRadius = 5;
        btnDecline.layer.masksToBounds = YES;
        [self addSubview:btnDecline];
        
        //handle if countdownduration <= 0
        if (countDownDuration <= 0) {
            countDownDuration = 0;
            
            lbTimeLeft.text = [NSString stringWithFormat:@"%d",countDownDuration];
            
            btnApprove.hidden = btnDecline.hidden = YES;
            lbAvailableTitle.text = @"Time Up";
            lbAvailableTitle.textColor = RED_COLOR;
        }
        else {
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        }
    }
    return self;
}

- (void) countDown {
    countDownDuration--;
    
    if (countDownDuration <= 0) {
        [timer invalidate];
        countDownDuration = 0;
        
        btnApprove.hidden = btnDecline.hidden = YES;
        lbAvailableTitle.text = @"Time Up";
        lbAvailableTitle.textColor = RED_COLOR;
    }
    
    lbTimeLeft.text = [NSString stringWithFormat:@"%d",countDownDuration];
}

- (void) approveLiveRequest {
    
}

- (void) declineLiveRequest {
    
}

- (void) dealloc {
    NSLog(@"LiveRequestCell dealloc");
}

@end

@interface LiveRequestListViewController ()

@end

@implementation LiveRequestListViewController
@synthesize mainArray;

+ (LiveRequestListViewController *) instance {
    static LiveRequestListViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithNibName:@"LiveRequestListViewController" bundle:nil];
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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 0, 24, 24);
    [btnLeft setImage:[UIImage imageNamed:@"btnClose.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem = btnItem;
    
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mainTableView.backgroundColor = [UIColor clearColor];
    
    mainArray = [NSMutableArray arrayWithCapacity:1];
    [self reloadLiveRequest];
}

- (void) closeView {
    self.isOpening = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) reloadLiveRequest {
    if (!isLoading) {
        isLoading = YES;
        [mainArray removeAllObjects];
        self.isOpening = YES;
        
        NSString *token = [[ToolClass instance] getUserToken];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token", nil];
        [[ToolClass instance] loadLiveRequestList:params viewController:self];
    }
}

- (void) reorganizeLiveRequest:(NSArray*)array {
    for (int i=0;i < [array count];i++) {
        NSDictionary *dict = [array objectAtIndex:i];
        
        //server response GMT
        NSString *timezone = @"GMT";
        NSString *type = @"Live appointment (right now)";
        NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"about"],@"about",[dict objectForKey:@"duration"],@"duration",[dict objectForKey:@"email"],@"email",[dict objectForKey:@"expert_id"],@"expertId",[dict objectForKey:@"name"],@"name",[dict objectForKey:@"total"],@"total",[dict objectForKey:@"created_at"],@"created_at",type,@"type",timezone,@"timezone", nil];
        [mainArray addObject:newDict];
    }
    [self.mainTableView reloadData];
    isLoading = NO;
}

- (void) viewDidLayoutSubviews {
    self.mainTableView.rowHeight = 210;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    NSMutableDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    
    LiveRequestCell *view = [[LiveRequestCell alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.mainTableView.rowHeight) andData:dict];

    [cell.contentView addSubview:view];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
