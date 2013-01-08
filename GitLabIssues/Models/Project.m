//
//  Project.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "Project.h"
#import "Owner.h"
#import "Filter.h"


@implementation Project

@dynamic code;
@dynamic created_at;
@dynamic default_branch;
@dynamic descriptionString;
@dynamic identifier;
@dynamic issues_enabled;
@dynamic merge_requests_enabled;
@dynamic name;
@dynamic path;
@dynamic private;
@dynamic wall_enabled;
@dynamic wiki_enabled;
@dynamic owner;
@dynamic isFavorite;
@dynamic filter;

+(Project *)createAndParseJSON:(NSDictionary *)dict{
    Project *project = [Project createEntity];
    
    [project parseServerResponseWithDict:dict];
    project.isFavorite = [NSNumber numberWithBool:NO];
    project.filter = [Filter loadDefaultFilter];
    
    return project;
}

-(void)parseServerResponseWithDict:(NSDictionary *)dict{
    /*{
     "id": 5,
     "code": "gitlab",
     "name": "gitlab",
     "description": null,
     "path": "gitlab",
     "default_branch": "api",
     "owner": {
     "id": 1,
     "email": "john@example.com",
     "name": "John Smith",
     "blocked": false,
     "created_at": "2012-05-23T08:00:58Z"
     },
     "private": true,
     "issues_enabled": true,
     "merge_requests_enabled": true,
     "wall_enabled": true,
     "wiki_enabled": true,
     "created_at": "2012-05-30T12:49:20Z"
     }*/
    
    self.identifier = [NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]];
    self.code = [dict objectForKey:@"code"];
    self.name = [dict objectForKey:@"name"];
    
    if (![dict objectForKey:@"description"]) {
        self.descriptionString = [dict objectForKey:@"description"];
    }
    
    if (![dict objectForKey:@"default_branch"]) {
        self.default_branch = [dict objectForKey:@"default_branch"];
    }
    
    self.path = [dict objectForKey:@"path"];
    
    
    self.private = [NSNumber numberWithBool:[[dict objectForKey:@"private"] boolValue]];
    self.issues_enabled = [NSNumber numberWithBool:[[dict objectForKey:@"issures_enabled"] boolValue]];
    self.merge_requests_enabled = [NSNumber numberWithBool:[[dict objectForKey:@"merge_requests_enabled"] boolValue]];
    self.wall_enabled = [NSNumber numberWithBool:[[dict objectForKey:@"wall_enabled"] boolValue]];
    self.wiki_enabled = [NSNumber numberWithBool:[[dict objectForKey:@"wiki_enabled"] boolValue]];
    
}

@end
