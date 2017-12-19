//
//  SUtility.m
//  Schoofi23June
//
//  Created by Schoofi on 06/07/15.
//  Copyright (c) 2015 YashuMac. All rights reserved.
//

#import "SUtility.h"

@implementation SUtility


+ (SUtility *)sharedDetails {
    
    static SUtility *commonFile = nil;
    
    if (commonFile == nil) {
        commonFile = [[SUtility alloc] init];
    }
    
    return commonFile;
}


@end
