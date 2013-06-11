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
#import "NBNReachabilityChecker.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import <AFNetworking/AFHTTPClient.h>

@interface NBNIssuesConnection ()

@property (nonatomic, retain) AFJSONRequestOperation *issuesOperation;
@property (nonatomic, retain) AFJSONRequestOperation *reloadOperation;
@property (nonatomic, retain) AFJSONRequestOperation *notesOperation;
@property (nonatomic, retain) AFJSONRequestOperation *sendNotesOperation;
@property (nonatomic, retain) AFJSONRequestOperation *allIssuesOperation;

@end

static NBNIssuesConnection *sharedConnection = nil;

@implementation NBNIssuesConnection

+ (NBNIssuesConnection *) sharedConnection {
    
    @synchronized(self){
        
        if (sharedConnection == nil){
            sharedConnection = [[self alloc] init];
        }
    }
    
    return sharedConnection;
}

-(void)loadIssuesForProject:(Project *)project onSuccess:(void (^)(void))block{
    
    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block();
        return;
    }
    
    Domain *domain = [[Domain MR_findAll] lastObject];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
    
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues?private_token=%@", domain.protocol, domain.domain, project.identifier, session.private_token]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        self.issuesOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSArray *array = JSON;
            
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
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            block();
            PBLog(@"err %@", error);
        }];
        
        [self.issuesOperation start];
    }];
}

-(void)cancelIssuesConnection{
    [self.issuesOperation cancel];
}

-(void)reloadIssue:(Issue *)issue onSuccess:(void(^)(void))block{
    
    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block();
        return;
    }
    
    Domain *domain = [[Domain MR_findAll] lastObject];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        //GET /projects/:id/issues/:issue_id
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@?private_token=%@", domain.protocol, domain.domain, issue.project_id, issue.identifier, session.private_token]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        self.reloadOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *returnDict = JSON;
            
            [issue parseServerResponse:returnDict];
            
            block();
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            block();
            PBLog(@"err %@", error);
        }];
        
        [self.reloadOperation start];
    }];
}

-(void)cancelReloadConnection{
    [self.reloadOperation cancel];
}

-(void)loadNotesForIssue:(Issue *)issue onSuccess:(void (^)(NSArray *))block{
    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block(@[]);
        return;
    }

    Domain *domain = [[Domain MR_findAll] lastObject];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        //GET /projects/:id/issues/:issue_id/notes
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@/notes?private_token=%@", domain.protocol,
                                           domain.domain, issue.project_id, issue.identifier, session.private_token]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        self.notesOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSArray *array = JSON;
            NSMutableArray *returnArray = [[[NSMutableArray alloc] initWithCapacity:array.count] autorelease];
            
            for (NSDictionary *dict in array) {
                
                NSPredicate *noteFinder = [NSPredicate predicateWithFormat:@"identifier = %i", [[dict objectForKey:@"id"] integerValue]]; // 1 domain means no conflicts
                
                if ([[Note MR_findAllWithPredicate:noteFinder] count] == 0) {
                    Note *note = [Note createAndParseJSON:dict];
                    note.issue = issue;
                    [returnArray addObject:note];
                } else if ([[Note MR_findAllWithPredicate:noteFinder] count] == 1){
                    
                    Note *note = [[Note MR_findAllWithPredicate:noteFinder] objectAtIndex:0];
                    [note parseServerResponse:dict];
                    note.issue = issue;
                    
                    [returnArray addObject:note];
                }
            }
            block(returnArray);
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            block(@[]);
            PBLog(@"err %@", error);
        }];
        
        [self.notesOperation start];
    }];
}

-(void)cancelNotesConnection{
    [self.notesOperation cancel];
}

-(void)sendNoteForIssue:(Issue *)issue andBody:(NSString *)body onSuccess:(void (^)(BOOL success))block{

    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block(NO);
        return;
    }
    
    Domain *domain = [[Domain MR_findAll] lastObject];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        //POST /projects/:id/issues/:issue_id/notes
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@/notes?private_token=%@", domain.protocol, domain.domain, issue.project_id, issue.identifier, session.private_token]];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        
        NSDictionary *params = @{@"id": issue.project_id, @"issue_id":issue.identifier, @"body": body};
        
        [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           block(NO);
        }];
    }];
}

-(void)cancelSendNotesConnection{

}

-(void)loadAllIssuesOnSuccess:(void(^)(void))block{
    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block();
        return;
    }
    
    Domain *domain = [[Domain MR_findAll] lastObject];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {

        //GET /issues/
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/issues/?private_token=%@", domain.protocol, domain.domain, session.private_token]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        self.allIssuesOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSArray *array = JSON;
            
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
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            block();
            PBLog(@"err %@", error);
        }];
        
        [self.allIssuesOperation start];
    }];
}

-(void)cancelAllIssuesConnection{
    [self.allIssuesOperation cancel];
}

@end
