//
//  Project.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Owner, Filter;

@interface Project : NSManagedObject

@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSString * default_branch;
@property (nonatomic, strong) NSString * descriptionString;
@property (nonatomic, strong) NSNumber * identifier;
@property (nonatomic, strong) NSNumber * issues_enabled;
@property (nonatomic, strong) NSNumber * merge_requests_enabled;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * path;
@property (nonatomic, strong) NSNumber * private;
@property (nonatomic, strong) NSNumber * wall_enabled;
@property (nonatomic, strong) NSNumber * wiki_enabled;
@property (nonatomic, strong) Owner *owner;
@property (nonatomic, strong) NSNumber * isFavorite;
@property (nonatomic, strong) Filter *filter;
@property (nonatomic, strong) NSDate *lastOpened;

/**
 This method is used for parsing the returned JSON from the API
 @param json The JSON dictionary
 @return Initialized Project object
 */
+(Project *)createAndParseJSON:(NSDictionary *)json;

/**
  Parses the specified dictionary and updates the model
 @param dict The JSON dictionary
 */
-(void)parseServerResponseWithDict:(NSDictionary *)dict;


@end
