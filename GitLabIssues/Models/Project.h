//
//  Project.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Owner;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * default_branch;
@property (nonatomic, retain) NSString * descriptionString;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * issues_enabled;
@property (nonatomic, retain) NSNumber * merge_requests_enabled;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * private;
@property (nonatomic, retain) NSNumber * wall_enabled;
@property (nonatomic, retain) NSNumber * wiki_enabled;
@property (nonatomic, retain) Owner *owner;
@property (nonatomic, retain) NSNumber * isFavorite;

+(Project *)createAndParseJSON:(NSDictionary *)json;

@end
