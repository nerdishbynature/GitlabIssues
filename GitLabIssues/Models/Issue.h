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

@property (nonatomic, retain) NSNumber * closed;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * descriptionString;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) id labels;
@property (nonatomic, retain) NSNumber * project_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Assignee *assignee;
@property (nonatomic, retain) Author *author;
@property (nonatomic, retain) Milestone *milestone;
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
