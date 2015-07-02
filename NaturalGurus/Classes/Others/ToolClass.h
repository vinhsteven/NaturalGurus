//
//  ToolClass.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/6/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignUpViewController.h"

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

#pragma mark HANDLE CONNECT TO GET DATA
- (void) registerAccount:(NSDictionary*)params withViewController:(SignUpViewController*)viewController;

@end
