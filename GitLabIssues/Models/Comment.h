//
//  Comment.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Author;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) Author *author;

@end
