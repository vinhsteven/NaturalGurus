//
//  ToolClass.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/6/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ToolClass.h"

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

#pragma mark DATE FORMATTER
+ (NSString*) dateByFormat:(NSString*)format date:(NSDate*)date {
    NSString *dateStr = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
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
            //save current user logged in informations
            [[ToolClass instance] setLogin:YES];
            [[ToolClass instance] setLoginType:LOGIN_EMAIL];
            [[ToolClass instance] setUserFirstName:[data objectForKey:@"firstname"]];
            [[ToolClass instance] setUserLastName:[data objectForKey:@"lastname"]];
            [[ToolClass instance] setProfileImageURL:[data objectForKey:@"avatar"]];
            [[ToolClass instance] setUserRole:[[data objectForKey:@"role_id"] intValue]];
            [[ToolClass instance] setUserToken:[data objectForKey:@"token"]];
            [[ToolClass instance] setUserEmail:[data objectForKey:@"email"]];
            
            [viewController loginSuccess];
        }
        else if (status == 401){
            NSString *message = [responseObject objectForKey:@"message"];
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:viewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([viewController isKindOfClass:[LoginViewController class]])
            [MBProgressHUD hideHUDForView:((LoginViewController*)viewController).navigationController.view animated:YES];
        else
            [MBProgressHUD hideHUDForView:((LeftSideViewController*)viewController).navigationController.view animated:YES];
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
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

@end
