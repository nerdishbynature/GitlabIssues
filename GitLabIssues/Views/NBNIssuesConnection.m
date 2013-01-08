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
#import "Note.h"
#import "ASIHTTPRequest.h"

@implementation NBNIssuesConnection

+(void)loadIssuesForProject:(Project *)project onSuccess:(void (^)(void))block{
    
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    Session *session;
    
    if ([Session findAll].count > 0) {
        session = [[Session findAll] lastObject]; //there can only be one
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues?private_token=%@", domain.protocol, domain.domain, project.identifier, session.private_token]];
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request setCompletionBlock:^{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
            
            for (NSDictionary *dict in array) {
                
                NSPredicate *issueFinder = [NSPredicate predicateWithFormat:@"identifier = %i", [[dict objectForKey:@"id"] integerValue]]; // 1 domain means no conflicts
                
                if ([[Issue MR_findAllWithPredicate:issueFinder] count] == 0) {
                    
                    [Issue createAndParseJSON:dict];
                } else if ([[Issue MR_findAllWithPredicate:issueFinder] count] == 1){
                    
                    Issue *issue = [[Issue MR_findAllWithPredicate:issueFinder] objectAtIndex:0];
                    [issue parseServerResponse:dict];
                    
                }
            }
            block();
        }];
        
        [request setFailedBlock:^{
            PBLog(@"err %@", [request error]);
        }];
        
        [request startAsynchronous];
        
    } else{
        
        [Session generateSessionWithCompletion:^(Session *session) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues?private_token=%@", domain.protocol, domain.domain, project.identifier, session.private_token]];
            __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            
            [request setCompletionBlock:^{
                NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
                
                for (NSDictionary *dict in array) {
                    
                    NSPredicate *issueFinder = [NSPredicate predicateWithFormat:@"identifier = %i", [[dict objectForKey:@"id"] integerValue]]; // 1 domain means no conflicts
                    
                    if ([[Issue MR_findAllWithPredicate:issueFinder] count] == 0) {
                        
                        [Issue createAndParseJSON:dict];
                    } else if ([[Issue MR_findAllWithPredicate:issueFinder] count] == 1){
                        
                        Issue *issue = [[Issue MR_findAllWithPredicate:issueFinder] objectAtIndex:0];
                        [issue parseServerResponse:dict];
                        
                    }
                }
                block();
            }];
            
            [request setFailedBlock:^{
                PBLog(@"err %@", [request error]);
            }];
            
            [request startAsynchronous];
        } onError:^(NSError *error) {
            
        }];
    }
}

+(void)reloadIssue:(Issue *)issue onSuccess:(void(^)(void))block{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    Session *session;
    
    if ([Session findAll].count > 0) {
        session = [[Session findAll] lastObject]; //there can only be one
    } else{
        session = [Session generateSession];
    }
    
    //GET /projects/:id/issues/:issue_id
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@?private_token=%@", domain.protocol, domain.domain, issue.project_id, issue.identifier, session.private_token]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
        
        [issue parseServerResponse:returnDict];
        
        block();
    }];
    
    [request setFailedBlock:^{
        PBLog(@"err %@", [request error]);
    }];
    
    [request startAsynchronous];
}

+(void)loadNotesForIssue:(Issue *)issue onSuccess:(void (^)(NSArray *))block{
    
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    Session *session;
    
    if ([Session findAll].count > 0) {
        session = [[Session findAll] lastObject]; //there can only be one
    } else{
        session = [Session generateSession];
    }
    
    //GET /projects/:id/issues/:issue_id/notes
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@/notes?private_token=%@", domain.protocol, domain.domain, issue.project_id, issue.identifier, session.private_token]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
        NSMutableArray *returnArray = [[[NSMutableArray alloc] initWithCapacity:array.count] autorelease];
        
        for (NSDictionary *dict in array) {
            
            NSPredicate *noteFinder = [NSPredicate predicateWithFormat:@"identifier = %i", [[dict objectForKey:@"id"] integerValue]]; // 1 domain means no conflicts
            
            if ([[Note MR_findAllWithPredicate:noteFinder] count] == 0) {
                
                [returnArray addObject:[Note createAndParseJSON:dict]];
            
            } else if ([[Note MR_findAllWithPredicate:noteFinder] count] == 1){
                
                Note *note = [[Note MR_findAllWithPredicate:noteFinder] objectAtIndex:0];
                [note parseServerResponse:dict];
                note.issue = issue;
                
                [returnArray addObject:note];
            }
        }
        block(returnArray);
    }];
    
    [request setFailedBlock:^{
        PBLog(@"err %@", [request error]);
    }];
    
    [request startAsynchronous];
}

+(void)sendNoteForIssue:(Issue *)issue andBody:(NSString *)body onSuccess:(void (^)(void))block{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    Session *session;
    
    if ([Session findAll].count > 0) {
        session = [[Session findAll] lastObject]; //there can only be one
    } else{
        session = [Session generateSession];
    }
    
    //POST /projects/:id/issues/:issue_id/notes
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@/notes?private_token=%@", domain.protocol, domain.domain, issue.project_id, issue.identifier, session.private_token]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    
    NSDictionary *postDict = @{@"id": issue.project_id, @"issue_id":issue.identifier, @"body": body};
    
    [request appendPostData:[NSJSONSerialization dataWithJSONObject:postDict options:kNilOptions error:nil]];
    [request startSynchronous];
    
    if (request.error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:request.responseStatusMessage message:request.error.localizedFailureReason delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        [alert release];
        PBLog(@"%@", request.error);
    } else{
        block();
    }

}

+(void)loadAllIssuesOnSuccess:(void(^)(void))block{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    Session *session;
    
    if ([Session findAll].count > 0) {
        session = [[Session findAll] lastObject]; //there can only be one
    } else{
        session = [Session generateSession];
    }
    
    //GET /issues/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/issues/?private_token=%@", domain.protocol, domain.domain, session.private_token]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
        
        for (NSDictionary *dict in array) {
            
            NSPredicate *issueFinder = [NSPredicate predicateWithFormat:@"identifier = %i", [[dict objectForKey:@"id"] integerValue]]; // 1 domain means no conflicts
            
            if ([[Issue MR_findAllWithPredicate:issueFinder] count] == 0) {
                
                [Issue createAndParseJSON:dict];
                
            } else if ([[Issue MR_findAllWithPredicate:issueFinder] count] == 1){
                
                Issue *issue = [[Issue MR_findAllWithPredicate:issueFinder] objectAtIndex:0];
                [issue parseServerResponse:dict];
                
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
