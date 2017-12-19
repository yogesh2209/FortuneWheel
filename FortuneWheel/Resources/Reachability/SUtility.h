//
//  SUtility.h
//  Schoofi23June
//
//  Created by Schoofi on 06/07/15.
//  Copyright (c) 2015 YashuMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUtility : NSObject

@property (assign, nonatomic) BOOL isInternetConnection;

+ (SUtility *)sharedDetails;

@end
