//
//  BrowseViewController.h
//  NaturalGurus
//
//  Created by Steven on 6/9/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#ifndef NaturalGurus_BrowseViewController_h
#define NaturalGurus_BrowseViewController_h

#define EXPERT_JOINED_DATE      @"joinedDate"
#define EXPERT_EXPERIENCE       @"experience"
#define EXPERT_LEVEL            @"level"
#define EXPERT_SESSION          @"sessions"
#define EXPERT_MIN_SESSION      @"minimumSessions"
#define EXPERT_MAX_SESSION      @"maximumSessions"
#define EXPERT_ASSOCIATION      @"association"
#define EXPERT_ACCREDITATION    @"acrrecditation"

#import <UIKit/UIKit.h>

@interface BrowseViewController : UIViewController <UISearchControllerDelegate,UITableViewDataSource,UITableViewDelegate> {
    CGSize screenSize;
    NSMutableArray *expertArray;
    NSMutableArray *categoryArray;
    
    CGPoint originalPointCategories;
    CGPoint originalPointExperts;
    
    BOOL isSelectCategory;
    
    NSMutableArray *filterArray;
    NSMutableArray *sortArray;
}

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIButton *btnCategory;
@property (strong, nonatomic) IBOutlet UIButton *btnExpert;
@property (strong, nonatomic) IBOutlet UIButton *btnSorting;

- (IBAction) selectCategories:(id)sender;
- (IBAction) selectExperts:(id)sender;
- (IBAction) handleSorting:(id)sender;

@end

#endif
