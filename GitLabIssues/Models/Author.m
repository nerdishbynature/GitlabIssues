//
//  Author.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "Author.h"
#import "Issue.h"
#import "MergeRequest.h"
#import "Note.h"
#import "Snippet.h"


@implementation Author

@dynamic blocked;
@dynamic created_at;
@dynamic email;
@dynamic identifier;
@dynamic name;
@dynamic issues;
@dynamic mergeRequests;
@dynamic notes;
@dynamic snippets;

+(Author *)createAndParseJSON:(NSDictionary *)dict{
    Author *author = [Author createEntity];
    /*{
     
     "id": 1,
     "email": "john@example.com",
     "name": "John Smith",
     "blocked": false,
     "created_at": "2012-05-23T08:00:58Z",
     "access_level": 40
     }*/
    if ([(NSNull *)dict isMemberOfClass:[NSNull class]]) {
        return author;
    }
    author.identifier = [NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]];
    author.email = [dict objectForKey:@"email"];
    author.name = [dict objectForKey:@"name"];
    //self.blocked = [NSNumber numberWithInt:[[dict valueForKey:@"blocked"] integerValue]];
    
    return author;
}

@end
