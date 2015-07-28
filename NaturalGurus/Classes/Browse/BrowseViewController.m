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
@synthesize currentPage;
@synthesize lastPage;
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
    [btnRight addTarget:self action:@selector(handleFilter) forControlEvents:UIControlEventTouchUpInside];
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
    
    //style for Order button
    self.btnSorting.layer.cornerRadius = self.btnSorting.frame.size.height/2;
    self.btnSorting.layer.masksToBounds = YES;
    self.btnSorting.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnSorting.layer.borderWidth = 1;
    
    [self.btnSorting setBackgroundImage:[ToolClass imageFromColor:TABLE_BACKGROUND_COLOR] forState:UIControlStateNormal];
    
    //set row table height
    self.mainTableView.rowHeight = 138;
    self.mainTableView.separatorColor = [UIColor clearColor];
    self.mainTableView.backgroundColor = TABLE_BACKGROUND_COLOR;
    [self.mainTableView.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    
    //default is expert
    isSelectCategory = YES;
    [self selectExperts:nil];
    
    
    //init expert array data
    expertArray = [NSMutableArray arrayWithCapacity:1];
    
    //init category array
    categoryArray = [NSMutableArray arrayWithCapacity:1];
    
    //init filter array
    filterArray = [NSMutableArray arrayWithCapacity:1];
    NSString *filterTitle[] = {
        @"Available now (live)",
        @"Free sessions"
    };
    
    for (int i=0;i < sizeof(filterTitle)/sizeof(filterTitle[0]);i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:filterTitle[i],@"title",[NSNumber numberWithInt:i],@"value", nil];
        [filterArray addObject:dict];
    }
    
    //init sort array
    sortArray = [NSMutableArray arrayWithCapacity:1];
    NSString *sortTitle[] = {
        @"Price (highest to lowest)",
        @"Experience (highest to lowest)"
    };
    for (int i=0;i < sizeof(sortTitle)/sizeof(sortTitle[0]);i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:sortTitle[i],@"title",[NSNumber numberWithInt:i],@"value", nil];
        [sortArray addObject:dict];
    }
    
    searchArray = [NSMutableArray arrayWithCapacity:1];
    
    isLoading = NO;
    [self reloadTheLatestExpert];
    [self performSelectorInBackground:@selector(loadCategories) withObject:nil];
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

- (void) loadCategories {
    [[ToolClass instance] loadCategoriesWithViewController:self];
}

- (void) handleRefresh {
    if (!isSelectCategory) {
        [self.mainTableView.refreshControl endRefreshing];
        [self reloadTheLatestExpert];
        [self.mainTableView reloadData];
    }
    else {
        [self.mainTableView.refreshControl endRefreshing];
    }
}

- (void) reloadTheLatestExpert {
    //reset Order by title
    [self.btnSorting setTitle:@"Order by" forState:UIControlStateNormal];
    [self.btnCategory setTitle:@"CATEGORIES" forState:UIControlStateNormal];
    
    currentList = byTheLatest;
    currentPage = 1;
    [expertArray removeAllObjects];
    [self loadTheLastestExpert];
}

- (void) loadTheLastestExpert {
    isLoading = YES;
    [[ToolClass instance] loadTheLatestExperts:currentPage withViewController:self];
}

- (void) reloadExpertByCategory:(int)categoryId {
    currentList = byCategory;
    currentPage = 1;
    [expertArray removeAllObjects];
    [self loadExpertByCategory:categoryId];
}

- (void) loadExpertByCategory:(int)categoryId {
    isLoading = YES;
    [[ToolClass instance] loadExpertByCategory:categoryId pageIndex:currentPage withViewController:self];
}

- (void) reloadExpertByFilter:(int)_index {
    //use for first load
    currentList = byFilter;
    currentPage = 1;
    [expertArray removeAllObjects];
    [self loadExpertByFilter:_index];
}

- (void) loadExpertByFilter:(int)_index {
    //use for load more
    isLoading = YES;
    [[ToolClass instance] loadExpertByFilter:_index pageIndex:currentPage withViewController:self];
}

- (void) reloadExpertBySorting:(int)_index {
    //use for first load
    currentList = bySorting;
    currentPage = 1;
    [expertArray removeAllObjects];
    [self loadExpertBySorting:_index];
}

