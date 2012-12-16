//
//  Issue.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assignee, Author, Milestone;

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

@end
