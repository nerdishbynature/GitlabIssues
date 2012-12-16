//
//  NBNIssuesConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNIssuesConnection.h"
#import "Session.h"
#import "Project.h"
#import "Domain.h"
#import "Issue.h"
#import "ASIHTTPRequest.h"

@implementation NBNIssuesConnection

+(void)loadIssuesForProject:(Project *)project onSuccess:(void (^)(void))block{
    
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    Session *session;
    
    if ([Session findAll].count > 0) {
        session = [[Session findAll] objectAtIndex:0]; //there can only be one
    } else{
        session = [Session generateSession];
    }
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v2/projects/%@/issues?private_token=%@", domain.protocol, domain.domain, project.identifier, session.private_token]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
        
        for (NSDictionary *dict in array) {
            
            NSPredicate *issueFinder = [NSPredicate predicateWithFormat:@"identifier = %i", [[dict objectForKey:@"id"] integerValue]]; // 1 domain means no conflicts
            
            if ([[Issue MR_findAllWithPredicate:issueFinder] count] == 0) {
            
                [Issue createAndParseJSON:dict];
            }
        }
        block();
    }];
    
    [request setFailedBlock:^{
        PBLog(@"err %@", [request error]);
    }];
    
    [request startAsynchronous];
}

@end
