//
//  DashboardViewController.h
//  NaturalGurus
//
//  Created by Steven on 6/16/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableView+RefreshControl.h"

@interface DashboardViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    CGSize screenSize;
    NSMutableArray *mainArray;
}

@property (strong, nonatomic) IBOutlet TableView_RefreshControl *mainTableView;
@property (strong, nonatomic) IBOutlet UILabel *lbMyAppointments;

@end
