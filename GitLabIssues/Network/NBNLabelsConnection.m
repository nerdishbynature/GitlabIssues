//
//  NBNLabelsConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNLabelsConnection.h"
#import "ASIHTTPRequest.h"
#import "Domain.h"
#import "Session.h"


@implementation NBNLabelsConnection

+(void)loadAllLabelsForProjectID:(NSUInteger)projectID onSuccess:(void (^)(void))block{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    Session *session;
    
    if ([Session findAll].count > 0) {
        session = [[Session findAll] objectAtIndex:0]; //there can only be one
    } else{
        session = [Session generateSession];
    }
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%i/labels?private_token=%@", domain.protocol, domain.domain, projectID, session.private_token]];
    PBLog(@"%@", url);
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
//        NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
//        
//        for (NSDictionary *dict in array) {
//            
//            NSPredicate *issueFinder = [NSPredicate predicateWithFormat:@"identifier = %i AND project_id = %i", [[dict objectForKey:@"id"] integerValue], projectID];
//            
//            if ([[Milestone MR_findAllWithPredicate:issueFinder] count] == 0) {
//                
//                [Milestone createAndParseJSON:dict andProjectID:projectID];
//            }
//        }
        PBLog(@"not yet supported");
        block();
    }];
    
    [request setFailedBlock:^{
        PBLog(@"err %@", [request error]);
    }];
    
    [request startAsynchronous];
}


@end
