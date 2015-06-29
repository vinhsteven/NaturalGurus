//
//  BrowseViewController.m
//  NaturalGurus
//
//  Created by Steven on 6/9/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrowseViewController.h"
#import "UIImageView+WebCache.h"
#import "EDStarRating.h"
#import "DetailBrowseViewController.h"

@implementation BrowseViewController

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

-(BOOL)prefersStatusBarHidden{
    return HIDE_STATUS_BAR;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"";
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    //add bottom line of navigation bar
    [self addNavigationBottomLine];
    
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

    //right bar button
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 17, 20);
    [btnRight setImage:[UIImage imageNamed:@"btnFilter.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = btnItem2;
    
    self.navigationItem.rightBarButtonItems = @[leftSpacer, btnItem2, rightSpacer];

    //set style for container view
    self.containerView.backgroundColor = [UIColor whiteColor];
    
    //set style for category and expert button
    [self.btnCategory setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnCategory setTitleColor:GREEN_COLOR forState:UIControlStateHighlighted];
    [self.btnCategory setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    
    [self.btnExpert setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnExpert setTitleColor:GREEN_COLOR forState:UIControlStateHighlighted];
    [self.btnExpert setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    
    //set row table height
    self.mainTableView.rowHeight = 138;
    self.mainTableView.separatorColor = [UIColor clearColor];
    self.mainTableView.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    //default is expert
    isSelectCategory = YES;
    [self selectExperts:nil];
    
    
    //init expert array data
    expertArray = [NSMutableArray arrayWithCapacity:1];
    
    NSString *imgUrl[] = {
        @"https://naturalgurus.com/uploads/users/2015_06_11_08_05_56_Keith%20at%20Homeopathy%20For%20Kidscr.jpeg",
        @"http://tapchianhdep.com/wp-content/uploads/2015/04/hinh-anh-hoat-hinh-tom-and-jerry-dang-yeu-nhat-1.jpg"
    };
    
    NSString *expertName[] = {
        @"Keith Avedissian",
        @"Alan Phan"
    };
    
    NSString *serviceName[] = {
        @"Herbal remedies advices",
        @"Chronic disease"
    };
    
    NSString *description[] = {
        @"Lorem ip dsadvvs hhdshd dsjhdj dsjahdsj dsjhjda dhjahd dajhsdj dasjd ghhdhahd dsaghgdh dahsgd dhagdh ga hdghsadh dhgashdg hfjhsf fskfdsj fsdjfdj fdksjjkf fdksjfjk fds",
        @"Lorem ip dsadvvs hhdshd dsjhdj dsjahdsj dsjhjda dhjahd dajhsdj dasjd"
    };
    
    NSString *duration[] = {
        @"$2.80/pm",
        @"$3.50/pm"
    };
    
    NSString *status[] = {
        @"1",
        @"0"
    };
    
    NSString *rating[] = {
        @"3.0",
        @"2.5"
    };
    
    //init qualification data, use same data for every expert. In fact, number of qualification array depend on number of experts
    NSString *qualificationTitle[] = {
        @"Bachelore of Computer Science",
        @"Master of Computer Science"
    };
    NSString *qualificationYear[] = {
        @"2004-2009",
        @"2009-2011"
    };
    NSMutableArray *qualificationArray = [NSMutableArray arrayWithCapacity:1];
    for (int i=0;i < sizeof(qualificationTitle)/sizeof(qualificationTitle[0]);i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:qualificationTitle[i],@"qualificationTitle",qualificationYear[i],@"qualificationYear", nil];
        [qualificationArray addObject:dict];
    }
    //end qualification data
    
    //init Quick Stats data
    NSString *joinedDate[] = {
        @"May 2015",
        @"August 2016"
    };
    NSString *experience[] = {
        @"15+ years",
        @"2+ years"
    };
    NSString *level[] = {
        @"Practitioner",
        @"Practitioner"
    };
    NSString *sessions[] = {
        @"5",
        @"8"
    };
    NSString *minimumSession[] = {
        @"30 mins",
        @"20 mins"
    };
    NSString *maximumSession[] = {
        @"180 mins",
        @"120 mins"
    };
    NSString *association[] = {
        @"ANTA",
        @"Incipient Capital"
    };
    NSString *accrecditation[] = {
        @"7564",
        @"8723"
    };
    //end Quick Stats data
    
    for (int i=0;i < sizeof(imgUrl)/sizeof(imgUrl[0]);i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imgUrl[i],@"imageUrl",expertName[i],@"expertName",serviceName[i],@"serviceName",description[i],@"description",duration[i],@"durationPrice",status[i],@"status",rating[i],@"rating",qualificationArray,@"qualificationStats",joinedDate[i],EXPERT_JOINED_DATE,experience[i],EXPERT_EXPERIENCE,level[i],EXPERT_LEVEL,sessions[i],EXPERT_SESSION,minimumSession[i],EXPERT_MIN_SESSION,maximumSession[i],EXPERT_MAX_SESSION,association[i],EXPERT_ASSOCIATION,accrecditation[i],EXPERT_ACCREDITATION, nil];
        [expertArray addObject:dict];
    }
    
    //init category array
    categoryArray = [NSMutableArray arrayWithCapacity:1];
    
    NSString *categoryTitle[] = {
        @"WEIGHT LOSS",
        @"DETOX PLANS",
        @"SPIRITUAL",
        @"AROMATHERAPY",
        @"GENERAL HEALTH",
        @"DIET & LIFESTYLE"
    };
    
    for (int i=0;i < sizeof(categoryTitle)/sizeof(categoryTitle[0]);i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:categoryTitle[i],@"categoryTitle",[NSString stringWithFormat:@"category_%d",i],@"categoryImage", nil];
        [categoryArray addObject:dict];
    }
    
    //init filter array
    filterArray = [NSMutableArray arrayWithObjects:@"Filter 1",@"Filter 2",@"Filter 3", nil];
    sortArray   = [NSMutableArray arrayWithObjects:@"Sort by Name",@"Sort by the Latest",@"Sort by Rating", nil];
}

