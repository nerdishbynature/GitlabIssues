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
 Singleton used to access the methods
 @return Initialized object
 */
+ (NBNLabelsConnection *) sharedConnection;

/**
  Loads all Labels for the specified project.
 @param projectID The gitlab project identifier
 @param block The completion Block which is called on success
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/notes.md#list-issue-notes
 */
-(void)loadAllLabelsForProjectID:(NSUInteger)projectID onSuccess:(void (^)(void))block;

/**
 Cancels ongoing request
 */
- (void) cancelLabelsRequest;

@end
