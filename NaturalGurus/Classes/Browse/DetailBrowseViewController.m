//
//  DetailBrowseViewController.m
//  NaturalGurus
//
//  Created by Steven on 6/13/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailBrowseViewController.h"
#import "BrowseViewController.h"

enum {
    kAboutSection = 0,
    kQualificationsSection,
    kQuickStatsSection,
};

enum {
    kLabelHeaderTag = 100,
    kIconArrowTag
};

@implementation DetailBrowseViewController
@synthesize parent;
@synthesize expertDict;
@synthesize tableView;
@synthesize currentPage,lastPage;
@synthesize totalReview;
@synthesize isLoading;
@synthesize freeSession;

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
    
    screenSize = [[UIScreen mainScreen] bounds].size;

    [self setupUI];
    
    //default is selecting description
    self.tableView.shouldHandleHeadersTap = NO;
    [self.tableView setExclusiveSections:!self.tableView.exclusiveSections];
    
    self.reviewData     = [NSMutableArray arrayWithCapacity:1];
    self.reviewHeaders  = [NSMutableArray arrayWithCapacity:1];
    
    //load detail expert
    [self loadExpertById];
    [self performSelectorInBackground:@selector(getTotalExpertReviews) withObject:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = [expertDict objectForKey:@"name"];
}

- (void) viewDidLayoutSubviews {
    //use front view to hide all everything behind
    self.myFrontView.backgroundColor = TABLE_BACKGROUND_COLOR;
}

- (void) setupUI {
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    //add a view line on top headerview
    UIView *topLineHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.frame.size.width, 1)];
    topLineHeader.backgroundColor = [UIColor lightGrayColor];
    [self.headerView addSubview:topLineHeader];
    
    [self setUpStyleForReviewButton];
    
    //set style for Description and Review button
    [self.btnDescription setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnDescription setTitleColor:GREEN_COLOR forState:UIControlStateHighlighted];
    [self.btnDescription setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    
    [self.btnReview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnReview setTitleColor:GREEN_COLOR forState:UIControlStateHighlighted];
    [self.btnReview setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    
    //set style for Book Live and Schedule button
    self.btnBookLive = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBookLive.backgroundColor = [UIColor lightGrayColor];
    [self.btnBookLive setTitle:@"Meet Now" forState:UIControlStateNormal];
    self.btnBookLive.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
    [self.btnBookLive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnBookLive addTarget:self action:@selector(handleBookLive:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBookLive setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
    self.btnBookLive.layer.cornerRadius  = 5;
    self.btnBookLive.layer.masksToBounds = YES;
    [self.bottomView addSubview:self.btnBookLive];
    
    self.btnSchedule = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSchedule.backgroundColor = [UIColor lightGrayColor];
    [self.btnSchedule setTitle:@"Schedule" forState:UIControlStateNormal];
    self.btnSchedule.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
    [self.btnSchedule setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSchedule addTarget:self action:@selector(handleScheduleAppointment:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSchedule setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
    self.btnSchedule.layer.cornerRadius  = 5;
    self.btnSchedule.layer.masksToBounds = YES;
    [self.bottomView addSubview:self.btnSchedule];
    
    self.btnGetFreeSession = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnGetFreeSession.backgroundColor = [UIColor lightGrayColor];
    [self.btnGetFreeSession setTitle:@"Get Free Mins" forState:UIControlStateNormal];
    self.btnGetFreeSession.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
    [self.btnGetFreeSession setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnGetFreeSession addTarget:self action:@selector(handleScheduleAppointment:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnGetFreeSession setBackgroundImage:[ToolClass imageFromColor:ORANGE_COLOR] forState:UIControlStateNormal];
    self.btnGetFreeSession.layer.cornerRadius  = 5;
    self.btnGetFreeSession.layer.masksToBounds = YES;
    [self.bottomView addSubview:self.btnGetFreeSession];
    
    //set style for table view
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    //set number of rating
    self.starRatingView.backgroundImage = nil;
    self.starRatingView.starImage = [UIImage imageNamed:@"star_highlighted.png"];
    self.starRatingView.starHighlightedImage = [UIImage imageNamed:@"star.png"];
    self.starRatingView.maxRating = 5.0;
    self.starRatingView.horizontalMargin = 0;
    self.starRatingView.editable    = NO;
    self.starRatingView.displayMode = EDStarRatingDisplayAccurate;
    
    //allocate share button
    UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 19)];
    [btnShare setImage:[UIImage imageNamed:@"btnShare"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(handleShareAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnShareItem = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    self.navigationItem.rightBarButtonItem = btnShareItem;
    
    //check whether user enable push notification or not
    //if not, make blur for Meet Now button
    UIApplication *application = [UIApplication sharedApplication];
    
    BOOL enabled;
    
    // Try to use the newer isRegisteredForRemoteNotifications otherwise use the enabledRemoteNotificationTypes.
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        enabled = [application isRegisteredForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = [application enabledRemoteNotificationTypes];
        enabled = types & UIRemoteNotificationTypeAlert;
    }
    
    if (!enabled) {
        self.btnBookLive.alpha = 0.7;
    }
}

- (void) setUpStyleForReviewButton {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
    UIFont *font2 = [UIFont fontWithName:DEFAULT_FONT  size:13];
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font1,
                            NSParagraphStyleAttributeName:style};
    NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font2,
                            NSParagraphStyleAttributeName:style};
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"REVIEWS "    attributes:dict1]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%d)",totalReview]      attributes:dict2]];
    [self.btnReview setAttributedTitle:attString forState:UIControlStateNormal];
    
    //create color title
    NSDictionary *dict3 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font1,
                            NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:
                            GREEN_COLOR};
    NSDictionary *dict4 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font2,
                            NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:
                                GREEN_COLOR};
    NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] init];
    [attString2 appendAttributedString:[[NSAttributedString alloc] initWithString:@"REVIEWS "    attributes:dict3]];
    [attString2 appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%d)",totalReview]      attributes:dict4]];
    [self.btnReview setAttributedTitle:attString2 forState:UIControlStateSelected];
}

