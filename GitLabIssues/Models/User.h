//
//  User.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSNumber * blocked;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * dark_scheme;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * linkedin;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * skype;
@property (nonatomic, retain) NSNumber * theme_id;
@property (nonatomic, retain) NSString * twitter;

+(User *)createAndParseJSON:(NSDictionary *)dict;

@end
