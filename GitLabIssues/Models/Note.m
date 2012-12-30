//
//  Note.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "Note.h"
#import "Author.h"


@implementation Note

@dynamic body;
@dynamic created_at;
@dynamic identifier;
@dynamic author;

+(Note *)createAndParseJSON:(NSDictionary *)dict{
    Note *note = [Note createEntity];
    [note parseServerResponse:dict];
    
    return note;
}

-(void)parseServerResponse:(NSDictionary *)dict{
    self.identifier = [NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]];
    
    if ([dict objectForKey:@"body"]) {
        self.body = [dict objectForKey:@"body"];
    }
    
    if ([dict objectForKey:@"author"]) {
        self.author = [Author createAndParseJSON:[dict objectForKey:@"author"]];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    
    self.created_at = [formatter dateFromString:[dict objectForKey:@"created_at"]];
}

@end
