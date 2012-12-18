//
//  NBNMilestoneConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNMilestoneConnection.h"
#import "Domain.h"
#import "Session.h"
#import "Milestone.h"
#import "ASIHTTPRequest.h"

@implementation NBNMilestoneConnection

+(void)loadAllMilestonesForProjectID:(NSUInteger)projectID onSuccess:(void (^)(void))block{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    Session *session;
    
    if ([Session findAll].count > 0) {
        session = [[Session findAll] objectAtIndex:0]; //there can only be one
    } else{
        session = [Session generateSession];
    }
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v2/projects/%i/milestones?private_token=%@", domain.protocol, domain.domain, projectID, session.private_token]];
    PBLog(@"%@", url);
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
        
        for (NSDictionary *dict in array) {
            
            NSPredicate *issueFinder = [NSPredicate predicateWithFormat:@"identifier = %i AND project_id = %i", [[dict objectForKey:@"id"] integerValue], projectID];
            
            if ([[Milestone MR_findAllWithPredicate:issueFinder] count] == 0) {
                
                [Milestone createAndParseJSON:dict andProjectID:projectID];
            }
        }
        block();
    }];
    
    [request setFailedBlock:^{
        PBLog(@"err %@", [request error]);
    }];
    
    [request startAsynchronous];
}



+(NSArray *)loadMilestonesWithProjectID:(NSUInteger)projectID{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    Session *firstSession = [[Session findAll] objectAtIndex:0];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v2/projects/%i/milestones?private_token=%@", domain.protocol, domain.domain, projectID, firstSession.private_token]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSArray *milestoneJSONArray = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
    NSMutableArray *milestoneArray = [[NSMutableArray alloc] initWithCapacity:milestoneJSONArray.count];
    
    for (NSDictionary *dict in milestoneJSONArray) {
        Milestone *milestone = [Milestone createAndParseJSON:dict andProjectID:projectID];
        [milestoneArray addObject:milestone];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    return milestoneArray;
}


@end
