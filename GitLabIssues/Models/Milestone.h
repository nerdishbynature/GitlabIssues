//
//  Milestone.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Issue;

@interface Milestone : NSManagedObject

@property (nonatomic, retain) NSNumber * closed;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * descriptionString;
@property (nonatomic, retain) NSDate * due_date;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *issue;
@property (nonatomic, retain) NSNumber *project_id;

/**
 @brief This method is used for parsing the returned JSON from the API
 @param dict The JSON dictionary
 @param projectID The associated gitlab project identifier. 
 This is used for creating the fetch request and only load the related milestones for a project. This parameter is not returned via the API, sadly.
 @return Initialized User object
 @see http://www.github.com/gitlabhq/gitlabhq/docs/api/
 @discussion Maybe someone should do a Issue on the GitlabHQ project
 */
+(Milestone *)createAndParseJSON:(NSDictionary *)dict andProjectID:(NSUInteger)projectID;

@end

@interface Milestone (CoreDataGeneratedAccessors)

- (void)addIssueObject:(Issue *)value;
- (void)removeIssueObject:(Issue *)value;
- (void)addIssue:(NSSet *)values;
- (void)removeIssue:(NSSet *)values;

@end