- (void) handleShareAction {
    NSString *name = [self.expertDict objectForKey:@"name"];
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    name = [name lowercaseString];
    
//    NSURL *urlToShare = [NSURL URLWithString:[NSString stringWithFormat:@"https://naturalgurus.com/profile/%@/%ld",name,self.expertId]];
    
    NSString *textToShare = [NSString stringWithFormat:@"Please check out this expert: %@",[NSString stringWithFormat:@"https://naturalgurus.com/profile/%@/%ld",name,self.expertId]];
    
    NSArray *objectsToShare = @[textToShare];
//    NSArray *applicationArray = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMail];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    controller.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) loadExpertById {
    [[ToolClass instance] loadDetailExpertById:self.expertId withViewController:self];
}

- (void) getTotalExpertReviews {
    [[ToolClass instance] getTotalReviewsByExpertId:self.expertId pageIndex:1 withViewController:self];
}

- (void) setupTableViewData {
    self.navigationItem.title = [expertDict objectForKey:@"name"];
    
    NSArray *sectionArray = @[@"ABOUT",@"QUALIFICATIONS",@"QUICK STATS"];
    
    self.data = [[NSMutableArray alloc] init];
    
    for (int i=kAboutSection;i < [sectionArray count];i++) {
        //init section data
        NSMutableArray* section = [[NSMutableArray alloc] init];
        if (i == kAboutSection) {
//            NSString *description = self.expertDescriptionString;
            NSString *description = [expertDict objectForKey:@"description"];
            
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            [section addObject:attrStr];
        }
        else if (i == kQualificationsSection){
            section = [expertDict objectForKey:@"qualifications"] == nil ? @[] : [expertDict objectForKey:@"qualifications"];
        }
        else if (i == kQuickStatsSection) {
            //init quickstat data
            NSString *joinDate      = [expertDict objectForKey:@"join_date"] == nil ? @"" : [expertDict objectForKey:@"join_date"];
            NSString *experience    = [expertDict objectForKey:@"experience"] == nil ? @"" : [expertDict objectForKey:@"experience"];
            NSString *level         = [expertDict objectForKey:@"level"] == nil ? @"" : [expertDict objectForKey:@"level"];
            NSString *numberSession = [expertDict objectForKey:@"sessions"] == nil ? @"0" : [NSString stringWithFormat:@"%d",[[expertDict objectForKey:@"sessions"] intValue]];
            NSString *minSession    = [expertDict objectForKey:@"min_duration"] == nil ? @"0" : [NSString stringWithFormat:@"%d mins",[[expertDict objectForKey:@"min_duration"] intValue]];
            NSString *maxSession    = [expertDict objectForKey:@"max_duration"] == nil ? @"0" : [NSString stringWithFormat:@"%d mins",[[expertDict objectForKey:@"max_duration"] intValue]];
            
            NSString *association   = [expertDict objectForKey:@"association"];
            NSString *accreditation = [expertDict objectForKey:@"accreditation_number"];
            
            NSMutableArray *quickStatsTitleArray = [NSMutableArray arrayWithObjects:@"Joined",@"Experience",@"Level",@"Sessions",@"Minimum session",@"Maximum session", nil];
            
            NSMutableArray *quickStatValueArray = [NSMutableArray arrayWithObjects:joinDate,experience,level,numberSession,minSession,maxSession, nil];
            
            if (association != nil && ![association isEqualToString:@""]) {
                [quickStatsTitleArray addObject:@"Association"];
                [quickStatValueArray addObject:association];
            }
            
            if (accreditation != nil && ![accreditation isEqualToString:@""]) {
                [quickStatsTitleArray addObject:@"Accreditation #"];
                [quickStatValueArray addObject:accreditation];
            }
            
            for (int i=0; i < [quickStatsTitleArray count];i++) {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[quickStatsTitleArray objectAtIndex:i],@"title",[quickStatValueArray objectAtIndex:i],@"value", nil];
                [section addObject:dict];
            }
        }
        else {
            
        }
        [self.data addObject:section];
    }
    
    self.headers = [[NSMutableArray alloc] init];
    for (int i = 0 ; i <= kQuickStatsSection ; i++)
    {
        UIView* header = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, 40)];
        [header setBackgroundColor:[UIColor clearColor]];
        
        TTTAttributedLabel *lbSectionTitle = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, 40)];
        lbSectionTitle.tag = kLabelHeaderTag;
        lbSectionTitle.backgroundColor = [UIColor whiteColor];
        lbSectionTitle.textColor = GREEN_COLOR;
        lbSectionTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        lbSectionTitle.text = [sectionArray objectAtIndex:i];
        lbSectionTitle.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);

        [header addSubview:lbSectionTitle];
        
        //set corner radius for header section label: just top left and top right
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, lbSectionTitle.frame.size.width, lbSectionTitle.frame.size.height) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(CORNER_RADIUS, CORNER_RADIUS)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path  = maskPath.CGPath;
        lbSectionTitle.layer.mask = maskLayer;
        
        //create border with 3 edges: top, left, right
        
        CAShapeLayer *strokeLayer = [self addBorderLineWithFrame:lbSectionTitle.frame top:YES bottom:NO left:YES right:YES];
        [lbSectionTitle.layer addSublayer:strokeLayer];
        
        //add arrow image
        UIImageView *imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(header.frame.size.width-10, 10, 12, 7)];
        imgArrow.tag = kIconArrowTag;
        imgArrow.center = CGPointMake(imgArrow.frame.origin.x, lbSectionTitle.center.y);
        imgArrow.image = [UIImage imageNamed:@"iconArrowDown.png"];
        [header addSubview:imgArrow];
        
        [self.headers addObject:header];
    }
    
    [self selectDescription:nil];
    
    //set rating value
    self.starRatingView.rating      = [[expertDict objectForKey:@"rating"] floatValue];
    
    //set Duration label text
    self.lbDuration.text = [NSString stringWithFormat:@"$%@ per minute",[expertDict objectForKey:@"price"]];
    [[ToolClass instance] setExpertPrice:[[expertDict objectForKey:@"price"] floatValue]];
    
    //set Online / Offline label text
    BOOL isOnline = [[expertDict objectForKey:@"online"] boolValue];
    if (isOnline) {
        [self.imgStatusView setImage:[UIImage imageNamed:@"iconOnline.png"]];
    }
    else {
        self.btnBookLive.userInteractionEnabled = NO;
        self.btnBookLive.alpha = 0.7;
        [self.imgStatusView setImage:[UIImage imageNamed:@"iconOffline.png"]];
    }
    
    //set Service name label text
    self.lbServiceName.text = [expertDict objectForKey:@"title"];
    
    //get expert image
    NSString *avatar = [expertDict objectForKey:@"avatar"];
    avatar = [avatar stringByReplacingOccurrencesOfString:@" " withString:@"\%20"];
    
    UIImageView *se = self.imgExpertView;
    
    NSString *imgUrl = avatar;
    [self.imgExpertView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                          placeholderImage:[UIImage imageNamed:@"avatarDefault.png"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *url) {
                                     
                                     se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(EXPERT_IN_LIST_WIDTH, EXPERT_IN_LIST_HEIGHT) source:image];
                                     
                                 }];
    self.imgExpertView.layer.cornerRadius  = EXPERT_IMAGE_WIDTH/2;
    self.imgExpertView.layer.masksToBounds = YES;
    
    //check free session
