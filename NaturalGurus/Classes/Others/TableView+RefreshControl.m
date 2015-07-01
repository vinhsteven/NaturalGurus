//
//  TableView+RefreshControl.m
//  NaturalGurus
//
//  Created by Steven Pham on 7/1/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "TableView+RefreshControl.h"

@implementation TableView_RefreshControl
@synthesize refreshControl;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    //add refresh control for UITableView
    self.refreshControl = [UIRefreshControl new];
//    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.refreshControl];
    [self sendSubviewToBack:self.refreshControl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
