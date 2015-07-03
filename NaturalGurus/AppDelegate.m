//
//  AppDelegate.m
//  NaturalGurus
//
//  Created by Steven on 6/9/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "AppDelegate.h"

@implementation UINavigationController (Rotation_For_iOS6)

-(BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}


@end

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void) showMessage:(NSString*)message withTitle:(NSString*)title {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [dialog show];
}

- (void) userLoggedIn {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             NSLog(@"user id %@",user.objectID);
             NSLog(@"Email %@",[user objectForKey:@"email"]);
             NSLog(@"User Name: %@ %@ %@",[user objectForKey:@"first_name"],[user objectForKey:@"middle_name"],[user objectForKey:@"last_name"]);
             NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user.objectID];
             
             //update data to our server
             NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user objectForKey:@"email"],@"email",FBSession.activeSession.accessTokenData.accessToken,@"token",[user objectForKey:@"first_name"],@"firstname",[user objectForKey:@"last_name"],@"lastname", nil];
             
             NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
             
             AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
             manager.responseSerializer = [AFJSONResponseSerializer serializer];
             
             [manager POST:@"/api/v1/sign_in/social" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                 // 3
                 NSLog(@"response: %@",(NSDictionary*)responseObject);
                 //get status of request
                 int status = [[responseObject objectForKey:@"status"] intValue];
                 
                 if (status == 200) {
                     NSDictionary *data = [responseObject objectForKey:@"data"];
                     
                     NSString *defaultUserImg = [data objectForKey:@"avatar"];
                     //save current user logged in informations
                     //set current profile image
                     [[ToolClass instance] setLogin:YES];
                     
                     //check if is default image, use social image. If not use image from our server.
                     if ([defaultUserImg rangeOfString:@"default.png"].location == NSNotFound) {
                        [[ToolClass instance] setProfileImageURL:defaultUserImg];
                     }
                     else {
                         [[ToolClass instance] setProfileImageURL:userImageURL];
                     }

                     [[ToolClass instance] setUserFirstName:[data objectForKey:@"firstname"]];
                     [[ToolClass instance] setUserLastName:[data objectForKey:@"lastname"]];
                     [[ToolClass instance] setUserRole:isUser];
                     [[ToolClass instance] setUserToken:FBSession.activeSession.accessTokenData.accessToken];
                     [[ToolClass instance] setUserEmail:[user objectForKey:@"email"]];
                     
                     
                     [self.viewController loginSuccess];
                 }
                 else if (status == 401){
                     NSString *message = [responseObject objectForKey:@"message"];
                     UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [dialog show];
                     
                 }
                 
                 [MBProgressHUD hideAllHUDsForView:self.navController.view animated:YES];
                 
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 NSLog(@"FB failed: %@",error);
                 [MBProgressHUD hideAllHUDsForView:self.navController.view animated:YES];
             }];
         }
     }];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}

// Handles session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [[ToolClass instance] setLoginType:LOGIN_FACEBOOK];
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
//        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [AppDelegate showMessage:alertText withTitle:alertTitle];
        }
        else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [AppDelegate showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [AppDelegate showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
//        [self userLoggedOut];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *navigationTitleAttribute = [NSDictionary dictionaryWithObjectsAndKeys:GREEN_COLOR,
     NSForegroundColorAttributeName,
     GREEN_COLOR,
     NSForegroundColorAttributeName,
     [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
     NSForegroundColorAttributeName,
     [UIFont fontWithName:MONTSERRAT_BOLD size:16.0],
     NSFontAttributeName,nil];
    
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //color of back button
    [[UINavigationBar appearance] setTintColor:GREEN_COLOR];
    //color of navigation bar
    [[UINavigationBar appearance] setBarTintColor:NAVIGATION_BACKGROUND_COLOR];
    
    //color of navigation title
    [[UINavigationBar appearance] setTitleTextAttributes:navigationTitleAttribute];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    [self.window setRootViewController:  self.navController];

    // Whenever a person opens app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [MBProgressHUD showHUDAddedTo:self.navController.view animated:YES];
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // Call this method EACH time the session state changes,
                                          //  NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
    //init Twitter
//    [Fabric with:@[TwitterKit]];
    [TwitterKit startWithConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
