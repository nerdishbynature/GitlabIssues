//
//  Issue.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assignee, Author, Milestone, Note;

@interface Issue : NSManagedObject

/**
 Specifies whether the issue is closed or not
 */
@property (nonatomic, retain) NSNumber * closed;

/**
 Date object when the issue was created (specified by the API)
 */
@property (nonatomic, retain) NSDate * created_at;

/**
 String containing the description
 */
@property (nonatomic, retain) NSString * descriptionString;

/**
 Returned ID (API)
 */
@property (nonatomic, retain) NSNumber * identifier;

/**
 Returned labels
 */
@property (nonatomic, retain) id labels;

/**
 Associated project ID
 */
@property (nonatomic, retain) NSNumber * project_id;

/**
 Title of the issue
 */
@property (nonatomic, retain) NSString * title;

/**
 Date object when the issue was updated (specified by the API)
 */
@property (nonatomic, retain) NSDate * updated_at;

/**
 Assigned user
 */
@property (nonatomic, retain) Assignee *assignee;

/**
 Author of the issue
 */
@property (nonatomic, retain) Author *author;

/**
 Associated milestone object
 */
@property (nonatomic, retain) Milestone *milestone;

/**
 Contains the Notes of an issue
 */
@property (nonatomic, retain) NSSet *notes;

/**
 This method is used for parsing the returned JSON from the API
 @param dict The JSON dictionary
 @return Initialized User object
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/issues.md#single-issue
 */
+(Issue *)createAndParseJSON:(NSDictionary *)dict;

/**
 Only used for FormKit
 */
-(void)save;

/**
 Saves object in local database and PUTs the new data on the Server using the GitLab API
 @param block The completion block, which is called on success
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/issues.md#edit-issue
 */
-(void)saveChangesonSuccess:(void (^)(void))block;

/**
 Saves object in local database and POSTs the new data on the Server using the GitLab API
 @param block The completion block, which is called on success
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/issues.md#new-issue
 */
-(void)createANewOnServerOnSuccess:(void(^)(void))block;

/**
 Catches the object and updates the data
 @param dict The JSON dictionary
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/issues.md#single-issue
 */
-(void)parseServerResponse:(NSDictionary *)dict;

@end

@interface Issue (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
