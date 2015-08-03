//
//  ToolClass.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/6/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ToolClass.h"

#import "ScheduleAppointmentViewController.h"
#import "PaymentViewController.h"

@implementation ToolClass

+ (ToolClass *) instance {
    static ToolClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize source:(UIImage*)sourceImages
{
	UIImage *sourceImage = sourceImages;
	UIImage *newImage = nil;
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO)
	{
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor > heightFactor)
			scaleFactor = widthFactor; // scale to fit height
        else
			scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
        else
			if (widthFactor < heightFactor)
			{
				thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
	}
	
	UIGraphicsBeginImageContext(targetSize); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil)
        NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}

-(UIImage*)cropRect:(CGRect)targetSize source:(UIImage*)sourceImages{
    
    
    
    // Create a new UIImage
    CGImageRef imageRef = CGImageCreateWithImageInRect(sourceImages.CGImage, targetSize);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

-(UIImage *) ChangeViewToImage : (UIView *) view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (NSDictionary *) indexKeyedDictionaryFromArray:(NSMutableArray *)array
{
    id objectInstance;
    NSUInteger indexKey = 0;
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array)
        [mutableDictionary setObject:objectInstance forKey:[NSNumber numberWithUnsignedInt:indexKey++]];
    
    return [mutableDictionary copy];
}

