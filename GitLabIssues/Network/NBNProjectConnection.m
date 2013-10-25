//
//  NBNProjectConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNProjectConnection.h"
#import "User.h"
#import "NBNReachabilityChecker.h"
#import <AFNetworking/AFJSONRequestOperation.h>

@interface NBNProjectConnection ()

@property (nonatomic, strong) AFJSONRequestOperation *projectOperation;
@property (nonatomic, strong) AFJSONRequestOperation *membersOperation;

@end

static NBNProjectConnection* sharedConnection = nil;

@implementation NBNProjectConnection

+ (NBNProjectConnection *) sharedConnection {
    
    @synchronized(self){
        
        if (sharedConnection == nil){
            sharedConnection = [[self alloc] init];
        }
    }
    
    return sharedConnection;
}

-(void)loadProjectsForDomain:(Domain *)domain onSuccess:(void (^)(void))block{
    
    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block();
        return;
    }
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects?private_token=%@", domain.protocol, domain.domain, session.private_token]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        self.projectOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSArray *array = JSON;
            
            for (NSDictionary *dict in array) {
                
                NSPredicate *projectFinder = [NSPredicate predicateWithFormat:@"identifier = %i", [[dict objectForKey:@"id"] integerValue]]; // 1 domain means no conflicts
                
                if ([[Project MR_findAllWithPredicate:projectFinder] count] == 0) { // new Project
                    [Project createAndParseJSON:dict];
                } else if ([[Project MR_findAllWithPredicate:projectFinder] count] == 1){ // update Project
                    Project *project = [[[[[NSManagedObjectContext MR_defaultContext] ofType:@"Project"] where:@"identifier == %i", [[dict objectForKey:@"id"] integerValue]] toArray] objectAtIndex:0];
                    [project parseServerResponseWithDict:dict];
                }
            }
            
            block();
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            block();
        }];
        
        [self.projectOperation start];
    }];
}

-(void)cancelProjectsConnection{
    [self.projectOperation cancel];
}

-(void)loadMembersForProject:(Project *)project onSuccess:(void (^)(void))block{
    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block();
        return;
    }
    
    Domain *domain = [[Domain MR_findAll] lastObject];

    [Session getCurrentSessionWithCompletion:^(Session *session) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/members?private_token=%@", domain.protocol, domain.domain, project.identifier, session.private_token]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        self.membersOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSArray *array = JSON;
            
            for (NSDictionary *dict in array) {
                
                NSPredicate *userFinder = [NSPredicate predicateWithFormat:@"identifier = %i", [[dict objectForKey:@"id"] integerValue]]; // 1 domain means no conflicts
                
                if ([[User MR_findAllWithPredicate:userFinder] count] == 0) {
                    [User createAndParseJSON:dict];
                }
            }
            
            block();
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            block();
            PBLog(@"err %@", error);
        }];
        
        [self.membersOperation start];
    }];
}

-(void)cancelMembersConnection{
    [self.membersOperation cancel];
}

@end