- (void) loadExpertBySorting:(int)_index {
    //use for load more
    isLoading = YES;
    [[ToolClass instance] loadExpertBySorting:_index pageIndex:currentPage withViewController:self];
}

- (void) reloadExpertBySearchString:(NSString*)searchStr {
    currentList = bySearch;
    currentPage = 1;
    [searchArray removeAllObjects];
    [self loadExpertBySearchString:searchStr];
}

- (void) loadExpertBySearchString:(NSString*)searchStr {
    isLoading = YES;
    [[ToolClass instance] loadExpertBySearchString:searchStr pageIndex:currentPage withViewController:self];
}

- (void) reorganizeExpertArray:(NSArray*)array {
    NSMutableArray *tmpArray;
    unsigned long startIndex;
    UITableView *tmpTableView;
    
    if (!isSearching) {
        startIndex  = [expertArray count];
        tmpArray    = expertArray;
        tmpTableView = self.mainTableView;
    }
    else {
        startIndex  = [searchArray count];
        tmpArray    = searchArray;
        tmpTableView = self.searchDisplayController.searchResultsTableView;
    }
    
    unsigned long endIndex   = startIndex + [array count];
    
    //reorganize expert array after requesting, and add to current expert array
    for (int i=0;i < [array count];i++) {
        NSDictionary *dict = [array objectAtIndex:i];
        
        long expertId       = [[dict objectForKey:@"id"] longValue];
        int rating          = [[dict objectForKey:@"rating"] intValue];
        NSString *avatar    = [dict objectForKey:@"avatar"];
        BOOL isOnline       = [[dict objectForKey:@"online"] boolValue];
        NSString *price     = [dict objectForKey:@"price"];
        NSString *title     = [dict objectForKey:@"title"];
        NSString *name      = [dict objectForKey:@"name"];

        NSString *intro     = [dict objectForKey:@"intro"];
        NSString *joinedDate  = [dict objectForKey:@"join_date"];
        
        //add %20 if there are some space in link
        avatar = [avatar stringByReplacingOccurrencesOfString:@" " withString:@"\%20"];
        
        //process html format string in description
//        NSString *description   = [dict objectForKey:@"description"];
//        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

        
        NSDictionary *tmpDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:expertId],@"expertId",avatar,@"imageUrl",name,@"expertName",title,@"serviceName",intro,@"description",price,@"durationPrice",[NSNumber numberWithBool:isOnline],@"status",[NSNumber numberWithInt:rating],@"rating",joinedDate,@"joinDate",[dict objectForKey:@"free_session"],@"free_session", nil];
        [tmpArray addObject:tmpDict];
    }
    
    //hide hud progress
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
    currentPage++;
    isLoading = NO;
    
    if ([tmpArray count] == [array count]) {
        [tmpTableView reloadData];
    }
    else {
        //show drop down animation effect
        NSMutableArray* indexPathsToInsert = [NSMutableArray arrayWithCapacity:1];
        
        for (unsigned long i=startIndex;i < endIndex;i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [tmpTableView beginUpdates];
        [tmpTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationTop];
        [tmpTableView endUpdates];
    }
}