//    int freeSession = [[expertDict objectForKey:@"free_session"] intValue];
    int padding = 10;
    int height  = 40;
    
    //relocate 3 bottom buttons and their frames also
    
    if (freeSession > 0) {
        [self.lbFreeSession setTitle:[NSString stringWithFormat:@"Free %d mins call",freeSession] forState:UIControlStateNormal];
        
        self.btnBookLive.frame = CGRectMake(padding, self.btnBookLive.frame.origin.y, (screenSize.width-4*padding)/3, height);
        self.btnSchedule.frame = CGRectMake(2*padding+self.btnBookLive.frame.size.width, self.btnBookLive.frame.origin.y, self.btnBookLive.frame.size.width, height);
        self.btnGetFreeSession.frame = CGRectMake(3*padding+2*self.btnBookLive.frame.size.width, self.btnBookLive.frame.origin.y, self.btnBookLive.frame.size.width, height);
        
        self.lbFreeSession.hidden = NO;
        self.btnGetFreeSession.hidden = NO;
    }
    else {
        self.btnBookLive.frame = CGRectMake(padding, self.btnBookLive.frame.origin.y, (screenSize.width-3*padding)/2, height);
        self.btnSchedule.frame = CGRectMake(2*padding+self.btnBookLive.frame.size.width, self.btnBookLive.frame.origin.y, self.btnBookLive.frame.size.width, height);
        
        self.lbFreeSession.hidden = YES;
        self.btnGetFreeSession.hidden = YES;
    }
    
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
    [self.myFrontView removeFromSuperview];
}

- (void) reloadExpertReviews {
    currentPage = 1;
    [self.reviewData removeAllObjects];
    [self.reviewHeaders removeAllObjects];
    
    [self loadExpertReviewsById:self.expertId];
}

- (void) loadExpertReviewsById:(long)_id {
    isLoading = YES;
    [[ToolClass instance] loadExpertReviewById:_id pageIndex:currentPage withViewController:self];
}