- (NSString *)decodeHTMLCharacterEntities:(NSString*)str {
    if ([str rangeOfString:@"&"].location == NSNotFound) {
        return str;
    } else {
        NSMutableString *escaped = [NSMutableString stringWithString:str];
        NSArray *codes = [NSArray arrayWithObjects:
                          @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", @"&brvbar;",
                          @"&sect;", @"&uml;", @"&copy;", @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
                          @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;", @"&acute;", @"&micro;",
                          @"&para;", @"&middot;", @"&cedil;", @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;",
                          @"&frac12;", @"&frac34;", @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;",
                          @"&Atilde;", @"&Auml;", @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;",
                          @"&Eacute;", @"&Ecirc;", @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
                          @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;",
                          @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", @"&Yacute;",
                          @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
                          @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;", @"&ecirc;", @"&euml;",
                          @"&igrave;", @"&iacute;", @"&icirc;", @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;",
                          @"&oacute;", @"&ocirc;", @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;",
                          @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;",@"&rarr;", nil];
        
        NSUInteger i, count = [codes count];
        
        // Html
        for (i = 0; i < count; i++) {
            NSRange range = [str rangeOfString:[codes objectAtIndex:i]];
            if (range.location != NSNotFound) {
                unichar codeValue0 = 160 + i;
                [escaped replaceOccurrencesOfString:[codes objectAtIndex:i]
                                         withString:[NSString stringWithFormat:@"%C", codeValue0]
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [escaped length])];
            }
        }
        
        // The following five are not in the 160+ range
        
        // @"&amp;"
        NSRange range = [str rangeOfString:@"&amp;"];
        if (range.location != NSNotFound) {
            unichar codeValue1 = 38;
            [escaped replaceOccurrencesOfString:@"&amp;"
                                     withString:[NSString stringWithFormat:@"%C", codeValue1]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&lt;"
        range = [str rangeOfString:@"&lt;"];
        if (range.location != NSNotFound) {
            unichar codeValue2 = 60;
            [escaped replaceOccurrencesOfString:@"&lt;"
                                     withString:[NSString stringWithFormat:@"%C", codeValue2]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&gt;"
        range = [str rangeOfString:@"&gt;"];
        if (range.location != NSNotFound) {
            unichar codeValue3 = 62;
            [escaped replaceOccurrencesOfString:@"&gt;"
                                     withString:[NSString stringWithFormat:@"%C", codeValue3]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&apos;"
        range = [str rangeOfString:@"&apos;"];
        if (range.location != NSNotFound) {
            unichar codeValue4 = 39;
            [escaped replaceOccurrencesOfString:@"&apos;"
                                     withString:[NSString stringWithFormat:@"%C", codeValue4]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&quot;"
        range = [str rangeOfString:@"&quot;"];
        if (range.location != NSNotFound) {
            unichar codeValue5 = 34;
            [escaped replaceOccurrencesOfString:@"&quot;"
                                     withString:[NSString stringWithFormat:@"%C", codeValue5]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&hellip;"
        range = [str rangeOfString:@"&hellip;"];
        if (range.location != NSNotFound) {
            
            [escaped replaceOccurrencesOfString:@"&hellip;"
                                     withString:[NSString stringWithFormat:@"%@", @"..."]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // Decimal & Hex
        NSRange start, finish, searchRange = NSMakeRange(0, [escaped length]);
        i = 0;
        
        while (i < [escaped length]) {
            start = [escaped rangeOfString:@"&#"
                                   options:NSCaseInsensitiveSearch
                                     range:searchRange];
            
            finish = [escaped rangeOfString:@";"
                                    options:NSCaseInsensitiveSearch
                                      range:searchRange];
            
            if (start.location != NSNotFound && finish.location != NSNotFound &&
                finish.location > start.location) {
                NSRange entityRange = NSMakeRange(start.location, (finish.location - start.location) + 1);
                NSString *entity = [escaped substringWithRange:entityRange];
                NSString *value = [entity substringWithRange:NSMakeRange(2, [entity length] - 2)];
                
                [escaped deleteCharactersInRange:entityRange];
                
                if ([value hasPrefix:@"x"]) {
                    unsigned tempInt = 0;
                    unichar se = tempInt;
                    NSScanner *scanner = [NSScanner scannerWithString:[value substringFromIndex:1]];
                    [scanner scanHexInt:&tempInt];
                    [escaped insertString:[NSString stringWithFormat:@"%C", se] atIndex:entityRange.location];
                } else {
                    unichar se2 = [value intValue];
                    [escaped insertString:[NSString stringWithFormat:@"%C", se2] atIndex:entityRange.location];
                } i = start.location;
            } else { i++; }
            searchRange = NSMakeRange(i, [escaped length] - i);
        }
        
        return escaped;    // Note this is autoreleased
    }
}

- (NSString *)stringForTimeIntervalSinceCreated:(NSDate *)dateTime serverTime:(NSDate *)serverDateTime{
    NSInteger MinInterval;
    NSInteger HourInterval;
    NSInteger DayInterval;
    NSInteger DayModules;
    
    NSInteger interval = abs((NSInteger)[dateTime timeIntervalSinceDate:serverDateTime]);
    if(interval >= 86400)
    {
        DayInterval  = interval/86400;
        DayModules = interval%86400;
        if(DayModules!=0)
        {
            if(DayModules>=3600){
                //HourInterval=DayModules/3600;
                return [NSString stringWithFormat:@"%i days", DayInterval];
            }
            else {
                if(DayModules>=60){
                    //MinInterval=DayModules/60;
                    return [NSString stringWithFormat:@"%i days", DayInterval];
                }
                else {
                    return [NSString stringWithFormat:@"%i days", DayInterval];
                }
            }
        }
        else
        {
            return [NSString stringWithFormat:@"%i days", DayInterval];
        }
        
    }
    
    else{
        
        if(interval>=3600)
        {
            
            HourInterval= interval/3600;
            return [NSString stringWithFormat:@"%i hours", HourInterval];
            
        }
        
        else if(interval>=60){
            
            MinInterval = interval/60;
            
            return [NSString stringWithFormat:@"%i minutes", MinInterval];
        }
        else{
            return [NSString stringWithFormat:@"%i Sec", interval];
        }
        
    }
    
}

- (BOOL) validateEmail: (NSString *) emailaddress {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailaddress];
}



- (UIImage *)changeImageColor:(NSString *)name withColor:(UIColor *)color{
    
    // load the image
    
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

#pragma mark REGEX
// Validate the input string with the given pattern and
// return the result as a boolean
- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSAssert(regex, @"Unable to create regular expression");
    
    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    BOOL didValidate = NO;
    
    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = YES;
    
    return didValidate;
}

#pragma mark DATE FORMATTER
+ (NSString*) dateByFormat:(NSString*)format date:(NSDate*)date {
    NSString *dateStr = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

+ (NSString*) dateByFormat:(NSString*)format dateString:(NSString*)dateString {
    NSString *dateStr = @"";
    
    //convert string to date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:format];
    //convert date to string again
    dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

+ (NSString*) convertHourToAM_PM:(NSString*)rawHour {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (rawHour.length > 5)
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    else
        [dateFormatter setDateFormat:@"HH:mm"];
        
    NSDate *date = [dateFormatter dateFromString:rawHour];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

+ (NSString*) dateByTimezone:(NSString*)timezone andDate:(NSString*)dateTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *date = [dateFormatter dateFromString:dateTimeString];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timezone]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSDate*) dateTimeByTimezone:(NSString*)timezone andDate:(NSString*)dateTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timezone]];
    NSDate *date = [dateFormatter dateFromString:dateTimeString];
    
    return date;
}

+ (NSString*) dateTimeByTimezone:(NSString*)timezone andDate2:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timezone]];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

+ (NSString*) timeByTimezone:(NSString*)timezone andDateAndTime:(NSString*)dateTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *date = [dateFormatter dateFromString:dateTimeString];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timezone]];
    
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    return [dateFormatter stringFromDate:date];
}

+ (int) getHourIntervalByTimezone:(NSString*)timezoneName {
    NSTimeZone *timezone = [NSTimeZone timeZoneWithName:timezoneName];
    NSInteger intervalTime = [timezone secondsFromGMT] - [timezone daylightSavingTimeOffset];
    return (int)intervalTime/3600;
}

+ (int) getMinIntervalByTimezone:(NSString*)timezoneName {
    NSTimeZone *timezone = [NSTimeZone timeZoneWithName:timezoneName];
    NSInteger intervalTime = [timezone secondsFromGMT] - [timezone daylightSavingTimeOffset];

    return (intervalTime % 3600) / 60;
}

#pragma mark HANDLE STORE DATA
- (void) setLogin:(BOOL)isLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:isLogin] forKey:IS_LOGIN];
}

- (BOOL) isLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:IS_LOGIN] boolValue];
}

