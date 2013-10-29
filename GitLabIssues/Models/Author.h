//
//  Author.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Issue, MergeRequest, Note, Snippet;

@interface Author : NSManagedObject

@property (nonatomic, strong) NSNumber * blocked;
@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSNumber * identifier;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet *issues;
@property (nonatomic, strong) MergeRequest *mergeRequests;
@property (nonatomic, strong) NSSet *notes;
@property (nonatomic, strong) Snippet *snippets;

/**
  This method is used for parsing the returned JSON from the API
 @param dict The JSON dictionary
 @return Initialized User object
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/issues.md
 */
+(Author *)createAndParseJSON:(NSDictionary *)dict;

-(void)parseServerResonse:(NSDictionary *)dict;

@end

@interface Author (CoreDataGeneratedAccessors)

- (void)addIssuesObject:(Issue *)value;
- (void)removeIssuesObject:(Issue *)value;
- (void)addIssues:(NSSet *)values;
- (void)removeIssues:(NSSet *)values;

@end