- (void) reorganizeReviewArray:(NSArray*)array {
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
    unsigned long startIndex = [self.reviewData count];
    unsigned long endIndex   = startIndex + [array count];
    
    //reorganize expert array after requesting, and add to current expert array
    for (int i=0;i < [array count];i++) {
        NSDictionary *dict = [array objectAtIndex:i];
        
        NSString *title     = [dict objectForKey:@"title"];
        NSString *content   = [dict objectForKey:@"content"];
        NSString *name      = [dict objectForKey:@"name"];
        NSString *rate      = [NSString stringWithFormat:@"%f",[[dict objectForKey:@"rate"] floatValue]];
        
//        NSDictionary *tmpDict = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",content,@"content",name,@"name",rate,@"rate", nil];
        
        UIView* header = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, 65)];
        [header setBackgroundColor:[UIColor clearColor]];
        
        TTTAttributedLabel *lbSectionTitle = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, 65)];
        lbSectionTitle.tag = kLabelHeaderTag;
        lbSectionTitle.backgroundColor = [UIColor whiteColor];
        lbSectionTitle.textColor = GREEN_COLOR;
        lbSectionTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        lbSectionTitle.text = name;
        lbSectionTitle.textInsets = UIEdgeInsetsMake(-30, 60, 0, 0);
        
        [header addSubview:lbSectionTitle];
        
        //set corner radius for header section label: just top left and top right
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, lbSectionTitle.frame.size.width, lbSectionTitle.frame.size.height) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5.0, 5.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path  = maskPath.CGPath;
        lbSectionTitle.layer.mask = maskLayer;
        lbSectionTitle.layer.masksToBounds = YES;
        
        //create border with 3 edges: top, left, right
        
        CAShapeLayer *strokeLayer = [self addBorderLineWithFrame:lbSectionTitle.frame top:YES bottom:NO left:YES right:YES];
        [lbSectionTitle.layer addSublayer:strokeLayer];
        
        //add star rating view
        EDStarRating *ratingView = [[EDStarRating alloc] initWithFrame:CGRectMake(70, 20, 55, 32)];
        ratingView.backgroundImage = nil;
        ratingView.starImage = [UIImage imageNamed:@"star_highlighted.png"];
        ratingView.starHighlightedImage = [UIImage imageNamed:@"star.png"];
        ratingView.maxRating = 5.0;
        ratingView.horizontalMargin = 0;
        ratingView.editable    = NO;
        ratingView.displayMode = EDStarRatingDisplayAccurate;
        ratingView.rating = [rate floatValue];
        [header addSubview:ratingView];
        
        UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, EXPERT_IN_LIST_WIDTH/2, EXPERT_IN_LIST_HEIGHT/2)];
        
        UIImageView *se = addView;
        
        NSString *avatar = [dict objectForKey:@"avatar"];
        avatar = [avatar stringByReplacingOccurrencesOfString:@" " withString:@"\%20"];
        
        NSString *imgUrl = avatar;
        [addView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                   placeholderImage:[UIImage imageNamed:@"avatarDefault.png"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *url) {
                              
                              se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(EXPERT_IN_LIST_WIDTH/2, EXPERT_IN_LIST_HEIGHT/2) source:image];
                              
                          }];
        [addView.layer setCornerRadius:EXPERT_IN_LIST_WIDTH/4];
        [addView.layer setMasksToBounds:YES];
        [header addSubview:addView];
        
        //add title header`
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(70, 45, screenSize.width-80, 21)];
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:14];
        lbTitle.text = title;
        [header addSubview:lbTitle];
        
        [self.reviewHeaders addObject:header];
        
        [self.reviewData addObject:content];
    }
    
    currentPage++;
    isLoading = NO;
    
    if ([self.reviewData count] == [array count]) {
        [self.tableView reloadData];
    }
    else {
        //show drop down animation effect
        NSMutableIndexSet* indexSetsToInsert = [NSMutableIndexSet indexSet];
        
        for (unsigned long i=startIndex;i < endIndex;i++) {
            [indexSetsToInsert addIndexes:[NSIndexSet indexSetWithIndex:i]];
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertSections:indexSetsToInsert withRowAnimation:UITableViewRowAnimationTop];

        [self.tableView endUpdates];
    }
    
    //open section review
    for (unsigned long i=startIndex;i < endIndex;i++) {
        [self.tableView openSection:i animated:NO];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    // Check if we are at the bottom of the table
    // This will load more experts
    if (self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
    {
        //check for loading more the expert list
        if (!isLoading && currentPage <= lastPage && !isSelectDescription) {
            [self loadExpertReviewsById:self.expertId];
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isSelectDescription)
        return [self.data count];
    else {
        if ([self.reviewHeaders count] == 0)
            return 1;
        return [self.reviewHeaders count];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    if (isSelectDescription) {
        //create background view cell
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height) byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path  = maskPath.CGPath;
        
        int offsetY = 0;
        
        if (indexPath.section == kAboutSection) {
            NSAttributedString *desciptionText = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
            UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, 10)];
            txtView.userInteractionEnabled = NO;
            txtView.attributedText = desciptionText;
            
//            CGSize size = [txtView sizeThatFits:CGSizeMake(screenSize.width, CGFLOAT_MAX)];
//            txtView.frame = CGRectMake(0, -5, bgView.frame.size.width, size.height+10);
            CGFloat fixedWidth = txtView.frame.size.width;
            CGSize newSize = [txtView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            CGRect newFrame = txtView.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
            txtView.frame = newFrame;
            
            txtView.textContainerInset = UIEdgeInsetsMake(5.0, 5.0, 0.0, 0.0);
            
            bgView.frame = CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, bgView.frame.size.width, txtView.frame.size.height);
            [bgView addSubview:txtView];
            
            //set corner border for textview
            maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, txtView.frame.size.width, txtView.frame.size.height) byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(CORNER_RADIUS, CORNER_RADIUS)];
            
            maskLayer.path  = maskPath.CGPath;
            txtView.layer.mask = maskLayer;
            
            //create bezier path for border line txtview
            //create border with 3 edges: bottom, left, right

            CAShapeLayer *strokeLayer = [self addBorderLineWithFrame:txtView.frame top:NO bottom:YES left:YES right:YES];
            [txtView.layer addSublayer:strokeLayer];
        }
        else if (indexPath.section == kQualificationsSection){
            NSMutableArray *qualificationArray = [self.data objectAtIndex:indexPath.section];
            NSDictionary *qualificationDict = [qualificationArray objectAtIndex:indexPath.row];
            
            UILabel *lbQualificationTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 200, 21)];
            lbQualificationTitle.backgroundColor = [UIColor clearColor];
            lbQualificationTitle.text = [qualificationDict objectForKey:@"name"];
            lbQualificationTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:12];
            [bgView addSubview:lbQualificationTitle];
            
            UILabel *lbQualificationYear = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width-205, offsetY, 200, 21)];
            lbQualificationYear.backgroundColor = [UIColor clearColor];
            lbQualificationYear.text = [NSString stringWithFormat:@"%@ - %@",[qualificationDict objectForKey:@"start"],[qualificationDict objectForKey:@"end"]];
            lbQualificationYear.textAlignment = NSTextAlignmentRight;
            lbQualificationYear.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:12];
            [bgView addSubview:lbQualificationYear];
            
            //make corner radius for last row
            if (indexPath.row == [qualificationArray count]-1) {
                bgView.layer.mask = maskLayer;
                
                //draw border for last cell
                CAShapeLayer *strokeLayer = [self addBorderLineWithFrame:bgView.frame top:NO bottom:YES left:YES right:YES];
                [bgView.layer addSublayer:strokeLayer];
            }
            else {
                //draw border left and right
                CAShapeLayer *strokeLayer = [self addBorderLineWithFrame:bgView.frame top:NO bottom:NO left:YES right:YES];
                [bgView.layer addSublayer:strokeLayer];
            }
        }
        else if (indexPath.section == kQuickStatsSection) {
            NSMutableArray *quickStatsArray = [self.data objectAtIndex:indexPath.section];
            NSDictionary *quickStatsDict = [quickStatsArray objectAtIndex:indexPath.row];
            
            UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 200, 21)];
            lbTitle.backgroundColor = [UIColor clearColor];
            lbTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
            lbTitle.text = [quickStatsDict objectForKey:@"title"];
            [bgView addSubview:lbTitle];
            
            UILabel *lbValue = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width-145, offsetY, 140, 21)];
            lbValue.backgroundColor = [UIColor clearColor];
            lbValue.font = [UIFont fontWithName:DEFAULT_FONT size:13];
            lbValue.text = [quickStatsDict objectForKey:@"value"];
            lbValue.textAlignment = NSTextAlignmentRight;
            [bgView addSubview:lbValue];
            
            //make corner radius for last row
            if (indexPath.row == [quickStatsArray count]-1) {
                bgView.layer.mask = maskLayer;
                
                //draw border for last cell
                CAShapeLayer *strokeLayer = [self addBorderLineWithFrame:bgView.frame top:NO bottom:YES left:YES right:YES];
                [bgView.layer addSublayer:strokeLayer];
            }
            else {
                //draw border left and right
                CAShapeLayer *strokeLayer = [self addBorderLineWithFrame:bgView.frame top:NO bottom:NO left:YES right:YES];
                [bgView.layer addSublayer:strokeLayer];
            }
        }
        [cell.contentView addSubview:bgView];
    }
    else {
        if ([self.reviewHeaders count] == 0) {
            UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, 40)];
            lbTitle.backgroundColor = [UIColor colorWithRed:(float)245/255 green:(float)245/255 blue:(float)245/255 alpha:1];
            lbTitle.font = [UIFont fontWithName:DEFAULT_FONT size:13];
            lbTitle.text = @"There isn't any reviews for this expert.";
            lbTitle.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:lbTitle];
        }
        else {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, 40)];
            bgView.backgroundColor = [UIColor clearColor];
            
            NSString *desciptionText = [self.reviewData objectAtIndex:indexPath.row+indexPath.section];
            
