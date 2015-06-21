//
//  DashboardViewController.h
//  NaturalGurus
//
//  Created by Steven on 6/16/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    CGSize screenSize;
    NSMutableArray *mainArray;
}

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@end
