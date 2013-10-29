//
//  Milestone.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Issue, Filter;

@interface Milestone : NSManagedObject

@property (nonatomic, strong) NSNumber * closed;
@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSString * descriptionString;
@property (nonatomic, strong) NSDate * due_date;
@property (nonatomic, strong) NSNumber * identifier;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSSet *issue;
@property (nonatomic, strong) NSNumber *project_id;
@property (nonatomic, strong) Filter *filter;

/**
  This method is used for parsing the returned JSON from the API
 @param dict The JSON dictionary
 @param projectID The associated gitlab project identifier. 
 This is used for creating the fetch request and only load the related milestones for a project. This parameter is not returned via the API, sadly.
 @return Initialized User object
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/milestones.md#single-milestone
 */
+(Milestone *)createAndParseJSON:(NSDictionary *)dict andProjectID:(NSUInteger)projectID;

/**
  This method parses the Server response.
 @param dict The JSON Dictionary containing the server response
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/milestones.md#single-milestone
 */
-(void)parseServerResponseWithDict:(NSDictionary *)dict;

@end

@interface Milestone (CoreDataGeneratedAccessors)

- (void)addIssueObject:(Issue *)value;
- (void)removeIssueObject:(Issue *)value;
- (void)addIssue:(NSSet *)values;
- (void)removeIssue:(NSSet *)values;

@end
