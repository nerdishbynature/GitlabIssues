//
//  NBNIssuesConnection.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"
#import "Issue.h"

@interface NBNIssuesConnection : NSObject

+ (NBNIssuesConnection *) sharedConnection;

/**
  Loads all issues for the specified project.
 @param project The project object
 @param block The completion Block which is called on success
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/issues.md#list-project-issues
 */
-(void)loadIssuesForProject:(Project *)project onSuccess:(void (^)(void))block;

/**
 Cancels the connection
 */
-(void)cancelIssuesConnection;

/**
 Reloads the specified issue using the API
 @param issue the issue object used to reload
 @param block The completion block called on success
 */
-(void)reloadIssue:(Issue *)issue onSuccess:(void(^)(void))block;

/**
 Cancels the connection
 */
-(void)cancelReloadConnection;

/**
 Loads all notes for the specified issue.
 @param issue The issue object
 @param block The completion Block which is called on success
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/notes.md#list-issue-notes
 */
-(void)loadNotesForIssue:(Issue *)issue onSuccess:(void (^)(NSArray *))block;

/**
 Cancels the connection
 */
-(void)cancelNotesConnection;

/**
  Send a new Note to the server
 @param issue The issue object
 @param body The Note body
 @param block The completion block which is called on success
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/notes.md#new-issue-note
 */
-(void)sendNoteForIssue:(Issue *)issue andBody:(NSString *)body onSuccess:(void (^)(void))block;

/**
 Cancels the connection
 */
-(void)cancelSendNotesConnection;

/**
  Loads all issues for the current domain
 @param block The completion block, which is called on success
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/issues.md#list-issues
 */
-(void)loadAllIssuesOnSuccess:(void(^)(void))block;

/**
 Cancels the connection
 */
-(void)cancelAllIssuesConnection;

@end
