//
//  NBNProjectConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNProjectConnection.h"
#import "User.h"

@interface NBNProjectConnection ()

@property (nonatomic, retain) ASIHTTPRequest *projectConnection;
@property (nonatomic, retain) ASIHTTPRequest *membersConnection;

@end

static NBNProjectConnection* sharedConnection = nil;

@implementation NBNProjectConnection
@synthesize projectConnection;
@synthesize membersConnection;

+ (NBNProjectConnection *) sharedConnection {
    
    @synchronized(self){
        
        if (sharedConnection == nil){
            sharedConnection = [[self alloc] init];
        }
    }
    
    return sharedConnection;
}

-(void)loadProjectsForDomain:(Domain *)domain onSuccess:(void (^)(void))block{
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects?private_token=%@", domain.protocol, domain.domain, session.private_token]];
        
        self.projectConnection = [ASIHTTPRequest requestWithURL:url];
        
        [self.projectConnection setCompletionBlock:^{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:[self.projectConnection responseData] options:kNilOptions error:nil];
            
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
        
        [self.projectConnection setFailedBlock:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.projectConnection.error.localizedFailureReason message:self.projectConnection.error.localizedDescription delegate:nil cancelButtonTitle:@"Dimiss" otherButtonTitles:nil];
            [alert show];
            PBLog(@"err %i", [self.projectConnection responseStatusCode]);
        }];
        
        [self.projectConnection startAsynchronous];
    }];
}

-(void)cancelProjectsConnection{
    if ([self.projectConnection isExecuting]){
        [self.projectConnection clearDelegatesAndCancel];
        self.projectConnection = nil;
        PBLog(@"cancel projectConnection!");
    }
}

-(void)loadMembersForProject:(Project *)project onSuccess:(void (^)(void))block{
    Domain *domain = [[Domain findAll] objectAtIndex:0];

    [Session getCurrentSessionWithCompletion:^(Session *session) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/members?private_token=%@", domain.protocol, domain.domain, project.identifier, session.private_token]];
        self.membersConnection = [ASIHTTPRequest requestWithURL:url];
        
        [self.membersConnection setCompletionBlock:^{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:[self.membersConnection responseData] options:kNilOptions error:nil];
            
            for (NSDictionary *dict in array) {
                
                NSPredicate *userFinder = [NSPredicate predicateWithFormat:@"identifier = %i", [[dict objectForKey:@"id"] integerValue]]; // 1 domain means no conflicts
                
                if ([[User MR_findAllWithPredicate:userFinder] count] == 0) {
                    [User createAndParseJSON:dict];
                }
            }
            
            block();
        }];
        
        [self.membersConnection setFailedBlock:^{
            PBLog(@"err %@", [self.membersConnection error]);
        }];
        
        [self.membersConnection startAsynchronous];
    }];
}

-(void)cancelMembersConnection{
    if ([self.membersConnection isExecuting]){
        [self.membersConnection clearDelegatesAndCancel];
        self.membersConnection = nil;
        PBLog(@"cancel membersConnection!");
    }
}

@end