- (void) viewWillAppear:(BOOL)animated {
    
}

- (void) viewDidLayoutSubviews {
    originalPointCategories = self.btnCategory.center;
    originalPointExperts    = self.btnExpert.center;
    
    if (isSelectCategory) {
        self.btnCategory.center = CGPointMake(originalPointCategories.x+25, originalPointCategories.y);
        self.btnExpert.center = CGPointMake(originalPointExperts.x+50, originalPointExperts.y);
    }
}

- (void) addNavigationBottomLine {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenSize.width, 1)];
    view.backgroundColor = LIGHT_GREY_COLOR;
    [self.navigationController.navigationBar addSubview:view];
}

- (void) leftButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void) rightButtonPress {
    [MMPickerView showPickerViewInView:self.view
                           withStrings:filterArray
                           withOptions:nil
                            completion:^(NSString *selectedString) {
                                //selectedString is the return value which you can use as you wish
                                
                            }];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSelectCategory)
        return [categoryArray count];
    else
        return [expertArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSelectCategory) {
        return 79;
    }
    else {
        return 138;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if (!isSelectCategory) {
        NSDictionary *dict = [expertArray objectAtIndex:indexPath.row];
        
        //create background view cell
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, self.mainTableView.rowHeight-6)];
        bgView.tag = kBGVIEW_TAG;
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        bgView.layer.borderWidth = 1;
        bgView.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
        
        // add the expert image
        
        UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, EXPERT_IN_LIST_WIDTH, EXPERT_IN_LIST_HEIGHT)];
        
        UIImageView *se = addView;
        
        NSString *imgUrl = [dict objectForKey:@"imageUrl"];
        [addView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                   placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *url) {
                              
                              se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(EXPERT_IN_LIST_WIDTH, EXPERT_IN_LIST_HEIGHT) source:image];
                              
                          }];
        [addView.layer setCornerRadius:EXPERT_IN_LIST_WIDTH/2];
        [addView.layer setMasksToBounds:YES];
        [bgView addSubview:addView];
        
        //add icon status
        UIImageView *imgStatus = [[UIImageView alloc] initWithFrame:CGRectMake(30, 66, 58, 33)];
        [bgView addSubview:imgStatus];
        BOOL isOnline = [[dict objectForKey:@"status"] boolValue];
        if (isOnline) {
            [imgStatus setImage:[UIImage imageNamed:@"iconOnline.png"]];
        }
        else {
            [imgStatus setImage:[UIImage imageNamed:@"iconOffline.png"]];
        }
        
        
        //add expert name
        UILabel *lbExpertName = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, 200, 30)];
        lbExpertName.backgroundColor = [UIColor clearColor];
        lbExpertName.text = [dict objectForKey:@"expertName"];
        lbExpertName.textColor = GREEN_COLOR;
        lbExpertName.font = [UIFont fontWithName:MONTSERRAT_BOLD size:15];
        [bgView addSubview:lbExpertName];
        
        //add service name
        UILabel *lbServiceName = [[UILabel alloc] initWithFrame:CGRectMake(95, 35, 200, 20)];
        lbServiceName.backgroundColor = [UIColor clearColor];
        lbServiceName.text = [dict objectForKey:@"serviceName"];
        lbServiceName.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        [bgView addSubview:lbServiceName];
        
        //add description
        UILabel *lbDescription = [[UILabel alloc] initWithFrame:CGRectMake(95, 55, bgView.frame.size.width-100, 60)];
        lbDescription.backgroundColor = [UIColor clearColor];
        lbDescription.text = [dict objectForKey:@"description"];
        lbDescription.textColor = [UIColor darkGrayColor];
        lbDescription.font = [UIFont fontWithName:DEFAULT_FONT size:11];
        lbDescription.numberOfLines = 3;
        [lbDescription sizeToFit];
        [bgView addSubview:lbDescription];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 107, bgView.frame.size.width, 25)];
        bottomView.backgroundColor = GREEN_COLOR;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, bottomView.frame.size.width, bottomView.frame.size.height) byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path  = maskPath.CGPath;
        bottomView.layer.mask = maskLayer;
        
        //add duration
        UILabel *lbDuration = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width-75, 3, 65, 20)];
        lbDuration.backgroundColor = [UIColor clearColor];
        lbDuration.text = [dict objectForKey:@"durationPrice"];
        lbDuration.textColor = [UIColor whiteColor];
        lbDuration.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        lbDuration.textAlignment = NSTextAlignmentRight;
        [bottomView addSubview:lbDuration];
        
        //add rating star
        // Custom Number of Stars
        EDStarRating *customNumberOfStars = [[EDStarRating alloc] initWithFrame:CGRectMake(10, -3, 55, 32)];
        customNumberOfStars.backgroundImage = nil;
        customNumberOfStars.starImage = [UIImage imageNamed:@"star.png"];
        customNumberOfStars.starHighlightedImage = [UIImage imageNamed:@"star_highlighted.png"];
        customNumberOfStars.maxRating = 5.0;
        customNumberOfStars.horizontalMargin = 0;
        customNumberOfStars.editable    = NO;
        customNumberOfStars.rating      = [[dict objectForKey:@"rating"] floatValue];
        customNumberOfStars.displayMode = EDStarRatingDisplayAccurate;
        
        [bottomView addSubview:customNumberOfStars];
        
        [bgView addSubview:bottomView];
        
        [cell.contentView addSubview:bgView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        NSDictionary *dict = [categoryArray objectAtIndex:indexPath.row];
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 79)];
        [bgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[dict objectForKey:@"categoryImage"]]]];
        [cell.contentView addSubview:bgView];
        
        //add black translucent view
        UIView *frontView = [[UIView alloc] initWithFrame:bgView.frame];
        frontView.backgroundColor = [UIColor blackColor];
        frontView.alpha = 0.5;
        [cell.contentView addSubview:frontView];
        
        //add category label
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:bgView.frame];
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textColor = [UIColor whiteColor];
        lbTitle.text = [dict objectForKey:@"categoryTitle"];
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.font = [UIFont fontWithName:MONTSERRAT_REGULAR size:16];
        [cell.contentView addSubview:lbTitle];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isSelectCategory) {
        NSMutableDictionary *dict = [expertArray objectAtIndex:indexPath.row];
        
        DetailBrowseViewController *controller = [[DetailBrowseViewController alloc] initWithNibName:@"DetailBrowseViewController" bundle:nil];
        controller.expertDict = dict;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        [self selectExperts:nil];
    }
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

