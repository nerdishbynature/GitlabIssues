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
@dynamic issue;

+(Note *)createAndParseJSON:(NSDictionary *)dict{
    Note *note = [Note MR_createEntity];
    [note parseServerResponse:dict];
    
    return note;
}

-(void)parseServerResponse:(NSDictionary *)dict{
    self.identifier = [NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]];
    
    if ([dict objectForKey:@"body"]) {
        self.body = [dict objectForKey:@"body"];
    }
    
    if ([dict objectForKey:@"author"]) {
        NSArray *authorArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Author"] where:@"identifier == %@", [[dict objectForKey:@"author"] objectForKey:@"id"] ] toArray];
        
        if (authorArray.count > 0) {
            self.author = [authorArray objectAtIndex:0];
        } else{
            self.author = [Author createAndParseJSON:[dict objectForKey:@"author"]];
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    
    self.created_at = [formatter dateFromString:[dict objectForKey:@"created_at"]];
    
    [formatter release];
}

@end
