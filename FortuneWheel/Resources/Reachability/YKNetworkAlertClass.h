//
//  YKNetworkAlertClass.m
//  NetworkCheckClass
//
//  Created by Yogesh Kohli on 12/07/15.
//  Copyright (c) 2016 Yogesh Kohli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//// Internet checking class.
#import "Reachability.h"

@interface YKNetworkAlertClass : NSObject

// Property to check internet connection.
@property (nonatomic) BOOL isInternetActive;

+ (id)sharedManager;
- (void)showInternetErrorAlertWithMessage;
- (void)showInternetWorkingFineAlertWithMessage;

@end
