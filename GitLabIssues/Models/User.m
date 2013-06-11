//
//  User.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic bio;
@dynamic blocked;
@dynamic created_at;
@dynamic dark_scheme;
@dynamic email;
@dynamic identifier;
@dynamic linkedin;
@dynamic name;
@dynamic skype;
@dynamic theme_id;
@dynamic twitter;

+(User *)createAndParseJSON:(NSDictionary *)dict{
    User *user = [User MR_createEntity];
    /*{
     
     "id": 1,
     "email": "john@example.com",
     "name": "John Smith",
     "blocked": false,
     "created_at": "2012-05-23T08:00:58Z",
     "access_level": 40
     }*/
    if ([(NSNull *)dict isMemberOfClass:[NSNull class]]) {
        return user;
    }
    user.identifier = [NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]];
    user.email = [dict objectForKey:@"email"];
    user.name = [dict objectForKey:@"name"];
    user.blocked = [NSNumber numberWithInt:[[dict valueForKey:@"blocked"] integerValue]];
    
    return user;
}

@end
