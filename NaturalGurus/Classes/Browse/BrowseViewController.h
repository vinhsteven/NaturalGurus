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
#import "TableView+RefreshControl.h"

enum {
    byTheLatest = 0,
    byCategory,
    byFilter,
    bySearch
};

@interface BrowseViewController : UIViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate> {
    CGSize screenSize;
    NSMutableArray *expertArray;
    NSMutableArray *categoryArray;
    NSMutableArray *searchArray;
    
    CGPoint originalPointCategories;
    CGPoint originalPointExperts;
    
    BOOL isSelectCategory;
    BOOL isSearching;
//    BOOL byTheLatest;   //for checking current expert list by latest
//    BOOL byCategory;    //for checking current expert list by category
    int currentList;
    int currentCategoryIndex;
    int currentFilterIndex;
    
    NSMutableArray *filterArray;
    NSMutableArray *sortArray;
}

@property (assign, readwrite) int currentPage;
@property (assign, readwrite) int lastPage;
@property (assign, readwrite) BOOL isLoading;
@property (strong, nonatomic) IBOutlet TableView_RefreshControl *mainTableView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIButton *btnCategory;
@property (strong, nonatomic) IBOutlet UIButton *btnExpert;
@property (strong, nonatomic) IBOutlet UIButton *btnSorting;

- (IBAction) selectCategories:(id)sender;
- (IBAction) selectExperts:(id)sender;
- (IBAction) handleSorting:(id)sender;

- (void) reorganizeExpertArray:(NSArray*)array;
- (void) reorganizeCategoryArray:(NSArray*)array;

@end

#endif
