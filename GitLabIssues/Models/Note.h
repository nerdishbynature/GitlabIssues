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

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) Author *author;
@property (nonatomic, retain) Issue *issue;

+(Note *)createAndParseJSON:(NSDictionary *)dict;

-(void)parseServerResponse:(NSDictionary *)dict;

@end
