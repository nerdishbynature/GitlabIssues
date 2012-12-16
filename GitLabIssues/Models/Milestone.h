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
@end

@interface Milestone (CoreDataGeneratedAccessors)

- (void)addIssueObject:(Issue *)value;
- (void)removeIssueObject:(Issue *)value;
- (void)addIssue:(NSSet *)values;
- (void)removeIssue:(NSSet *)values;

@end
