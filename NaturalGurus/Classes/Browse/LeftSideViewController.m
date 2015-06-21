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

-(BOOL)prefersStatusBarHidden{
    return HIDE_STATUS_BAR;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height-1,self.navigationController.navigationBar.frame.size.width, 1)];
    
    // Change the frame size to suit yours //
    
    [navBorder setBackgroundColor:LINE_COLOR];
    [navBorder setOpaque:YES];
    [self.navigationController.navigationBar addSubview:navBorder];
    
    mainArray = [NSMutableArray arrayWithCapacity:1];
    
    self.lbTitle.font = [UIFont fontWithName:MONTSERRAT_BOLD size:16];
    self.lbTitle.textColor = GREEN_COLOR;
    
    self.btnLogout.titleLabel.font = [UIFont fontWithName:MONTSERRAT_BOLD size:13];
    
    NSString *imageTitle[] = {
        @"iconDashboard.png",
        @"iconBrowse.png",
        @"iconProfile.png",
    };
    
    NSString *titleStr[] = {
        @"DASHBOARD",
        @"BROWSE",
        @"PROFILE",
    };
    
    for (int i=0;i < sizeof(imageTitle)/sizeof(imageTitle[0]);i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],@"index",titleStr[i],@"title",imageTitle[i],@"image", nil];
        [mainArray addObject:dict];
    }
    
    self.tableView.backgroundColor = [UIColor colorWithRed:(float)38/255 green:(float)38/255 blue:(float)38/255 alpha:1.0];
    self.tableView.rowHeight = 48;
//    self.tableView.separatorColor  = [UIColor clearColor];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    int index = [[dict objectForKey:@"index"] intValue];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[dict objectForKey:@"image"]]];
    switch (index) {
        case kDashboardTag:
            img.frame = CGRectMake(28, 15, 16, 16);
            break;
        case kBrowseTag:
            img.frame = CGRectMake(28, 15, 13, 16);
            break;
        case kProfileTag:
            img.frame = CGRectMake(28, 15, 15, 16);
            break;
        default:
            break;
    }
    
    [cell.contentView addSubview:img];
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(56, 15, 150, 21)];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.font = [UIFont fontWithName:MONTSERRAT_BOLD size:14];
    lbTitle.textColor = [UIColor whiteColor];
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

- (IBAction) handleLogout:(id)sender {
    [((LoginViewController*)parent).drawerController.navigationController popViewControllerAnimated:YES];
}

@end