//            UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-10, 10)];
            UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width-20, 10)];
            txtView.userInteractionEnabled = NO;
            txtView.text = desciptionText;
            
//            CGSize size = [txtView sizeThatFits:CGSizeMake(screenSize.width, CGFLOAT_MAX)];
//            txtView.frame = CGRectMake(0, -5, bgView.frame.size.width, size.height);
            // get the size of the UITextView based on what it would be with the text
            CGFloat fixedWidth = txtView.frame.size.width;
            CGSize newSize = [txtView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            CGRect newFrame = txtView.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
            txtView.frame = newFrame;
            
            [bgView addSubview:txtView];
            
            //set corner border for textview
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, txtView.frame.size.width, txtView.frame.size.height) byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
            
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.path  = maskPath.CGPath;
            txtView.layer.mask = maskLayer;
            
            //create bezier path for border line txtview
            //create border with 3 edges: bottom, left, right
            
            CAShapeLayer *strokeLayer = [self addBorderLineWithFrame:txtView.frame top:NO bottom:YES left:YES right:YES];
            [txtView.layer addSublayer:strokeLayer];
            
            [cell.contentView addSubview:bgView];
        }
    }
    
    cell.userInteractionEnabled = NO;
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSelectDescription)
        return [[self.data objectAtIndex:section] count];
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (isSelectDescription)
        return 40;
    else
        return 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    
    if (isSelectDescription) {
        view = [self.headers objectAtIndex:section];
        
        //handle tap on header section
        NSArray* gestures = view.gestureRecognizers;
        BOOL tapGestureFound = NO;
        for (UIGestureRecognizer* gesture in gestures)
        {
            if ([gesture isKindOfClass:[UITapGestureRecognizer class]])
            {
                tapGestureFound = YES;
                break;
            }
        }
        
        if (!tapGestureFound)
        {
            [view setTag:section];
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        }
    }
    else {
        if ([self.reviewHeaders count] != 0)
            view = [self.reviewHeaders objectAtIndex:section];
        else
            return nil;
    }

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int rowHeight = 40;
    
    if (isSelectDescription) {
        if (indexPath.section == kAboutSection) {
            //get description text
            NSAttributedString *desciptionText = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
            UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width-20, 10)];
            txtView.attributedText = desciptionText;
            
            CGFloat fixedWidth = txtView.frame.size.width;
            CGSize newSize = [txtView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            CGRect newFrame = txtView.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
            rowHeight = newFrame.size.height;
        }
    }
    else {
        if ([self.reviewHeaders count] == 0)
            return rowHeight;
        else {
            NSString *reviewText = [self.reviewData objectAtIndex:indexPath.row+indexPath.section];
            
            UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width-20, 10)];
            txtView.text = reviewText;
            
            CGFloat fixedWidth = txtView.frame.size.width;
            CGSize newSize = [txtView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            CGRect newFrame = txtView.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
            rowHeight = newFrame.size.height;
            
        }
    }
    
    return rowHeight;
}

