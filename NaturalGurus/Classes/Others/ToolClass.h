//
//  ToolClass.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/6/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "LeftSideViewController.h"
#import "ForgotPasswordViewController.h"
#import "BrowseViewController.h"
#import "DetailBrowseViewController.h"

@interface ToolClass : NSObject 
+ (ToolClass *) instance;
+ (UIImage *) imageFromColor:(UIColor *)color;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize source:(UIImage*)sourceImages;
- (UIImage*)cropRect:(CGRect)targetSize source:(UIImage*)sourceImages;
- (UIImage *) ChangeViewToImage : (UIView *) view;
- (NSString *)decodeHTMLCharacterEntities:(NSString*)str;
- (NSString *)stringForTimeIntervalSinceCreated:(NSDate *)dateTime serverTime:(NSDate *)serverDateTime;
- (BOOL) validateEmail: (NSString *) emailaddress;
- (NSDictionary *) indexKeyedDictionaryFromArray:(NSMutableArray *)array;
- (UIImage *)changeImageColor:(NSString *)name withColor:(UIColor *)color;

//Handle Date format
+ (NSString*) dateByFormat:(NSString*)format date:(NSDate*)date;

#pragma mark HANDLE STORE DATA 
- (void) setLogin:(BOOL)isLogin;
- (BOOL) isLogin;

- (void) setLoginType:(int)loginType;
- (int) getLoginType;

- (NSString*) getProfileImageURL;
- (void) setProfileImageURL:(NSString*)url;

- (void) setUserFirstName:(NSString*)firstName;
- (NSString*) getUserFirstName;

- (void) setUserLastName:(NSString*)firstName;
- (NSString*) getUserLastName;

- (void) setUserEmail:(NSString*)email;
- (NSString*) getUserEmail;

- (void) setUserRole:(int)roleId;
- (int) getUserRole;

- (void) setUserToken:(NSString*)token;
- (NSString*) getUserToken;

#pragma mark HANDLE CONNECT TO GET DATA
- (void) registerAccount:(NSDictionary*)params withViewController:(SignUpViewController*)viewController;
- (void) signIn:(NSDictionary*)params withViewController:(id)viewController;
- (void) requestResetPassword:(NSDictionary*)params withViewController:(ForgotPasswordViewController*)viewController;

- (void) loadTheLatestExperts:(int)_pageIndex withViewController:(BrowseViewController*)viewController;
- (void) loadExpertByCategory:(int)_categoryId pageIndex:(int)_pageIndex withViewController:(BrowseViewController*)viewController;
- (void) loadExpertByFilter:(int)_filterIndex pageIndex:(int)_pageIndex withViewController:(BrowseViewController*)viewController;
- (void) loadExpertBySearchString:(NSString*)_searchStr pageIndex:(int)_pageIndex withViewController:(BrowseViewController*)viewController;
- (void) loadCategoriesWithViewController:(BrowseViewController*)viewController;

- (void) loadDetailExpertById:(long)expertId withViewController:(DetailBrowseViewController*)viewController;

@end
