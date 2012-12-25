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

/**
 @brief Loads all project for the specified domain object.
 @param domain The domain object
 @param block The completion Block which is called on success
 @see http://www.github.com/gitlabhq/gitlabhq/docs/api/
 */
+(void)loadProjectsForDomain:(Domain *)domain onSuccess:(void (^)(void))block;

@end
