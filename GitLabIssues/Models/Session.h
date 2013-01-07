//
//  Session.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Session : NSManagedObject

@property (nonatomic, retain) NSNumber * blocked;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * private_token;

/**
 @brief Generates a new session using the API
 @return Initialized Session object
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/session.md
 */
+(Session *)generateSession;

+(void)generateSessionWithCompletion:(void (^)(Session *session))block onError:(void (^)(NSError *error))errorBlock;

@end
