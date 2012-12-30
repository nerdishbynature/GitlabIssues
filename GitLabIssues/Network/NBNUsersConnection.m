//
//  NBNUsersConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 18.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNUsersConnection.h"
#import "ASIHTTPRequest.h"
#import "Domain.h"
#import "Session.h"
#import "Assignee.h"

@implementation NBNUsersConnection

+(NSArray *)loadMembersWithProjectID:(NSUInteger)project_id{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    Session *firstSession = [[Session findAll] objectAtIndex:0];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%i/members?private_token=%@", domain.protocol, domain.domain, project_id, firstSession.private_token]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSArray *memberJSONArray = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
    
    NSMutableArray *memberArray = [[NSMutableArray alloc] initWithCapacity:memberJSONArray.count];
    
    for (NSDictionary *dict in memberJSONArray) {
        [memberArray addObject:[Assignee createAndParseJSON:dict]];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    return memberArray;
}

@end
