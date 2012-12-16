//
//  NBNIssuesConnection.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"

@interface NBNIssuesConnection : NSObject

+(void)loadIssuesForProject:(Project *)project onSuccess:(void (^)(void))block;

@end
