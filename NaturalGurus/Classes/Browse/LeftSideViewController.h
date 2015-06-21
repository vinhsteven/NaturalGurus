//
//  LeftSideViewController.h
//  iTag
//
//  Created by Steven on 4/16/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    kDashboardTag = 0,
    kBrowseTag,
    kProfileTag,
    kLogOutTag,
};

@interface LeftSideViewController : UITableViewController {
    NSMutableArray *mainArray;
}

@property (unsafe_unretained) id parent;
@end
