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
#import "AvailabilityViewController.h"
#import "DashboardViewController.h"
#import "DetailAppointmentViewController.h"
#import "MyProfileViewController.h"
#import "StreamingVideoViewController.h"
#import "LiveRequestListViewController.h"
#import "WriteReviewViewController.h"

@interface ToolClass : NSObject <UIAlertViewDelegate> {
    unsigned long expertId;
    float expertPrice;
    NSDictionary *expertDict;
}

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

#pragma mark REGEX
- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern;

//Handle Date format
+ (NSString*) convertHourToAM_PM:(NSString*)rawHour;
+ (NSString*) dateByFormat:(NSString*)format date:(NSDate*)date;
+ (NSString*) dateByFormat:(NSString*)format dateString:(NSString*)dateString;
+ (NSString*) dateByTimezone:(NSString*)timezone andDate:(NSString*)dateTimeString;
+ (NSDate*) dateTimeByTimezone:(NSString*)timezone andDate:(NSString*)dateTimeString;
+ (NSString*) dateTimeByTimezone:(NSString*)timezone andDate2:(NSDate*)date;
+ (NSString*) timeByTimezone:(NSString*)timezone andDateAndTime:(NSString*)dateTimeString;
+ (int) getHourIntervalByTimezone:(NSString*)timezoneName;
+ (int) getMinIntervalByTimezone:(NSString*)timezoneName;

#pragma mark HANDLE STORE DATA 
- (void) setLogin:(BOOL)isLogin;
- (BOOL) isLogin;

- (void) setLoginType:(int)loginType;
- (int) getLoginType;

- (NSString*) getProfileImageURL;
- (void) setProfileImageURL:(NSString*)url;

- (void) setUserId:(long)_userId;
- (long) getUserId;

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

- (void) setUserCountryCode:(NSString*)string;
- (NSString*) getUserCountryCode;

- (void) setUserPhone:(NSString*)string;
- (NSString*) getUserPhone;

- (void) setUserSMS:(BOOL)boolean;
- (BOOL) getUserSMS;

- (void) setUserPush:(BOOL)boolean;
- (BOOL) getUserPush;

//for Push notification
- (void) setUserDeviceToken:(NSString*)deviceToken;
- (NSString*) getUserDeviceToken;

- (void) setExpertId:(float)_id;
- (float) getExpertId;

- (void) setExpertPrice:(float)price;
- (float) getExpertPrice;

- (void) setExpertDict:(NSDictionary*)_expertDict;
- (NSDictionary*) getExpertDict;

#pragma mark HANDLE CONNECT TO GET DATA
/***************LOGIN*******************/
- (void) registerAccount:(NSDictionary*)params withViewController:(SignUpViewController*)viewController;
- (void) signIn:(NSDictionary*)params withViewController:(id)viewController;
- (void) signOut:(NSDictionary*)params;
- (void) requestResetPassword:(NSDictionary*)params withViewController:(ForgotPasswordViewController*)viewController;

/***************BROWSE*******************/
- (void) loadTheLatestExperts:(int)_pageIndex withViewController:(BrowseViewController*)viewController;
- (void) loadExpertByCategory:(int)_categoryId pageIndex:(int)_pageIndex withViewController:(BrowseViewController*)viewController;
- (void) loadExpertByFilter:(int)_filterIndex pageIndex:(int)_pageIndex withViewController:(BrowseViewController*)viewController;
- (void) loadExpertBySorting:(int)_sortIndex pageIndex:(int)_pageIndex withViewController:(BrowseViewController*)viewController;
- (void) loadExpertBySearchString:(NSString*)_searchStr pageIndex:(int)_pageIndex withViewController:(BrowseViewController*)viewController;
- (void) loadCategoriesWithViewController:(BrowseViewController*)viewController;

- (void) loadDetailExpertById:(long)_expertId withViewController:(id)viewController;
- (void) loadExpertReviewById:(long)_expertId pageIndex:(int)_pageIndex withViewController:(DetailBrowseViewController*)viewController;
- (void) getTotalReviewsByExpertId:(long)_expertId pageIndex:(int)_pageIndex withViewController:(DetailBrowseViewController*)viewController;
- (void) loadAvailabilitiesByExpertId:(long)_expertId params:(NSDictionary*)params withViewController:(AvailabilityViewController*)viewController;
- (void) loadUserAppointments:(NSDictionary*)params withViewController:(DashboardViewController*)viewController;
- (void) loadUserVideoToken:(long)appointmentId params:(NSDictionary*)params withViewController:(DetailAppointmentViewController*)viewController;

/*MY PROFILE*/
- (void) updateUserProfile:(NSDictionary*)params withViewController:(MyProfileViewController*)viewController;

/*EXPERT DASHBOARD */
- (void) loadExpertAppointments:(NSDictionary*)params withViewController:(DashboardViewController*)viewController;
- (void) loadExpertVideoToken:(long)appointmentId params:(NSDictionary*)params withViewController:(DetailAppointmentViewController*)viewController;

/* BOOKING */
- (void) bookSchedule:(NSDictionary*)params withViewController:(id)viewController;
- (void) finishAppointment:(NSDictionary*)params withViewController:(StreamingVideoViewController*)viewController;
- (void) handleUpdateAppointmentState:(int)type appointmentId:(long)appointmentId params:(NSDictionary*)params withViewController:(DetailAppointmentViewController*)viewController;
- (void) loadDetailAppointmentById:(long)orderId params:(NSDictionary*)params withViewController:(DetailAppointmentViewController*)viewController;

#pragma mark LIVE REQUEST
- (void) sendLiveRequest:(NSDictionary*)params viewController:(ScheduleAppointmentViewController*)viewController;
- (void) loadLiveRequestList:(NSDictionary*)params viewController:(LiveRequestListViewController*)viewController;
- (void) checkLiveRequestList:(NSDictionary*)params viewController:(AppDelegate*)viewController;
- (void) approveLiveRequest:(NSDictionary*)params viewController:(LiveRequestListViewController*)viewController;
- (void) declineLiveRequest:(NSDictionary*)params viewController:(LiveRequestListViewController*)viewController;

#pragma mark WRITE REVIEW
- (void) writeReviewForExpert:(NSDictionary*)params viewController:(WriteReviewViewController*)viewController;
- (void) writeReviewForNG:(NSDictionary*)params viewController:(WriteReviewViewController*)viewController;

@end