- (void) setLoginType:(int)loginType {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:loginType] forKey:LOGIN_TYPE];
}

- (int) getLoginType {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:LOGIN_TYPE] intValue];
}

- (NSString*) getProfileImageURL {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:PROFILE_IMAGE_URL];
}

- (void) setProfileImageURL:(NSString*)url {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:url forKey:PROFILE_IMAGE_URL];
    }
    @catch (NSException *exception) {
        NSLog(@"image null");
    }
}

- (void) setUserId:(long)_userId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithFloat:_userId] forKey:USER_ID];
}

- (long) getUserId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:USER_ID] longValue];
}

- (void) setUserFirstName:(NSString*)firstName {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:firstName forKey:USER_FIRSTNAME];
    }
    @catch (NSException *exception) {
        ;
    }
}

- (NSString*) getUserFirstName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USER_FIRSTNAME];
}

- (void) setUserLastName:(NSString*)firstName {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:firstName forKey:USER_LASTNAME];
    }
    @catch (NSException *exception) {
        ;
    }
}

- (NSString*) getUserLastName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USER_LASTNAME];
}

- (void) setUserEmail:(NSString*)email {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:email forKey:USER_EMAIL];
    }
    @catch (NSException *exception) {
        ;
    }
}

- (NSString*) getUserEmail {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USER_EMAIL];
}


- (void) setUserRole:(int)roleId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:roleId] forKey:USER_ROLE];
}

- (int) getUserRole {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:USER_ROLE] intValue];
}

- (void) setUserToken:(NSString*)token {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:token forKey:USER_TOKEN];
    }
    @catch (NSException *exception) {
        ;
    }
}

- (NSString*) getUserToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USER_TOKEN];
}

- (void) setUserCountryCode:(NSString*)string {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:string forKey:USER_COUNTRY_CODE];
    }
    @catch (NSException *exception) {
        ;
    }
}

- (NSString*) getUserCountryCode {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USER_COUNTRY_CODE];
}

- (void) setUserPhone:(NSString*)string {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:string forKey:USER_PHONE];
    }
    @catch (NSException *exception) {
        ;
    }
}

- (NSString*) getUserPhone {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USER_PHONE];
}

- (void) setUserSMS:(BOOL)boolean {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSNumber numberWithBool:boolean] forKey:USER_SMS];
    }
    @catch (NSException *exception) {
        ;
    }
}

- (BOOL) getUserSMS {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:USER_SMS] boolValue];
}

- (void) setUserPush:(BOOL)boolean {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSNumber numberWithBool:boolean] forKey:USER_PUSH];
    }
    @catch (NSException *exception) {
        ;
    }
}

- (BOOL) getUserPush {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:USER_PUSH] boolValue];
}

//for Push notification
- (void) setUserDeviceToken:(NSString*)deviceToken {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:deviceToken forKey:USER_DEVICE_TOKEN];
    }
    @catch (NSException *exception) {
        ;
    }
}

- (NSString*) getUserDeviceToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USER_DEVICE_TOKEN];
}

- (void) setExpertId:(float)_id {
    expertId = _id;
}

- (float) getExpertId {
    return expertId;
}

- (void) setExpertPrice:(float)price {
    expertPrice = price;
}

- (float) getExpertPrice {
    return expertPrice;
}

- (void) setExpertDict:(NSDictionary*)_expertDict {
    @try {
        expertDict = _expertDict;
    }
    @catch (NSException *exception) {
        
    }
}

- (NSDictionary*) getExpertDict {
    return expertDict;
}

