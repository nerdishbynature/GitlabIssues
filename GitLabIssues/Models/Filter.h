//
//  Filter.h
//  GitLabIssues
//
//  Created by Piet Brauer on 01.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assignee, Milestone;

@interface Filter : NSManagedObject

@property (nonatomic, retain) id labels;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * sortCreated;
@property (nonatomic, retain) Assignee *assigned;
@property (nonatomic, retain) Milestone *milestone;

@end