- (void)handleTapGesture:(UITapGestureRecognizer*)tap
{
    NSInteger index = tap.view.tag;
    
    if (index >= 0)
    {
        [self.tableView toggleSection:(NSUInteger)index animated:YES];
        
        //check the status of this section to change compatible arrow image
        BOOL isSectionOpen = [self.tableView isOpenSection:index];
        UILabel *lbHeaderSection;
        UIImageView *imgArrow;
        if (isSelectDescription) {
            lbHeaderSection = (UILabel*)[[self.headers objectAtIndex:index] viewWithTag:kLabelHeaderTag];
            imgArrow = (UIImageView*)[[self.headers objectAtIndex:index] viewWithTag:kIconArrowTag];
        }
        else {
            lbHeaderSection = (UILabel*)[[self.reviewHeaders objectAtIndex:index] viewWithTag:kLabelHeaderTag];
            imgArrow = (UIImageView*)[[self.reviewHeaders objectAtIndex:index] viewWithTag:kIconArrowTag];
        }
        
        if (isSectionOpen) {
            UIImage *landscapeImage = [UIImage imageNamed:@"iconArrowDown.png"];
            imgArrow.image = landscapeImage;
            
            imgArrow.frame  = CGRectMake(imgArrow.frame.origin.x, imgArrow.frame.origin.y, 12, 7);
            imgArrow.center = CGPointMake(imgArrow.center.x, lbHeaderSection.center.y);
            
            //set corner radius for header section label: just top left and top right
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, lbHeaderSection.frame.size.width, lbHeaderSection.frame.size.height) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5.0, 5.0)];
            
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.path  = maskPath.CGPath;
            lbHeaderSection.layer.mask = maskLayer;
            
            //remove previous layer
            CAShapeLayer *previousLayer = [lbHeaderSection.layer.sublayers lastObject];
            [previousLayer removeFromSuperlayer];
            
            //add new layer
            CAShapeLayer *strokeLayer = [self addBorderLineWithFrame:lbHeaderSection.frame top:YES bottom:NO left:YES right:YES];
            [lbHeaderSection.layer addSublayer:strokeLayer];
        }
        else {
            UIImage * portraitImage = [[UIImage alloc] initWithCGImage: imgArrow.image.CGImage
                                                                 scale: 1.0
                                                           orientation: UIImageOrientationLeft];
            imgArrow.image = portraitImage;
            imgArrow.frame = CGRectMake(imgArrow.frame.origin.x, imgArrow.frame.origin.y, 7, 12);
            imgArrow.center = CGPointMake(imgArrow.center.x, lbHeaderSection.center.y);
            
            //set corner radius for header section label for 4 corner
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, lbHeaderSection.frame.size.width, lbHeaderSection.frame.size.height) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight |UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
            
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.path  = maskPath.CGPath;
            lbHeaderSection.layer.mask = maskLayer;
            
            //remove previous layer
            CAShapeLayer *previousLayer = [lbHeaderSection.layer.sublayers lastObject];
            [previousLayer removeFromSuperlayer];
            
            CAShapeLayer *strokeLayer = [self addBorderLineWithFrame:lbHeaderSection.frame top:YES bottom:YES left:YES right:YES];
            [lbHeaderSection.layer addSublayer:strokeLayer];
        }
    }
}
#pragma mark HANLE EVENT
- (IBAction) handleBookLive:(id)sender {
    BOOL isLoggedIn = [[ToolClass instance] isLogin];
    
    if (!isLoggedIn) {
        [(BrowseViewController*)parent leftButtonPress];
        
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Sign In Required" message:@"Please sign in to continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    //check whether user enable push notification or not
    //if not, make blur for Meet Now button
    UIApplication *application = [UIApplication sharedApplication];
    
    BOOL enabled;
    
    // Try to use the newer isRegisteredForRemoteNotifications otherwise use the enabledRemoteNotificationTypes.
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        enabled = [application isRegisteredForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = [application enabledRemoteNotificationTypes];
        enabled = types & UIRemoteNotificationTypeAlert;
    }
    
    if (!enabled) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please turn on the NaturalGurus' Push Notification in Setting -> Notification Center to use this function." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
    }
    else {
        //init duration array for this expert
        NSDictionary *durationDict = [expertDict objectForKey:@"durations"];
        NSMutableArray *durationArray = [NSMutableArray arrayWithCapacity:1];
        
        for (int i=0;i < [[durationDict allKeys] count];i++) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[durationDict allValues] objectAtIndex:i],@"title",[[durationDict allKeys] objectAtIndex:i],@"value", nil];
            [durationArray addObject:dict];
        }
        
        NSSortDescriptor *value = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
        [durationArray sortUsingDescriptors:[NSArray arrayWithObjects:value, nil]];
        
        self.navigationItem.title = @"";
        ScheduleAppointmentViewController *controller = [[ScheduleAppointmentViewController alloc] initWithNibName:@"ScheduleAppointmentViewController" bundle:nil];
        controller.durationArray = durationArray;
        controller.isBookLive    = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction) handleScheduleAppointment:(id)sender {
    BOOL isLoggedIn = [[ToolClass instance] isLogin];
    
    if (!isLoggedIn) {
        [(BrowseViewController*)parent leftButtonPress];
        
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Sign In Required" message:@"Please sign in to continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    //init duration array for this expert
    NSDictionary *durationDict = [expertDict objectForKey:@"durations"];
    NSMutableArray *durationArray = [NSMutableArray arrayWithCapacity:1];
    
    for (int i=0;i < [[durationDict allKeys] count];i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[durationDict allValues] objectAtIndex:i],@"title",[[durationDict allKeys] objectAtIndex:i],@"value", nil];
        [durationArray addObject:dict];
    }
    
    NSSortDescriptor *value = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
    [durationArray sortUsingDescriptors:[NSArray arrayWithObjects:value, nil]];
    
    self.navigationItem.title = @"";
    ScheduleAppointmentViewController *controller = [[ScheduleAppointmentViewController alloc] initWithNibName:@"ScheduleAppointmentViewController" bundle:nil];
    controller.durationArray = durationArray;
    controller.freeSessionDuration = self.freeSession;
    
    if (sender == self.btnSchedule) {
        controller.isFreeSession = NO;
    }
    else {
        controller.isFreeSession = YES;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) selectDescription:(id)sender {
    if (isSelectDescription)
        return;
    isSelectDescription = YES;
    //disable touch for this button and enable for another button
    self.btnDescription.userInteractionEnabled = NO;
    self.btnReview.userInteractionEnabled   = YES;
    
    [self.btnDescription setSelected:YES];
    [self.btnDescription setImage:[UIImage imageNamed:@"iconCategoryArrowDown.png"] forState:UIControlStateSelected];
    [self.btnDescription setImageEdgeInsets:UIEdgeInsetsMake(0, 50, -50, 0)];
    
    [self.btnReview setSelected:NO];
    [self.btnReview setImage:nil forState:UIControlStateNormal];
    
    [self.tableView reloadData];
    [self.tableView openSection:0 animated:NO];
    [self.tableView openSection:1 animated:NO];
    [self.tableView openSection:2 animated:NO];
}

