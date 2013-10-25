//
//  Filter.h
//  GitLabIssues
//
//  Created by Piet Brauer on 01.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assignee, Milestone, Project;

@interface Filter : NSManagedObject

/**
 Labels array used to store the labels which the search results should contain
 */
@property (nonatomic, strong) id labels;

/**
 Specifies if the Filter should present only closed issues
 */
@property (nonatomic, strong) NSNumber * closed;

/**
 Decides whether it the Filter searches created or updated
 */
@property (nonatomic, strong) NSNumber * sortCreated;

/**
 The assignee which the search results should contain
 */
@property (nonatomic, strong) Assignee *assigned;

/**
 The milestone which the search results should contain
 */
@property (nonatomic, strong) Milestone *milestone;

/**
 The project which the search results should contain
 */
@property (nonatomic, strong) Project *project;

/**
 Loads the default filter with presets.
 */
+(Filter *)loadDefaultFilter;

@end