- (void) reorganizeCategoryArray:(NSArray*)array {
    for (int i=0;i < [array count];i++) {
        NSDictionary *dict = [array objectAtIndex:i];
        
        int categoryId = [[dict objectForKey:@"id"] intValue];
        NSString *name = [dict objectForKey:@"name"];
        NSString *thumbnail = [dict objectForKey:@"thumbnail"];
        
        //add %20 if there are some space in link
        thumbnail = [thumbnail stringByReplacingOccurrencesOfString:@" " withString:@"\%20"];
        
        NSDictionary *tmpDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:categoryId],@"categoryId",name,@"categoryTitle",thumbnail,@"categoryImage", nil];
        [categoryArray addObject:tmpDict];
        
        //write image to file
        UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, CATEGORY_IMAGE_HEIGHT)];
        
        UIImageView *se = addView;
        
        [addView sd_setImageWithURL:[NSURL URLWithString:thumbnail]
                   placeholderImage:[UIImage imageNamed:@"avatarDefault.png"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *url) {
                              
                              se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(screenSize.width, CATEGORY_IMAGE_HEIGHT) source:image];
                              NSData *imageData = UIImageJPEGRepresentation(se.image, 1.0);
                              
                              NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                              NSString *documentsDirectory = [paths objectAtIndex:0];
                              NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, [NSString stringWithFormat:@"category_%d.jpg",categoryId]];
                              
                              [imageData writeToFile:filePath atomically:YES];
                          }];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    UITableView *tmpTableView;
    if (isSearching)
        tmpTableView = self.searchDisplayController.searchResultsTableView;
    else
        tmpTableView = self.mainTableView;
    // Check if we are at the bottom of the table
    // This will load more experts
    if (tmpTableView.contentOffset.y >= (tmpTableView.contentSize.height - tmpTableView.bounds.size.height))
    {
        //check for loading more the expert list
        if (!isLoading && currentPage <= lastPage && !isSelectCategory) {
            if (currentList == byTheLatest)
                [self loadTheLastestExpert];
            else if (currentList == byCategory) {
                if (currentCategoryIndex != 0)
                    [self loadExpertByCategory:currentCategoryIndex];
            }
            else if (currentList == byFilter) {
                [self loadExpertByFilter:currentFilterIndex];
            }
            else if (currentList == bySorting) {
                [self loadExpertBySorting:currentSortingIndex];
            }
            else if (currentList == bySearch) {
                [self loadExpertBySearchString:self.searchDisplayController.searchBar.text];
            }
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
    if (isSelectCategory)
        return [categoryArray count];
    else {
        if (tableView != self.searchDisplayController.searchResultsTableView) {
            int totalRecord = (int)[expertArray count];
            //if don't have record, add 1 row to show title No Expert is available
            if (totalRecord == 0)
                return 1;
            return [expertArray count];
        }
        else {
            int totalRecord = (int)[searchArray count];
            //if don't have record, add 1 row to show title No Expert is available
            if (totalRecord == 0)
                return 1;
            return [searchArray count];
        }
    }
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
        int totalRecord;
        NSMutableArray *tmpArray;
        
        if (tableView != self.searchDisplayController.searchResultsTableView) {
            totalRecord = (int)[expertArray count];
            tmpArray = expertArray;
        }
        else {
            totalRecord = (int)[searchArray count];
            tmpArray = searchArray;
        }
        
        if (totalRecord > 0) {
            NSDictionary *dict = [tmpArray objectAtIndex:indexPath.row];
            
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
                       placeholderImage:[UIImage imageNamed:@"avatarDefault.png"]
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
//            lbDescription.attributedText = [dict objectForKey:@"description"];
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
            UILabel *lbDuration = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width-85, 3, 75, 20)];
            lbDuration.backgroundColor = [UIColor clearColor];
            lbDuration.text = [NSString stringWithFormat:@"$%@/min",[dict objectForKey:@"durationPrice"]];
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
            
            int freeSession = [[dict objectForKey:@"free_session"] intValue];
            if (freeSession > 0) {
                UIButton *lbFreeSession = [UIButton buttonWithType:UIButtonTypeCustom];
                lbFreeSession.frame = CGRectMake(95, 5, 85, 15);
                [lbFreeSession setBackgroundImage:[UIImage imageNamed:@"bgFreeSession.png"] forState:UIControlStateNormal];
                [lbFreeSession setTitle:[NSString stringWithFormat:@"Free %d mins call",freeSession] forState:UIControlStateNormal];
                [lbFreeSession setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                lbFreeSession.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:10];
                lbFreeSession.userInteractionEnabled = NO;
                [bottomView addSubview:lbFreeSession];
            }
            
            [bgView addSubview:bottomView];
            
            [cell.contentView addSubview:bgView];
        }
        else {
            if (!isLoading) {
                UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenSize.width-20, 40)];
                lbTitle.backgroundColor = [UIColor colorWithRed:(float)245/255 green:(float)245/255 blue:(float)245/255 alpha:1];
                lbTitle.font = [UIFont fontWithName:DEFAULT_FONT size:13];
                lbTitle.text = @"There isn't any records here.";
                lbTitle.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:lbTitle];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        NSDictionary *dict = [categoryArray objectAtIndex:indexPath.row];
        
        int categoryId = [[dict objectForKey:@"categoryId"] intValue];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, [NSString stringWithFormat:@"category_%d.jpg",categoryId]];
        
        UIImage *categoryImage = [UIImage imageWithContentsOfFile:filePath];
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, CATEGORY_IMAGE_HEIGHT)];
        [bgView setImage:categoryImage];
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
        NSMutableDictionary *dict;
        if (!isSearching)
            dict = [expertArray objectAtIndex:indexPath.row];
        else
            dict = [searchArray objectAtIndex:indexPath.row];
        
        DetailBrowseViewController *controller = [[DetailBrowseViewController alloc] initWithNibName:@"DetailBrowseViewController" bundle:nil];
        controller.expertId     = [[dict objectForKey:@"expertId"] longValue];
