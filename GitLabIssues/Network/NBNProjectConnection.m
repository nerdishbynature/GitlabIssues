//
//  NBNProjectConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNProjectConnection.h"
#import "User.h"


@implementation NBNProjectConnection

+(void)loadProjectsForDomain:(Domain *)domain onSuccess:(void (^)(void))block{
    
    if ([Session findAll].count > 0) {
        Session *session = [[Session findAll] lastObject];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects?private_token=%@", domain.protocol, domain.domain, session.private_token]];
        
        PBLog(@"%@", url);
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request setCompletionBlock:^{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
            
            for (NSDictionary *dict in array) {
                
                NSPredicate *projectFinder = [NSPredicate predicateWithFormat:@"identifier = %i", [[dict objectForKey:@"id"] integerValue]]; // 1 domain means no conflicts
                
                if ([[Project MR_findAllWithPredicate:projectFinder] count] == 0) { // new Project
                    [Project createAndParseJSON:dict];
                } else if ([[Project MR_findAllWithPredicate:projectFinder] count] == 1){ // update Project
                    Project *project = [[[[[NSManagedObjectContext defaultContext] ofType:@"Project"] where:@"identifier == %i", [[dict objectForKey:@"id"] integerValue]] toArray] objectAtIndex:0];
                    [project parseServerResponseWithDict:dict];
                }
            }
            
            block();
        }];
        
        [request setFailedBlock:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:request.error.localizedFailureReason message:request.error.localizedDescription delegate:nil cancelButtonTitle:@"Dimiss" otherButtonTitles:nil];
            [alert show];
            PBLog(@"err %i", [request responseStatusCode]);
        }];
        
        [request startAsynchronous];
    } else{
        [Session generateSessionWithCompletion:^(Session *session) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects?private_token=%@", domain.protocol, domain.domain, session.private_token]];
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:request.error.localizedFailureReason message:request.error.localizedDescription delegate:nil cancelButtonTitle:@"Dimiss" otherButtonTitles:nil];
                [alert show];
                PBLog(@"err %@", [request error]);
            }];
            
            [request startAsynchronous];
        } onError:^(NSError *error) {
            
        }];
    }
}

+(void)loadMembersForProject:(Project *)project onSuccess:(void (^)(void))block{
    Session *session = [[Session findAll] objectAtIndex:0];
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/members?private_token=%@", domain.protocol, domain.domain, project.identifier, session.private_token]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
        
        for (NSDictionary *dict in array) {
            
            NSPredicate *userFinder = [NSPredicate predicateWithFormat:@"identifier = %i", [[dict objectForKey:@"id"] integerValue]]; // 1 domain means no conflicts
            
            if ([[User MR_findAllWithPredicate:userFinder] count] == 0) {
                [User createAndParseJSON:dict];
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