- (IBAction) selectReview:(id)sender {
    if (!isSelectDescription)
        return;
    isSelectDescription = NO;
    //disable touch for this button and enable for another button
    self.btnDescription.userInteractionEnabled = YES;
    self.btnReview.userInteractionEnabled   = NO;
    
    [self.btnReview setSelected:YES];
    [self.btnReview setImage:[UIImage imageNamed:@"iconCategoryArrowDown.png"] forState:UIControlStateSelected];
    [self.btnReview setImageEdgeInsets:UIEdgeInsetsMake(0, 50, -50, 0)];
    
    [self.btnDescription setSelected:NO];
    [self.btnDescription setImage:nil forState:UIControlStateNormal];

    //for test
//    self.expertId = 12;
    [self reloadExpertReviews];
}

- (CAShapeLayer*) addBorderLineWithFrame:(CGRect)rect top:(BOOL)isTop bottom:(BOOL)isBottom left:(BOOL)isLeft right:(BOOL)isRight {
    UIBezierPath* borderPath = [UIBezierPath bezierPath];
    CAShapeLayer *strokeLayer = [CAShapeLayer layer];
    if (isTop && isLeft && isRight && !isBottom) {
        [borderPath moveToPoint:CGPointMake(0, rect.size.height)];
        [borderPath addLineToPoint:CGPointMake(0, rect.size.height-CORNER_RADIUS)];
        [borderPath addArcWithCenter:CGPointMake(CORNER_RADIUS, CORNER_RADIUS) radius:CORNER_RADIUS startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
        [borderPath addLineToPoint:CGPointMake(rect.size.width-CORNER_RADIUS, 0)];
        [borderPath addArcWithCenter:CGPointMake(rect.size.width-CORNER_RADIUS, CORNER_RADIUS) radius:CORNER_RADIUS startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        [borderPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
        
        strokeLayer.path = borderPath.CGPath;
        strokeLayer.fillColor = [UIColor clearColor].CGColor;
        strokeLayer.strokeColor = LIGHT_GREY_COLOR.CGColor;
        strokeLayer.lineWidth = 1; // the stroke splits the width evenly inside and outside,
        // but the outside part will be clipped by the containerView’s mask.

    }
    else if (!isTop && isBottom && isLeft && isRight) {
        [borderPath moveToPoint:CGPointMake(0, 0)];
        [borderPath addLineToPoint:CGPointMake(0, rect.size.height-CORNER_RADIUS)];
        [borderPath addArcWithCenter:CGPointMake(CORNER_RADIUS, rect.size.height-CORNER_RADIUS) radius:CORNER_RADIUS startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
        [borderPath addLineToPoint:CGPointMake(rect.size.width-CORNER_RADIUS, rect.size.height)];
        [borderPath addArcWithCenter:CGPointMake(rect.size.width-CORNER_RADIUS, rect.size.height-CORNER_RADIUS) radius:CORNER_RADIUS startAngle:M_PI_2 endAngle:0 clockwise:NO];
        [borderPath addLineToPoint:CGPointMake(rect.size.width, 0)];
        
        strokeLayer.path = borderPath.CGPath;
        strokeLayer.fillColor = [UIColor clearColor].CGColor;
        strokeLayer.strokeColor = LIGHT_GREY_COLOR.CGColor;
        strokeLayer.lineWidth = 1; // the stroke splits the width evenly inside and outside,
        // but the outside part will be clipped by the containerView’s mask.

    }
    else if (isTop && isBottom && isLeft && isRight) {
        [borderPath moveToPoint:CGPointMake(0, 0)];
        [borderPath addLineToPoint:CGPointMake(0, rect.size.height-CORNER_RADIUS)];
        [borderPath addArcWithCenter:CGPointMake(CORNER_RADIUS, rect.size.height-CORNER_RADIUS) radius:CORNER_RADIUS startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
        [borderPath addLineToPoint:CGPointMake(rect.size.width-CORNER_RADIUS, rect.size.height)];
        [borderPath addArcWithCenter:CGPointMake(rect.size.width-CORNER_RADIUS, rect.size.height-CORNER_RADIUS) radius:CORNER_RADIUS startAngle:M_PI_2 endAngle:0 clockwise:NO];
        [borderPath addLineToPoint:CGPointMake(rect.size.width, CORNER_RADIUS)];
        [borderPath addArcWithCenter:CGPointMake(rect.size.width-CORNER_RADIUS, CORNER_RADIUS) radius:CORNER_RADIUS startAngle:0 endAngle:-M_PI_2 clockwise:NO];
        [borderPath addLineToPoint:CGPointMake(CORNER_RADIUS, 0)];
        [borderPath addArcWithCenter:CGPointMake(CORNER_RADIUS, CORNER_RADIUS) radius:CORNER_RADIUS startAngle:-M_PI_2 endAngle:M_PI clockwise:NO];
        
        strokeLayer.path = borderPath.CGPath;
        strokeLayer.fillColor = [UIColor clearColor].CGColor;
        strokeLayer.strokeColor = LIGHT_GREY_COLOR.CGColor;
        strokeLayer.lineWidth = 1; // the stroke splits the width evenly inside and outside,
        // but the outside part will be clipped by the containerView’s mask.
    }
    else if (!isTop && !isBottom && isLeft && isRight) {
        [borderPath moveToPoint:CGPointMake(0, 0)];
        [borderPath addLineToPoint:CGPointMake(0, rect.size.height)];
        [borderPath moveToPoint:CGPointMake(rect.size.width, rect.size.height)];
        [borderPath addLineToPoint:CGPointMake(rect.size.width, 0)];
        
        strokeLayer.path = borderPath.CGPath;
        strokeLayer.fillColor = [UIColor clearColor].CGColor;
        strokeLayer.strokeColor = LIGHT_GREY_COLOR.CGColor;
        strokeLayer.lineWidth = 0.5;
    }
    return strokeLayer;
}

@end