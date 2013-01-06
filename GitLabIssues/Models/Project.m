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
    
    project.identifier = [NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]];
    project.code = [dict objectForKey:@"code"];
    project.name = [dict objectForKey:@"name"];
    project.isFavorite = [NSNumber numberWithBool:NO];
    
    if (![dict objectForKey:@"description"]) {
        project.descriptionString = [dict objectForKey:@"description"];
    }
    
    if (![dict objectForKey:@"default_branch"]) {
        project.default_branch = [dict objectForKey:@"default_branch"];
    }
    
    project.path = [dict objectForKey:@"path"];
    
    
    project.private = [NSNumber numberWithBool:[[dict objectForKey:@"private"] boolValue]];
    project.issues_enabled = [NSNumber numberWithBool:[[dict objectForKey:@"issures_enabled"] boolValue]];
    project.merge_requests_enabled = [NSNumber numberWithBool:[[dict objectForKey:@"merge_requests_enabled"] boolValue]];
    project.wall_enabled = [NSNumber numberWithBool:[[dict objectForKey:@"wall_enabled"] boolValue]];
    project.wiki_enabled = [NSNumber numberWithBool:[[dict objectForKey:@"wiki_enabled"] boolValue]];
    project.filter = [Filter loadDefaultFilter];
    
    return project;
}

@end
