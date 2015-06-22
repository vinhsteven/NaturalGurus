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
}

@property (strong, nonatomic) IBOutlet UILabel *lbInstructionTitle;
@property (strong, nonatomic) IBOutlet  STCollapseTableView *mainTableView;
@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic, strong) NSMutableArray* headers;

@end