- (IBAction) selectCategories:(id)sender {
    if (isSelectCategory)
        return;
    isSelectCategory = YES;
    //disable touch for this button and enable for another button
    self.btnCategory.userInteractionEnabled = NO;
    self.btnExpert.userInteractionEnabled   = YES;
    
    self.btnSorting.hidden = YES;
    
    [self.btnCategory setSelected:YES];
    [self.btnCategory setImage:[UIImage imageNamed:@"iconCategoryArrowDown.png"] forState:UIControlStateSelected];
    [self.btnCategory setImageEdgeInsets:UIEdgeInsetsMake(0, 50, -50, 0)];
    
    [self.btnExpert setSelected:NO];
    [self.btnExpert setImage:nil forState:UIControlStateNormal];
    
    self.btnCategory.center = CGPointMake(originalPointCategories.x+25, originalPointCategories.y);
    self.btnExpert.center   = CGPointMake(originalPointExperts.x+50, originalPointExperts.y);
    
    [self.mainTableView reloadData];
}

- (IBAction) selectExperts:(id)sender {
    if (!isSelectCategory)
        return;
    isSelectCategory = NO;
    
    //disable touch for this button and enable for another button
    self.btnCategory.userInteractionEnabled = YES;
    self.btnExpert.userInteractionEnabled   = NO;
    
    self.btnSorting.hidden = NO;
    //restore cordinate
    self.btnCategory.center = originalPointCategories;
    self.btnExpert.center = originalPointExperts;
    
    [self.btnExpert setSelected:YES];
    [self.btnExpert setImage:[UIImage imageNamed:@"iconCategoryArrowDown.png"] forState:UIControlStateSelected];
    [self.btnExpert setImageEdgeInsets:UIEdgeInsetsMake(0, 40, -50, 0)];
    
    [self.btnCategory setSelected:NO];
    [self.btnCategory setImage:nil forState:UIControlStateNormal];
    
    [self.mainTableView reloadData];
}

- (IBAction) handleSorting:(id)sender {
    [MMPickerView showPickerViewInView:self.view
                           withStrings:sortArray
                           withOptions:nil
                            completion:^(NSString *selectedString) {
                                //selectedString is the return value which you can use as you wish
                                
                            }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end