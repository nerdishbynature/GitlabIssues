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

/**
  This method is used for parsing the returned JSON from the API
 @param dict The JSON dictionary
 @return Initialized User object
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/users.md#single-user
 */
+(User *)createAndParseJSON:(NSDictionary *)dict;

@end