#pragma mark HANDLE CONNECT TO GET DATA
- (void) registerAccount:(NSDictionary*)params withViewController:(SignUpViewController*)viewController {
    UIView *view;
    if (viewController.isFirstScreen)
        view = viewController.navigationController.view;
    else
        view = viewController.view;
    
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:@"/api/v1/register" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        //hide hud progress
        [MBProgressHUD hideHUDForView:view animated:YES];
        // 3
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 500) {
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
        }
        else if (status == 200){
            BOOL isSuccess = [[[responseObject objectForKey:@"data"] objectForKey:@"register_success"] boolValue];
            if (isSuccess) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Account Created" message:@"Your account has been created successfully" delegate:viewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) signIn:(NSDictionary*)params withViewController:(id)viewController {
    if ([viewController isKindOfClass:[LoginViewController class]])
        [MBProgressHUD showHUDAddedTo:((LoginViewController*)viewController).navigationController.view animated:YES];
    else
        [MBProgressHUD showHUDAddedTo:((LeftSideViewController*)viewController).navigationController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:@"/api/v1/sign_in" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        //hide hud progress
        if ([viewController isKindOfClass:[LoginViewController class]])
            [MBProgressHUD hideHUDForView:((LoginViewController*)viewController).navigationController.view animated:YES];
        else
            [MBProgressHUD hideHUDForView:((LeftSideViewController*)viewController).navigationController.view animated:YES];
        // 3
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSString *avatar = [data objectForKey:@"avatar"];
            avatar = [avatar stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            //save current user logged in informations
            [[ToolClass instance] setLogin:YES];
            [[ToolClass instance] setLoginType:LOGIN_EMAIL];
            [[ToolClass instance] setUserFirstName:[data objectForKey:@"firstname"]];
            [[ToolClass instance] setUserLastName:[data objectForKey:@"lastname"]];
            [[ToolClass instance] setProfileImageURL:avatar];
            [[ToolClass instance] setUserRole:[[data objectForKey:@"role_id"] intValue]];
            [[ToolClass instance] setUserToken:[data objectForKey:@"token"]];
            [[ToolClass instance] setUserEmail:[data objectForKey:@"email"]];
            [[ToolClass instance] setUserCountryCode:[data objectForKey:@"phone_code"]];
            [[ToolClass instance] setUserPhone:[data objectForKey:@"phone"]];
            [[ToolClass instance] setUserSMS:[[data objectForKey:@"receive_sms"] boolValue]];
            [[ToolClass instance] setUserPush:[[data objectForKey:@"receive_push"] boolValue]];
            
            [viewController loginSuccess];
        }
        else if (status == 401){
//            NSString *message = [responseObject objectForKey:@"message"];
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Sign In Unsuccessfully" message:@"These credentials do not match our records" delegate:viewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([viewController isKindOfClass:[LoginViewController class]])
            [MBProgressHUD hideHUDForView:((LoginViewController*)viewController).navigationController.view animated:YES];
        else
            [MBProgressHUD hideHUDForView:((LeftSideViewController*)viewController).navigationController.view animated:YES];
        
        // 4
        NSString *message = [error localizedDescription];
        
        if ([message rangeOfString:@"401"].location != NSNotFound) {
            //unauthorized
            message = @"These credentials do not match our records";
        }
        else {
            message = @"We didn't find your record. Please sign up an account and try again.";
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sign In Unsuccessfully"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) signOut:(NSDictionary*)params {
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:@"/api/v1/sign_out" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response: %@",(NSDictionary*)responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

- (void) requestResetPassword:(NSDictionary*)params withViewController:(ForgotPasswordViewController*)viewController {
    UIView *view;
    if (viewController.isFirstScreen)
        view = viewController.navigationController.view;
    else
        view = viewController.view;
    
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:@"/api/v1/reset_password" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        //hide hud progress
        [MBProgressHUD hideHUDForView:view animated:YES];
        
        // 3
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            //save current user logged in informations
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Request sent" message:[data objectForKey:@"status"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
        }
        else if (status == 401){
            NSString *message = [responseObject objectForKey:@"message"];
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:viewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) loadTheLatestExperts:(int)_pageIndex withViewController:(BrowseViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_pageIndex],@"page",[NSNumber numberWithInt:NUMBER_RECORD_PER_PAGE],@"per_page", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"/api/v1/experts" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 3
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            viewController.lastPage = [[[responseObject objectForKey:@"data"] objectForKey:@"last_page"] intValue];
            NSArray *expertArray = [[responseObject objectForKey:@"data"] objectForKey:@"items"];
            [viewController reorganizeExpertArray:expertArray];
        }
        else {
            [MBProgressHUD hideHUDForView:viewController.navigationController.view animated:YES];
            
            NSString *message = [responseObject objectForKey:@"message"];
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:viewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:viewController.navigationController.view animated:YES];
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) loadExpertByCategory:(int)_categoryId pageIndex:(int)_pageIndex withViewController:(BrowseViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_categoryId],@"category_id",[NSNumber numberWithInt:_pageIndex],@"page",[NSNumber numberWithInt:NUMBER_RECORD_PER_PAGE],@"per_page", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"/api/v1/experts" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 3
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            viewController.lastPage = [[[responseObject objectForKey:@"data"] objectForKey:@"last_page"] intValue];
            NSArray *expertArray = [[responseObject objectForKey:@"data"] objectForKey:@"items"];
            [viewController reorganizeExpertArray:expertArray];
        }
        else if (status == 401){
            //            NSString *message = [responseObject objectForKey:@"message"];
            //            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:viewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [dialog show];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:viewController.navigationController.view animated:YES];
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) loadExpertByFilter:(int)_filterIndex pageIndex:(int)_pageIndex withViewController:(BrowseViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSString *key;
    if (_filterIndex)
        key = @"free";
    else
        key = @"online";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],key,[NSNumber numberWithInt:_pageIndex],@"page",[NSNumber numberWithInt:NUMBER_RECORD_PER_PAGE],@"per_page", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"/api/v1/experts" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            viewController.lastPage = [[[responseObject objectForKey:@"data"] objectForKey:@"last_page"] intValue];
            NSArray *expertArray = [[responseObject objectForKey:@"data"] objectForKey:@"items"];
            [viewController reorganizeExpertArray:expertArray];
        }
        else if (status == 401){
            //            NSString *message = [responseObject objectForKey:@"message"];
            //            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:viewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [dialog show];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:viewController.navigationController.view animated:YES];
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) loadExpertBySorting:(int)_sortIndex pageIndex:(int)_pageIndex withViewController:(BrowseViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSString *sortType;
    if (_sortIndex)
        sortType = @"experience";
    else
        sortType = @"price";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:sortType,@"order_by",[NSNumber numberWithInt:_pageIndex],@"page",[NSNumber numberWithInt:NUMBER_RECORD_PER_PAGE],@"per_page",@"DESC",@"order_direction", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"/api/v1/experts" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            viewController.lastPage = [[[responseObject objectForKey:@"data"] objectForKey:@"last_page"] intValue];
            NSArray *expertArray = [[responseObject objectForKey:@"data"] objectForKey:@"items"];
            [viewController reorganizeExpertArray:expertArray];
        }
        else if (status == 401){
            //            NSString *message = [responseObject objectForKey:@"message"];
            //            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:viewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [dialog show];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:viewController.navigationController.view animated:YES];
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) loadExpertBySearchString:(NSString*)_searchStr pageIndex:(int)_pageIndex withViewController:(BrowseViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_searchStr,@"search",[NSNumber numberWithInt:_pageIndex],@"page",[NSNumber numberWithInt:NUMBER_RECORD_PER_PAGE],@"per_page", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"/api/v1/experts" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 3
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            viewController.lastPage = [[[responseObject objectForKey:@"data"] objectForKey:@"last_page"] intValue];
            NSArray *expertArray = [[responseObject objectForKey:@"data"] objectForKey:@"items"];
            [viewController reorganizeExpertArray:expertArray];
        }
        else if (status == 401){
            //            NSString *message = [responseObject objectForKey:@"message"];
            //            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:viewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [dialog show];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:viewController.navigationController.view animated:YES];
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) loadCategoriesWithViewController:(BrowseViewController*)viewController {
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    
    [manager GET:@"/api/v1/categories" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSArray *categoryArray = [[responseObject objectForKey:@"data"] objectForKey:@"categories"];
            [viewController reorganizeCategoryArray:categoryArray];
        }
        else if (status == 401){
            //            NSString *message = [responseObject objectForKey:@"message"];
            //            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:viewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [dialog show];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 4
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                            message:[error localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
    }];
}

