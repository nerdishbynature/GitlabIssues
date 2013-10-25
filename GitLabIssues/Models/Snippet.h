//
//  Snippet.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Author;

@interface Snippet : NSManagedObject

@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSDate * expires_at;
@property (nonatomic, strong) NSString * file_name;
@property (nonatomic, strong) NSNumber * identifier;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSDate * updated_at;
@property (nonatomic, strong) Author *author;

@end
