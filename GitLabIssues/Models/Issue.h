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
@property (nonatomic, strong) NSNumber * closed;

/**
 Date object when the issue was created (specified by the API)
 */
@property (nonatomic, strong) NSDate * created_at;

/**
 String containing the description
 */
@property (nonatomic, strong) NSString * descriptionString;

/**
 Returned ID (API)
 */
@property (nonatomic, strong) NSNumber * identifier;

/**
 Returned labels
 */
@property (nonatomic, strong) id labels;

/**
 Associated project ID
 */
@property (nonatomic, strong) NSNumber * project_id;

/**
 Title of the issue
 */
@property (nonatomic, strong) NSString * title;

/**
 Date object when the issue was updated (specified by the API)
 */
@property (nonatomic, strong) NSDate * updated_at;

/**
 Assigned user
 */
@property (nonatomic, strong) Assignee *assignee;

/**
 Author of the issue
 */
@property (nonatomic, strong) Author *author;

/**
 Associated milestone object
 */
@property (nonatomic, strong) Milestone *milestone;

/**
 Contains the Notes of an issue
 */
@property (nonatomic, strong) NSSet *notes;

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
-(void)saveChangesonSuccess:(void (^)(BOOL success))block;

/**
 Saves object in local database and POSTs the new data on the Server using the GitLab API
 @param block The completion block, which is called on success
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/issues.md#new-issue
 */
-(void)createANewOnServerOnSuccess:(void(^)(BOOL success))block;

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
