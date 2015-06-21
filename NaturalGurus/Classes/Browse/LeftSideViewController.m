//
//  LeftSideViewController.m
//  iTag
//
//  Created by Steven on 4/16/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import "LeftSideViewController.h"
#import "MMDrawerController.h"
#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "MyProfileViewController.h"

@interface LeftSideViewController ()

@end

@implementation LeftSideViewController
@synthesize parent;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)prefersStatusBarHidden{
    return HIDE_STATUS_BAR;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Menu";
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height-1,self.navigationController.navigationBar.frame.size.width, 1)];
    
    // Change the frame size to suit yours //
    
    [navBorder setBackgroundColor:LINE_COLOR];
    [navBorder setOpaque:YES];
    [self.navigationController.navigationBar addSubview:navBorder];
    
    mainArray = [NSMutableArray arrayWithCapacity:1];
    
    NSString *imageTitle[] = {
        @"icon_dashboard.png",
        @"icon_home.png",
        @"icon_small_application.png",
        @"icon_small_resume.png",
    };
    
    NSString *titleStr[] = {
        @"Dashboard",
        @"Browse",
        @"My Profile",
        @"Log Out"
    };
    
    for (int i=0;i < sizeof(imageTitle)/sizeof(imageTitle[0]);i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],@"index",titleStr[i],@"title",imageTitle[i],@"image", nil];
        [mainArray addObject:dict];
    }
    
    self.tableView.backgroundColor = TABLEVIEW_BACKGROUND_COLOR;
    self.tableView.separatorColor  = [UIColor clearColor];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    int index = [[dict objectForKey:@"index"] intValue];
    
//    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[dict objectForKey:@"image"]]];
//    switch (index) {
//        case kHomeTag:
//            img.frame = CGRectMake(10, 10, 28, 22);
//            break;
//        case kApplicationTag:
//            img.frame = CGRectMake(10, 10, 24, 33);
//            break;
//        case kResumeTag:
//            img.frame = CGRectMake(10, 10, 20, 27);
//            break;
//        case kSearchJobTag:
//            img.frame = CGRectMake(10, 10, 22, 26);
//            break;
//        case kSavedJobsTag:
//            img.frame = CGRectMake(10, 10, 25, 21);
//            break;
//        case kSignOutTag:
//            img.frame = CGRectMake(10, 10, 23, 25);
//            break;
//        default:
//            break;
//    }
//    
//    [cell.contentView addSubview:img];
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 150, 21)];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.textColor = TEXT_COLOR;
    lbTitle.text = [dict objectForKey:@"title"];
    [cell.contentView addSubview:lbTitle];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    int index = [[dict objectForKey:@"index"] intValue];
    NSLog(@"controller = %@",((LoginViewController*)parent).centerViewController);

    switch (index) {
        case kLogOutTag:
            [((LoginViewController*)parent).drawerController.navigationController popViewControllerAnimated:YES];
            break;
        case kDashboardTag:
        {
            DashboardViewController *controller = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
            
            UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
            naviController.navigationBar.barStyle = UIBarStyleBlack;
            [self.mm_drawerController
             setCenterViewController:naviController
             withCloseAnimation:YES
             completion:nil];
            break;
        }
        case kBrowseTag:
        {
            BrowseViewController *controller = [[BrowseViewController alloc] initWithNibName:@"BrowseViewController" bundle:nil];
            
            UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
            naviController.navigationBar.barStyle = UIBarStyleBlack;
            [self.mm_drawerController
             setCenterViewController:naviController
             withCloseAnimation:YES
             completion:nil];
            break;
        }
        case kProfileTag:
        {
            MyProfileViewController *controller = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
            
            UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
            naviController.navigationBar.barStyle = UIBarStyleBlack;
            [self.mm_drawerController
             setCenterViewController:naviController
             withCloseAnimation:YES
             completion:nil];
            break;
        }
        default:
            break;
    }
}

@end
