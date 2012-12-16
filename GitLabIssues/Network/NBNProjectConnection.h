//
//  NBNProjectConnection.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "Project.h"
#import "Domain.h"
#import "Session.h"

@interface NBNProjectConnection : NSObject

+(void)loadProjectsForDomain:(Domain *)domain onSuccess:(void (^)(void))block;

@end
