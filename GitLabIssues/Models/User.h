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

@property (nonatomic, strong) NSString * bio;
@property (nonatomic, strong) NSNumber * blocked;
@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSNumber * dark_scheme;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSNumber * identifier;
@property (nonatomic, strong) NSString * linkedin;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * skype;
@property (nonatomic, strong) NSNumber * theme_id;
@property (nonatomic, strong) NSString * twitter;

/**
  This method is used for parsing the returned JSON from the API
 @param dict The JSON dictionary
 @return Initialized User object
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/users.md#single-user
 */
+(User *)createAndParseJSON:(NSDictionary *)dict;

@end
