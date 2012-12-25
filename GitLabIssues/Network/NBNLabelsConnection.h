//
//  NBNLabelsConnection.h
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBNLabelsConnection : NSObject

/**
 @brief Loads all Labels for the specified project.
 @param projectID The gitlab project identifier
 @param block The completion Block which is called on success
 @see http://www.github.com/gitlabhq/gitlabhq/docs/api/
 */
+(void)loadAllLabelsForProjectID:(NSUInteger)projectID onSuccess:(void (^)(void))block;

@end
