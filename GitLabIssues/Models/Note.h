//
//  Note.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Author;
@class Issue;

@interface Note : NSManagedObject

@property (nonatomic, strong) NSString * body;
@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSNumber * identifier;
@property (nonatomic, strong) Author *author;
@property (nonatomic, strong) Issue *issue;

+(Note *)createAndParseJSON:(NSDictionary *)dict;

-(void)parseServerResponse:(NSDictionary *)dict;

@end
