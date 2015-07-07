//
//  DetailBrowseViewController.h
//  NaturalGurus
//
//  Created by Steven on 6/13/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#ifndef NaturalGurus_DetailBrowseViewController_h
#define NaturalGurus_DetailBrowseViewController_h

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "STCollapseTableView.h"
#import "EDStarRating.h"

@interface DetailBrowseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    CGSize screenSize;
    BOOL isSelectDescription;
}

@property (assign, readwrite) int currentPage;
@property (assign, readwrite) int lastPage;
@property (assign, readwrite) BOOL isLoading;
@property (assign, readwrite) int totalReview;
@property (weak, nonatomic) NSMutableDictionary *expertDict;
@property (assign, readwrite) long expertId;
@property (strong, nonatomic) NSString *expertDescriptionString;    //reuse from previous screen, because it take too long time to creat HTML string
@property (strong, nonatomic) IBOutlet UILabel *lbDuration;
@property (strong, nonatomic) IBOutlet UIImageView *imgStatusView;
@property (strong, nonatomic) IBOutlet UIImageView *imgExpertView;
@property (strong, nonatomic) IBOutlet UILabel *lbServiceName;

@property (weak, nonatomic) IBOutlet STCollapseTableView *tableView;
@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic, strong) NSMutableArray* headers;
@property (strong, nonatomic) IBOutlet EDStarRating *starRatingView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *btnDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnReview;
@property (strong, nonatomic) IBOutlet UIButton *btnBookLive;
@property (strong, nonatomic) IBOutlet UIButton *btnSchedule;
@property (strong, nonatomic) IBOutlet UIView *myFrontView;

//for Review section
@property (strong, nonatomic) NSMutableArray *reviewData;
@property (strong, nonatomic) NSMutableArray *reviewHeaders;

- (IBAction) handleBookLive:(id)sender;
- (IBAction) handleScheduleAppointment:(id)sender;
- (IBAction) selectDescription:(id)sender;
- (IBAction) selectReview:(id)sender;

- (void) setUpStyleForReviewButton;
- (void) setupTableViewData;
- (void) reorganizeReviewArray:(NSArray*)array;

@end

#endif
