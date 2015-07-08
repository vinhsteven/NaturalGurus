//
//  AvailabilityViewController.h
//  NaturalGurus
//
//  Created by Steven Pham on 6/22/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCollapseTableView.h"

@interface AvailabilityViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    CGSize screenSize;
    NSMutableArray *mainArray;
    
    NSDate *fromDate;
    NSDate *toDate;

    BOOL isFirstLoading;
}

@property (unsafe_unretained) id parent;
@property (strong, nonatomic) IBOutlet UILabel *lbInstructionTitle;
@property (strong, nonatomic) IBOutlet  STCollapseTableView *mainTableView;
@property (strong, nonatomic) NSMutableArray* data;
@property (strong, nonatomic) NSMutableArray* headers;
@property (strong, nonatomic) NSString *timezoneValueString;
@property (assign, readwrite) int duration;
@property (assign, readwrite) BOOL isFree;
@property (assign, readwrite) BOOL isLoading;

- (void) reorganizeAvailabilities:(NSDictionary*)dataDict;

@end