- (void) loadDetailExpertById:(long)_expertId withViewController:(id)viewController {
    if ([viewController isKindOfClass:[DetailBrowseViewController class]])
        [MBProgressHUD showHUDAddedTo:((DetailBrowseViewController*)viewController).navigationController.view animated:YES];
    else
        [MBProgressHUD showHUDAddedTo:((DetailAppointmentViewController*)viewController).view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"/api/v1/experts/%@",[NSString stringWithFormat:@"%ld",_expertId]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([viewController isKindOfClass:[DetailBrowseViewController class]])
            [MBProgressHUD hideAllHUDsForView:((DetailBrowseViewController*)viewController).navigationController.view animated:YES];
        else
            [MBProgressHUD hideAllHUDsForView:((DetailAppointmentViewController*)viewController).view animated:YES];

        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSMutableDictionary *_expertDict = [responseObject objectForKey:@"data"];
            [viewController setExpertDict:_expertDict];
            //save to use global
            [[ToolClass instance] setExpertDict:_expertDict];
            
            if ([viewController isKindOfClass:[DetailBrowseViewController class]])
                [viewController setupTableViewData];
            else {
                [(DetailAppointmentViewController*)viewController reorganizeData];
            }
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok"        otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) loadExpertReviewById:(long)_expertId pageIndex:(int)_pageIndex withViewController:(DetailBrowseViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_pageIndex],@"page",[NSNumber numberWithInt:NUMBER_RECORD_PER_PAGE],@"per_page", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"/api/v1/experts/%@/reviews",[NSString stringWithFormat:@"%ld",_expertId]] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 3
//        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            viewController.lastPage = [[[responseObject objectForKey:@"data"] objectForKey:@"last_page"] intValue];
            NSMutableArray *reviewArray = [[responseObject objectForKey:@"data"] objectForKey:@"items"];
            [viewController reorganizeReviewArray:reviewArray];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok"        otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) getTotalReviewsByExpertId:(long)_expertId pageIndex:(int)_pageIndex withViewController:(DetailBrowseViewController*)viewController {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_pageIndex],@"page",[NSNumber numberWithInt:2],@"per_page", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"/api/v1/experts/%@/reviews",[NSString stringWithFormat:@"%ld",_expertId]] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 3
//        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            viewController.totalReview = [[[responseObject objectForKey:@"data"] objectForKey:@"total"] intValue];
            [viewController setUpStyleForReviewButton];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"totalReview error = %@",error);
    }];
}

