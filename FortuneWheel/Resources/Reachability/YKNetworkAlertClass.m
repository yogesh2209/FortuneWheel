//
//  YKNetworkAlertClass.m
//  NetworkCheckClass
//
//  Created by Yogesh Kohli on 12/07/15.
//  Copyright (c) 2016 Yogesh Kohli. All rights reserved.
//

#import "YKNetworkAlertClass.h"
#import "Reachability.h"

//MESSAGE
#define FINE_MESSAGE  @"Internet working fine"
#define ERROR_MESSAGE @"Internet connection error"

//COLOR
#define ORANGE_COLOR  [UIColor colorWithRed:255.0f/255.0f green:84.0f/255.0f  blue:62.0f/255.0f alpha:1.0]
#define GREEN_COLOR   [UIColor colorWithRed:5.0f/255.0f   green:122.0f/255.0f blue:0.0f/255.0f  alpha:1.0]

@interface YKNetworkAlertClass () {
    
    BOOL           isAlertPresent;
    UIWindow      *window;
    NSTimer       *alertTimer;
    UIView        *internetDownAlert;
    UILabel       *messageLabel;
    Reachability  *internetReachable;
}

@end

@implementation YKNetworkAlertClass

#pragma mark Singleton Methods

+ (id)sharedManager {
    
    static YKNetworkAlertClass *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    
    if (self = [super init]) {
        
        window = [UIApplication sharedApplication].windows[0];
        [self createAlertView];
        [self checkInternetConnection];
    }
    return self;
}

/*!
 * Create custom alertView to show the network status.
 */
- (void)createAlertView {
    
    internetDownAlert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, -64)];
    
    [window addSubview:internetDownAlert];
    [window bringSubviewToFront:internetDownAlert];
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, internetDownAlert.frame.origin.y + 20, internetDownAlert.frame.size.width, internetDownAlert.frame.size.height - 20)];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = [UIFont systemFontOfSize:17.0f];
    [internetDownAlert addSubview:messageLabel];
}

/*!
 * Create custom alertView to show the network status.
 */
- (void)checkInternetConnection {
    
    //Check For Network Activity
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    [self checkNetworkStatus:nil];
}

#pragma mark  Reachability Section

/*!
 * Method to check internet connection by using the currentReachabilityStatus
 * @param notice Reachability Notification
 */
-(void)checkNetworkStatus:(NSNotification *)notice{
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    
    switch (internetStatus)
    {
        case NotReachable:
        {
    
            self.isInternetActive = NO;
            
            // Show notification alert bar in main thread using dispatch.
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showInternetErrorAlertWithMessage];
            });
            
            break;
        }
        case ReachableViaWiFi:
        {
          
            self.isInternetActive = YES;
            
            // Show notification alert bar in main thread using dispatch.
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showInternetWorkingFineAlertWithMessage];
            });
            
            break;
        }
        case ReachableViaWWAN:
        {
         
            self.isInternetActive = YES;
            
            // Show notification alert bar in main thread using dispatch.
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showInternetWorkingFineAlertWithMessage];
            });
            
            break;
        }
        default:
        {
     
            self.isInternetActive = NO;
            
            // Show notification alert bar in main thread using dispatch.
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showInternetErrorAlertWithMessage];
            });
        }
    }
}

/*!
 *  Method to show alert with message and color code parameters.
 */
- (void)showInternetErrorAlertWithMessage {
    
    if (!isAlertPresent) {
        
        // Show internet alert.
        internetDownAlert.backgroundColor = ORANGE_COLOR;
        messageLabel.text = @"Internet connection error";
        [window bringSubviewToFront:internetDownAlert];
        internetDownAlert.alpha = 1.0f;
        
        // Invalidate timer.
        if ([alertTimer isValid]) {
            
            [alertTimer invalidate];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = internetDownAlert.frame;
            frame.origin.y = 0;
            internetDownAlert.frame = frame;
            
            // Set alert present flag.
            isAlertPresent = YES;
        } completion:^(BOOL finished) {
            
         
            alertTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startAlertTimer:) userInfo:nil repeats:NO];
        }];
    }
}

/*!
 *  Method to show alert with message and color code parameters.
 */
- (void)showInternetWorkingFineAlertWithMessage {
    
    if (!isAlertPresent) {
        
        // Show internet alert.
        internetDownAlert.backgroundColor = GREEN_COLOR;
        messageLabel.text = @"Internet working fine";
        [window bringSubviewToFront:internetDownAlert];
        internetDownAlert.alpha = 1.0f;
        
        // Invalidate timer.
        if ([alertTimer isValid]) {
            
            [alertTimer invalidate];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = internetDownAlert.frame;
            frame.origin.y = 0;
            internetDownAlert.frame = frame;
            
            // Set alert present flag.
            isAlertPresent = YES;
        } completion:^(BOOL finished) {
            
            alertTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startAlertTimer:) userInfo:nil repeats:NO];
        }];
    }
}

/*!
 *  Method to handle custom alertView animation duration.
 */
- (void)startAlertTimer:(NSTimer *)timer {
    
    [UIView animateWithDuration:0.4 animations:^{
        
        internetDownAlert.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.0 animations:^{
            CGRect frame = internetDownAlert.frame;
            frame.origin.y = -64;
            internetDownAlert.frame = frame;
            internetDownAlert.alpha = 1.0f;
            
            // Set alert present flag.
            isAlertPresent = NO;
        } completion:nil];
    }];
}

@end
