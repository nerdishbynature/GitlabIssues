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
#import "NBNGitlabEngine.h"
#import "ASIHTTPRequest.h"
#import "NBNReachabilityChecker.h"

@interface NBNIssuesConnection ()

@property (nonatomic, retain) NBNGitlabEngine *issuesConnection;
@property (nonatomic, retain) NBNGitlabEngine *reloadConnection;
@property (nonatomic, retain) NBNGitlabEngine *notesConnection;
@property (nonatomic, retain) ASIHTTPRequest *sendNotesConnection;
@property (nonatomic, retain) NBNGitlabEngine *allIssuesConnection;

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
    
    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block();
        return;
    }
    
    Domain *domain = [[Domain findAll] lastObject];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
    
        self.issuesConnection = [[[NBNGitlabEngine alloc] init] autorelease];
        [self.issuesConnection requestWithURL:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues?private_token=%@", domain.protocol, domain.domain, project.identifier, session.private_token] completionHandler:^(MKNetworkOperation *request) {
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
        } errorHandler:^(NSError *error) {
            block();
            PBLog(@"err %@", error);
        }];
    }];
}

-(void)cancelIssuesConnection{
    [self.issuesConnection cancel];
}

-(void)reloadIssue:(Issue *)issue onSuccess:(void(^)(void))block{
    
    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block();
        return;
    }
    
    Domain *domain = [[Domain findAll] lastObject];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        //GET /projects/:id/issues/:issue_id        
        self.reloadConnection = [[[NBNGitlabEngine alloc] init] autorelease];
        [self.reloadConnection requestWithURL:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@?private_token=%@", domain.protocol, domain.domain, issue.project_id, issue.identifier, session.private_token] completionHandler:^(MKNetworkOperation *request) {
            NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
            
            [issue parseServerResponse:returnDict];
            
            block();
        } errorHandler:^(NSError *error) {
            block();
            PBLog(@"err %@", error);
        }];
    }];
}

-(void)cancelReloadConnection{
    [self.reloadConnection cancel];
}

-(void)loadNotesForIssue:(Issue *)issue onSuccess:(void (^)(NSArray *))block{
    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block(@[]);
        return;
    }

    Domain *domain = [[Domain findAll] lastObject];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        //GET /projects/:id/issues/:issue_id/notes
        
        self.notesConnection = [[[NBNGitlabEngine alloc] init] autorelease];
        [self.notesConnection requestWithURL:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@/notes?private_token=%@", domain.protocol,
                                              domain.domain, issue.project_id, issue.identifier, session.private_token] completionHandler:^(MKNetworkOperation *request) {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
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
        } errorHandler:^(NSError *error) {
            block(@[]);
            PBLog(@"err %@", error);
        }];
    }];
}

-(void)cancelNotesConnection{
    [self.notesConnection cancel];
}

-(void)sendNoteForIssue:(Issue *)issue andBody:(NSString *)body onSuccess:(void (^)(BOOL success))block{

    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block(NO);
        return;
    }
    
    Domain *domain = [[Domain findAll] lastObject];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        //POST /projects/:id/issues/:issue_id/notes
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@/notes?private_token=%@", domain.protocol, domain.domain, issue.project_id, issue.identifier, session.private_token]];
        self.sendNotesConnection = [ASIHTTPRequest requestWithURL:url];
        [self.sendNotesConnection setValidatesSecureCertificate:NO];
        [self.sendNotesConnection setRequestMethod:@"POST"];
        
        NSDictionary *postDict = @{@"id": issue.project_id, @"issue_id":issue.identifier, @"body": body};
        [self.sendNotesConnection appendPostData:[NSJSONSerialization dataWithJSONObject:postDict options:kNilOptions error:nil]];
        
        [self.sendNotesConnection setCompletionBlock:^{
                block(YES);
        }];
        
        [self.sendNotesConnection setFailedBlock:^{            
            block(NO);
        }];
        
        [self.sendNotesConnection startAsynchronous];
        
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
    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block();
        return;
    }
    
    Domain *domain = [[Domain findAll] lastObject];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {

        //GET /issues/
        self.allIssuesConnection = [[[NBNGitlabEngine alloc] init] autorelease];
        [self.allIssuesConnection requestWithURL:[NSString stringWithFormat:@"%@://%@/api/v3/issues/?private_token=%@", domain.protocol, domain.domain, session.private_token] completionHandler:^(MKNetworkOperation *request) {
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
        } errorHandler:^(NSError *error) {
            block();
            PBLog(@"err %@", error);
        }];
    }];
}

-(void)cancelAllIssuesConnection{
    [self.allIssuesConnection cancel];
}

@end