//        controller.expertDescriptionString = [dict objectForKey:@"description"];
        controller.freeSession = [[dict objectForKey:@"free_session"] intValue];
        [[ToolClass instance] setExpertId:controller.expertId];
        controller.parent = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        [self.btnSorting setTitle:@"Order by" forState:UIControlStateNormal];
        
        NSDictionary *dict = [categoryArray objectAtIndex:indexPath.row];
        currentCategoryIndex = [[dict objectForKey:@"categoryId"] intValue];
        
        [self.btnCategory setTitle:[dict objectForKey:@"categoryTitle"] forState:UIControlStateNormal];
        
        [self reloadExpertByCategory:currentCategoryIndex];
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

#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    //when user tap search button, we start searching
    [self reloadExpertBySearchString:searchBar.text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    [expertArray removeAllObjects];
    currentList = bySearch;
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //detect if user cancel searching, we remove all searchArray and reload the latest list
    if (!isSearching) {
        [searchArray removeAllObjects];
    
        //return to the latest expert list
        [self reloadTheLatestExpert];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![text isEqualToString:@""] && searchBar.text.length > 1)
        isSearching = YES;
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //if user tap cancel or x button to cancel searching, set isSearching = NO to tell that we will end searching.
    if ([searchText isEqualToString:@""]) {
        isSearching = NO;
    }
    else {
        [searchArray removeAllObjects];
        //loop all current expert array and add element satisfy searchText to searchArray
        for (int i=0;i < [expertArray count];i++) {
            NSDictionary *dict = [expertArray objectAtIndex:i];
            NSString *name  = [dict objectForKey:@"expertName"];
            NSString *title = [dict objectForKey:@"serviceName"];
            
            name  = [name lowercaseString];
            title = [title lowercaseString];
            searchText = [searchText lowercaseString];
            
            if ([name rangeOfString:searchText].location != NSNotFound || [title rangeOfString:searchText].location != NSNotFound) {
                [searchArray addObject:dict];
            }
        }
        [self.mainTableView reloadData];
    }
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

- (void) handleFilter {
    [MMPickerView showPickerViewInView:self.view
                           withObjects:filterArray
                           withOptions:nil
                            completion:^(NSInteger selectedIndex) {
                                [self.btnCategory setTitle:@"CATEGORIES" forState:UIControlStateNormal];
                                [self.btnSorting setTitle:@"Order by" forState:UIControlStateNormal];
                                
                                //return selected index
                                currentFilterIndex = (int)selectedIndex;
                                [self reloadExpertByFilter:currentFilterIndex];
                            }];
}

- (IBAction) handleSorting:(id)sender {
    [MMPickerView showPickerViewInView:self.view
                           withObjects:sortArray
                           withOptions:nil
                            completion:^(NSInteger selectedIndex) {
                                [self.btnCategory setTitle:@"CATEGORIES" forState:UIControlStateNormal];
                                
                                //return selected index
                                currentSortingIndex = (int)selectedIndex;
                                
                                if (currentSortingIndex)
                                    [self.btnSorting setTitle:@"Experience" forState:UIControlStateNormal];
                                else
                                    [self.btnSorting setTitle:@"Price" forState:UIControlStateNormal];
                                
                                [self reloadExpertBySorting:currentSortingIndex];
                            }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end