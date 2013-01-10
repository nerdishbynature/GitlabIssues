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

@interface NBNIssuesConnection ()

@property (nonatomic, retain) ASIHTTPRequest *issuesConnection;
@property (nonatomic, retain) ASIHTTPRequest *reloadConnection;
@property (nonatomic, retain) ASIHTTPRequest *notesConnection;
@property (nonatomic, retain) ASIHTTPRequest *sendNotesConnection;
@property (nonatomic, retain) ASIHTTPRequest *allIssuesConnection;

@end

static NBNIssuesConnection *sharedConnection = nil;

@implementation NBNIssuesConnection
@synthesize issuesConnection;
@synthesize reloadConnection;
@synthesize notesConnection;
@synthesize sendNotesConnection;
@synthesize allIssuesConnection;

+ (NBNIssuesConnection *) sharedConnection {
    
    @synchronized(self){
        
        if (sharedConnection == nil){
            sharedConnection = [[self alloc] init];
        }
    }
    
    return sharedConnection;
}

-(void)loadIssuesForProject:(Project *)project onSuccess:(void (^)(void))block{
    
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues?private_token=%@", domain.protocol, domain.domain, project.identifier, session.private_token]];
        self.issuesConnection = [ASIHTTPRequest requestWithURL:url];
        
        [self.issuesConnection setCompletionBlock:^{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:[self.issuesConnection responseData] options:kNilOptions error:nil];
            
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
        
        [self.issuesConnection setFailedBlock:^{
            PBLog(@"err %@", [self.issuesConnection error]);
        }];
        
        [self.issuesConnection startAsynchronous];
    }];
}

-(void)cancelIssuesConnection{
    if ([self.issuesConnection isExecuting]){
        [self.issuesConnection clearDelegatesAndCancel];
        self.issuesConnection = nil;
        PBLog(@"cancel issuesConnection!");
    }
}

-(void)reloadIssue:(Issue *)issue onSuccess:(void(^)(void))block{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        //GET /projects/:id/issues/:issue_id
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@?private_token=%@", domain.protocol, domain.domain, issue.project_id, issue.identifier, session.private_token]];
        self.reloadConnection = [ASIHTTPRequest requestWithURL:url];
        
        [self.reloadConnection setCompletionBlock:^{
            NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:[self.reloadConnection responseData] options:kNilOptions error:nil];
            
            [issue parseServerResponse:returnDict];
            
            block();
        }];
        
        [self.reloadConnection setFailedBlock:^{
            PBLog(@"err %@", [self.reloadConnection error]);
        }];
        
        [self.reloadConnection startAsynchronous];
    }];
}

-(void)cancelReloadConnection{
    if ([self.reloadConnection isExecuting]){
        [self.reloadConnection clearDelegatesAndCancel];
        self.reloadConnection = nil;
        PBLog(@"cancel reloadConnection!");
    }
}

-(void)loadNotesForIssue:(Issue *)issue onSuccess:(void (^)(NSArray *))block{
    
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        //GET /projects/:id/issues/:issue_id/notes
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@/notes?private_token=%@", domain.protocol, domain.domain, issue.project_id, issue.identifier, session.private_token]];
        self.notesConnection = [ASIHTTPRequest requestWithURL:url];
        
        [self.notesConnection setCompletionBlock:^{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:[self.notesConnection responseData] options:kNilOptions error:nil];
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
        
        [self.notesConnection setFailedBlock:^{
            PBLog(@"err %@", [self.notesConnection error]);
        }];
        
        [self.notesConnection startAsynchronous];
    }];
}

-(void)cancelNotesConnection{
    if ([self.notesConnection isExecuting]){
        [self.notesConnection clearDelegatesAndCancel];
        self.notesConnection = nil;
        PBLog(@"cancel notesConnection!");
    }
}

-(void)sendNoteForIssue:(Issue *)issue andBody:(NSString *)body onSuccess:(void (^)(void))block{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        //POST /projects/:id/issues/:issue_id/notes
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@/notes?private_token=%@", domain.protocol, domain.domain, issue.project_id, issue.identifier, session.private_token]];
        self.sendNotesConnection = [ASIHTTPRequest requestWithURL:url];
        
        [self.sendNotesConnection setRequestMethod:@"POST"];
        
        NSDictionary *postDict = @{@"id": issue.project_id, @"issue_id":issue.identifier, @"body": body};
        
        [self.sendNotesConnection appendPostData:[NSJSONSerialization dataWithJSONObject:postDict options:kNilOptions error:nil]];
        [self.sendNotesConnection startSynchronous];
        
        if (self.sendNotesConnection.error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.sendNotesConnection.responseStatusMessage message:self.sendNotesConnection.error.localizedFailureReason delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            [alert release];
            PBLog(@"%@", self.sendNotesConnection.error);
        } else{
            block();
        }
    }];
}

-(void)cancelSendNotesConnection{
    if ([self.sendNotesConnection isExecuting]){
        [self.sendNotesConnection clearDelegatesAndCancel];
        self.sendNotesConnection = nil;
        PBLog(@"cancel sendNotesConnection!");
    }
}

-(void)loadAllIssuesOnSuccess:(void(^)(void))block{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        //GET /issues/
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/issues/?private_token=%@", domain.protocol, domain.domain, session.private_token]];
        self.allIssuesConnection = [ASIHTTPRequest requestWithURL:url];
        
        [self.allIssuesConnection setCompletionBlock:^{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:[self.allIssuesConnection responseData] options:kNilOptions error:nil];
            
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
        
        [self.allIssuesConnection setFailedBlock:^{
            PBLog(@"err %@", [self.allIssuesConnection error]);
        }];
        
        [self.allIssuesConnection startAsynchronous];
    }];
}

-(void)cancelAllIssuesConnection{
    if ([self.allIssuesConnection isExecuting]){
        [self.allIssuesConnection clearDelegatesAndCancel];
        self.allIssuesConnection = nil;
        PBLog(@"cancel allIssuesConnection!");
    }
}

@end
