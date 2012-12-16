//
//  NBNProjectConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNProjectConnection.h"


@implementation NBNProjectConnection

+(void)loadProjectsForDomain:(Domain *)domain onSuccess:(void (^)(void))block{
    
    Session *session = [Session generateSession];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v2/projects?private_token=%@", domain.protocol, domain.domain, session.private_token]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
        
        for (NSDictionary *dict in array) {
            
            NSPredicate *projectFinder = [NSPredicate predicateWithFormat:@"identifier = %i", [[dict objectForKey:@"id"] integerValue]]; // 1 domain means no conflicts
            
            if ([[Project MR_findAllWithPredicate:projectFinder] count] == 0) {
                [Project createAndParseJSON:dict];
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
