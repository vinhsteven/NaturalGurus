//
//  BrowseViewController.h
//  NaturalGurus
//
//  Created by Steven on 6/9/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#ifndef NaturalGurus_BrowseViewController_h
#define NaturalGurus_BrowseViewController_h

#import <UIKit/UIKit.h>
#import "TableView+RefreshControl.h"

enum {
    byTheLatest = 0,
    byCategory,
    byFilter,
    bySearch,
    bySorting
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
    int currentSortingIndex;
    
    NSMutableArray *filterArray;
    NSMutableArray *sortArray;
    
    UIButton *btnFilter; //filter button
}

@property (assign, readwrite) int currentPage;
@property (assign, readwrite) int lastPage;
@property (assign, readwrite) BOOL isLoading;
@property (strong, nonatomic) IBOutlet TableView_RefreshControl *mainTableView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIButton *btnCategory;
@property (strong, nonatomic) IBOutlet UIButton *btnExpert;
@property (strong, nonatomic) IBOutlet UIButton *btnSorting;

- (void) leftButtonPress;

- (IBAction) selectCategories:(id)sender;
- (IBAction) selectExperts:(id)sender;
- (IBAction) handleSorting:(id)sender;

- (void) reorganizeExpertArray:(NSArray*)array;
- (void) reorganizeCategoryArray:(NSArray*)array;

@end

#endif
