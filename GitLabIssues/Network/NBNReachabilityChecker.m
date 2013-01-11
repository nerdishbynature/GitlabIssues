//
//  NBNReachabilityChecker.m
//  GitLabIssues
//
//  Created by Piet Brauer on 11.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNReachabilityChecker.h"
#import "Reachability.h"

@implementation NBNReachabilityChecker

+(BOOL)isReachable{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

@end