- (void) loadAvailabilitiesByExpertId:(long)_expertId params:(NSDictionary*)params withViewController:(AvailabilityViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"/api/v1/experts/%@/availabilities",[NSString stringWithFormat:@"%ld",_expertId]] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 3
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            [viewController reorganizeAvailabilities:data];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"availibilities error = %@",error);
    }];
}

- (void) loadUserAppointments:(NSDictionary*)params withViewController:(DashboardViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"/api/v1/client/appointments" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 3
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSArray *data = [[responseObject objectForKey:@"data"] objectForKey:@"items"];
            viewController.lastPage = [[[responseObject objectForKey:@"data"] objectForKey:@"last_page"] intValue];
            
//            if ([data count] > 0)
                [viewController reorganizeAppointments:data];
//            else {
//                [MBProgressHUD hideAllHUDsForView:viewController.navigationController.view animated:YES];
//                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Message" message:@"There isn't any appointments for your account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [dialog show];
//            }
        }
        else {
            [MBProgressHUD hideAllHUDsForView:viewController.navigationController.view animated:YES];
            
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location == NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Something wrong" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone has logged in your account from another device. Please login again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"dashboard error = %@",error);
        [MBProgressHUD hideAllHUDsForView:viewController.navigationController.view animated:YES];
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Request failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
    }];
}

/************* MY PROFILE ***************/
- (void) updateUserProfile:(NSDictionary*)params withViewController:(MyProfileViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;
    
    [manager POST:@"/api/v1/users/profile" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [MBProgressHUD hideHUDForView:viewController.navigationController.view animated:YES];
        // 3
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            
            [[ToolClass instance] setUserFirstName:[dict objectForKey:@"firstname"]];
            [[ToolClass instance] setUserLastName:[dict objectForKey:@"lastname"]];
            [[ToolClass instance] setUserEmail:[dict objectForKey:@"email"]];
            [[ToolClass instance] setUserPhone:[dict objectForKey:@"phone"]];
            [[ToolClass instance] setUserCountryCode:[dict objectForKey:@"phone_code"]];
            [[ToolClass instance] setUserSMS:[[dict objectForKey:@"receive_sms"] boolValue]];
            [[ToolClass instance] setUserPush:[[dict objectForKey:@"receive_push"] boolValue]];
            [[ToolClass instance] setProfileImageURL:[dict objectForKey:@"avatar"]];
            
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Update Profile" message:@"Your profile has updated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:viewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:viewController.navigationController.view animated:YES];
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
     
    
//    NSData *imageData = UIImageJPEGRepresentation(viewController.imgExpertView.image, 1.0);
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    NSString *imagePostUrl = [NSString stringWithFormat:@"%@/api/v1/users/profile", BASE_URL];
//    
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:imagePostUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:imageData name:@"image" fileName:[NSString stringWithFormat:@"%@_%@",[params objectForKey:@"firstname"],[params objectForKey:@"lastname"]] mimeType:@"image/jpeg"];
//    }];
//    
//    AFHTTPRequestOperation *op = [manager HTTPRequestOperationWithRequest:request success: ^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"response: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    op.responseSerializer = [AFJSONResponseSerializer serializer];
//    [[NSOperationQueue mainQueue] addOperation:op];
}

- (void) loadUserVideoToken:(long)appointmentId params:(NSDictionary*)params withViewController:(DetailAppointmentViewController*)viewController {
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"/api/v1/client/appointments/%ld",appointmentId] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 3
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            [viewController setVideoDict:data];
        }
        else {
            NSLog(@"video token error: %@",[responseObject objectForKey:@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"video token error = %@",error);
    }];
}

/********************** EXPERT DASHBOARD ************************/
- (void) loadExpertAppointments:(NSDictionary*)params withViewController:(DashboardViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"/api/v1/expert/appointments" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 3
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSArray *data = [[responseObject objectForKey:@"data"] objectForKey:@"items"];
            
            if ([data count] == 0) {
                [MBProgressHUD hideAllHUDsForView:viewController.navigationController.view animated:YES];
                
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"No Appointments Found" message:@"There is not any appointments for your account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                viewController.lastPage = [[[responseObject objectForKey:@"data"] objectForKey:@"last_page"] intValue];
                [viewController reorganizeAppointments:data];
            }
        }
        else {
            [MBProgressHUD hideAllHUDsForView:viewController.navigationController.view animated:YES];
            
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location == NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Something wrong" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone has logged in your account from another device. Please login again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"dashboard error = %@",error);
        [MBProgressHUD hideAllHUDsForView:viewController.navigationController.view animated:YES];
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone has logged in your account from another device. Please login again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
    }];
}

