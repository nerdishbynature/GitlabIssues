//
//  NBNReachabilityChecker.h
//  GitLabIssues
//
//  Created by Piet Brauer on 11.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBNReachabilityChecker : NSObject

-(BOOL)isReachable;

+ (NBNReachabilityChecker *) sharedChecker;

@end
