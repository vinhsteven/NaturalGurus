//
//  LiveRequestListViewController.h
//  NaturalGurus
//
//  Created by Steven Pham on 7/22/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveRequestListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    BOOL isLoading;
}

@property (assign,readwrite) BOOL isOpening; //to prevent present when it's opening
@property (strong,nonatomic) IBOutlet UITableView *mainTableView;
@property (strong,nonatomic) NSMutableArray *mainArray;

+ (LiveRequestListViewController *) instance;
- (void) reloadLiveRequest;
- (void) reorganizeLiveRequest:(NSArray*)array;

- (void) approveLiveRequestSuccessful;
- (void) declineLiveRequestSuccessful:(NSDictionary*)request;

@end