- (void) loadExpertVideoToken:(long)appointmentId params:(NSDictionary*)params withViewController:(DetailAppointmentViewController*)viewController {
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"/api/v1/expert/appointments/%ld",appointmentId] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 3
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            [viewController setVideoDict:data];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            [viewController handleGetVideoTokenFailedWithMessage:message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"video token error = %@",error);
    }];
}

/********** BOOKING ***********/
- (void) bookSchedule:(NSDictionary*)params withViewController:(id)viewController {
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120;
    
    [manager POST:@"/api/v1/order/book" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([viewController isKindOfClass:[ScheduleAppointmentViewController class]])
            [MBProgressHUD hideHUDForView:((ScheduleAppointmentViewController*)viewController).navigationController.view animated:YES];
        else if ([viewController isKindOfClass:[PaymentViewController class]])
            [MBProgressHUD hideHUDForView:((PaymentViewController*)viewController).navigationController.view animated:YES];
        // 3
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            if ([viewController isKindOfClass:[ScheduleAppointmentViewController class]])
                [viewController bookingSuccess];
            else if ([viewController isKindOfClass:[PaymentViewController class]]) {
                long orderId = [[[[responseObject objectForKey:@"data"] objectForKey:@"order"] objectForKey:@"id"] longValue];
                [viewController bookingSuccess:orderId];
            }
            
            /* server will use push notification to send message for this
            //we will create 3 local notification for an appointment:
            //Upcoming appointment: this notification will be fired prior 24 hours of this appointment
            //Appointment today: this notification will be fired at 00:00 of this appointment's date
            //Appointment in 10 minutes: this notification will be fired prior 10 mins of this appointment's datetime
            
            NSString *date = [params objectForKey:@"date"];
            NSString *fromTime = [NSString stringWithFormat:@"%@:00",[params objectForKey:@"from_time"]];
            NSString *timezone = [params objectForKey:@"client_timezone"];
            
            NSDate *appointmentDate = [ToolClass dateTimeByTimezone:timezone andDate:[NSString stringWithFormat:@"%@ %@",date,fromTime]];
            NSLog(@"date = %@ fromtime = %@",date,fromTime);
            NSLog(@"appointmentDate = %@",appointmentDate);
            
            //Upcoming appointment
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            
            NSCalendar *theCalendar = [NSCalendar currentCalendar];
            
            NSDate *priorDate = [theCalendar dateByAddingComponents:dayComponent toDate:appointmentDate options:0];
            
            UILocalNotification* upComingNotification = [[UILocalNotification alloc] init];
            upComingNotification.fireDate = priorDate;
            upComingNotification.alertTitle = @"Upcoming Appointment";
            upComingNotification.alertBody = [NSString stringWithFormat:@"You have an appointment tomorrow at %@ (%@)",[ToolClass convertHourToAM_PM:fromTime],timezone];
            upComingNotification.alertAction = @"OK";
            upComingNotification.timeZone = [NSTimeZone timeZoneWithName:timezone];
            upComingNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:upComingNotification];
            
            //Appointment today
            NSDate *earlyAppointmentDate = [ToolClass dateTimeByTimezone:timezone andDate:[NSString stringWithFormat:@"%@ 00:00:00",date]];
            
            UILocalNotification* todayNotification = [[UILocalNotification alloc] init];
            todayNotification.fireDate = earlyAppointmentDate;
            todayNotification.alertTitle = @"Appointment Today";
            todayNotification.alertBody = [NSString stringWithFormat:@"You have an appointment today at %@ (%@)",[ToolClass convertHourToAM_PM:fromTime],timezone];
            todayNotification.alertAction = @"OK";
            todayNotification.timeZone = [NSTimeZone timeZoneWithName:timezone];
            todayNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:todayNotification];
            
            //Appointment in 10 minutes
            dayComponent.day = 0;
            dayComponent.minute = -10;
            
            NSDate *priorTenMinutesDate = [theCalendar dateByAddingComponents:dayComponent toDate:appointmentDate options:0];
            
            UILocalNotification* priorTenMinsNotification = [[UILocalNotification alloc] init];
            priorTenMinsNotification.fireDate = priorTenMinutesDate;
            priorTenMinsNotification.alertTitle = @"Appointment in 10 minutes";
            priorTenMinsNotification.alertBody = @"You have an appointment in 10 minutes";
            priorTenMinsNotification.alertAction = @"OK";
            priorTenMinsNotification.timeZone = [NSTimeZone timeZoneWithName:timezone];
            priorTenMinsNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:priorTenMinsNotification];
             */
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Something Wrong"
                                                                    message:@"Payment was unsuccessful, please double check your credit card details."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([viewController isKindOfClass:[ScheduleAppointmentViewController class]])
            [MBProgressHUD hideHUDForView:((ScheduleAppointmentViewController*)viewController).navigationController.view animated:YES];
        else if ([viewController isKindOfClass:[PaymentViewController class]])
            [MBProgressHUD hideHUDForView:((PaymentViewController*)viewController).navigationController.view animated:YES];
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Something Wrong"
                                                            message:@"Payment was unsuccessful, please double check your credit card details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) finishAppointment:(NSDictionary*)params withViewController:(StreamingVideoViewController*)viewController {
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120;
    
    [manager POST:@"/api/v1/order/finish" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [MBProgressHUD hideHUDForView:viewController.view animated:YES];
        // 3
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            [viewController finishAppointment];
        }
        else if (status == 422) {
            //the session is over, so we just close the view.
            [viewController finishAppointment];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:viewController.view animated:YES];
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) handleUpdateAppointmentState:(int)type appointmentId:(long)appointmentId params:(NSDictionary*)params withViewController:(DetailAppointmentViewController*)viewController {
    
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    NSString *requestStr;
    
    if (type) {
        //approve
        requestStr = [NSString stringWithFormat:@"/api/v1/expert/appointments/%ld/approve",appointmentId];
    }
    else {
        //decline
        requestStr = [NSString stringWithFormat:@"/api/v1/expert/appointments/%ld/decline",appointmentId];
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120;
    
    [manager POST:requestStr parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [MBProgressHUD hideHUDForView:viewController.navigationController.view animated:YES];
        // 3
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            [viewController handleAfterUpdateAppointmentSuccess:type];
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Message" message:[responseObject objectForKey:@"data"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:viewController.view animated:YES];
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
}

- (void) loadDetailAppointmentById:(long)orderId params:(NSDictionary*)params withViewController:(DetailAppointmentViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120;
    
    [manager GET:[NSString stringWithFormat:@"/api/v1/orders/%ld",orderId] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [MBProgressHUD hideHUDForView:viewController.navigationController.view animated:YES];
        // 3
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            [viewController.myFrontView removeFromSuperview];
            
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            [viewController getDetailAppointmentSuccess:dict];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:viewController.navigationController.view animated:YES];
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

#pragma mark LIVE REQUEST
- (void) sendLiveRequest:(NSDictionary*)params viewController:(ScheduleAppointmentViewController*)viewController {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [MBProgressHUD showHUDAddedTo:delegate.navController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120;
    
    [manager POST:@"/api/v1/live_requests" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        [MBProgressHUD hideHUDForView:delegate.navController.view animated:YES];
        
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSDictionary *dict = [[responseObject objectForKey:@"data"] objectForKey:@"live_request"];
            [viewController sendLiveRequestSuccessful:dict];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:delegate.navController.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) checkLiveRequestList:(NSDictionary*)params viewController:(AppDelegate*)viewController {
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120;
    
    [manager GET:@"/api/v1/live_requests" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"requests"];
            if ([array count] > 0)
                [viewController loadLiveRequestList];
        }
        else {
            NSLog(@"checkLiveRequest error = %@",[responseObject objectForKey:@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"checkLiveRequest error = %@",error);
    }];
}

- (void) loadLiveRequestList:(NSDictionary*)params viewController:(LiveRequestListViewController*)viewController {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [MBProgressHUD showHUDAddedTo:delegate.navController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120;
    
    [manager GET:@"/api/v1/live_requests" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        [MBProgressHUD hideAllHUDsForView:delegate.navController.view animated:YES];
        
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"requests"];
            [viewController reorganizeLiveRequest:array];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:delegate.navController.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disconnected"
                                                            message:@"Someone has logged in with this account. Please login again."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) approveLiveRequest:(NSDictionary*)params viewController:(LiveRequestListViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120;
    
    [manager POST:@"/api/v1/live_requests/approve" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        [MBProgressHUD hideAllHUDsForView:viewController.navigationController.view animated:YES];
        
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            [viewController approveLiveRequestSuccessful];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:viewController.navigationController.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) declineLiveRequest:(NSDictionary*)params viewController:(LiveRequestListViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120;
    
    [manager POST:@"/api/v1/live_requests/decline" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        [MBProgressHUD hideAllHUDsForView:viewController.navigationController.view animated:YES];
        
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSDictionary *request = [[responseObject objectForKey:@"data"] objectForKey:@"live_request"];
            [viewController declineLiveRequestSuccessful:request];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:viewController.navigationController.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

#pragma mark WRITE REVIEW

- (void) writeReviewForExpert:(NSDictionary*)params viewController:(WriteReviewViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120;
    
    [manager POST:@"/api/v1/orders/feedback" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        [MBProgressHUD hideAllHUDsForView:viewController.view animated:YES];
        
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            [viewController submitReviewSuccessful];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:viewController.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) writeReviewForNG:(NSDictionary*)params viewController:(WriteReviewViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120;
    
    [manager POST:@"/api/v1/ng/feedback" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        [MBProgressHUD hideAllHUDsForView:viewController.view animated:YES];
        
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            [viewController submitReviewSuccessful];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            message = [message lowercaseString];
            if ([message rangeOfString:@"invalid token"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else if ([message rangeOfString:@"token is missing"].location != NSNotFound) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Someone login your account on another device. Please login again to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:viewController.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate handleLogOut];
}

@end
