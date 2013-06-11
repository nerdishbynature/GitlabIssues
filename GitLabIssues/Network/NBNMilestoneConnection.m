//
//  NBNMilestoneConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNMilestoneConnection.h"
#import "Domain.h"
#import "Session.h"
#import "Milestone.h"
#import "NBNReachabilityChecker.h"
#import <AFNetworking/AFJSONRequestOperation.h>

@interface NBNMilestoneConnection ()

@property (nonatomic, retain) AFJSONRequestOperation *milestonesForProjectOperation;

@end

static NBNMilestoneConnection *sharedConnection = nil;

@implementation NBNMilestoneConnection

+ (NBNMilestoneConnection *) sharedConnection {
    
    @synchronized(self){
        
        if (sharedConnection == nil){
            sharedConnection = [[self alloc] init];
        }
    }
    
    return sharedConnection;
}

-(void)loadAllMilestonesForProjectID:(NSUInteger)projectID onSuccess:(void (^)(void))block{
    Domain *domain = [[Domain MR_findAll] lastObject];
    
    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block();
        return;
    }
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%i/milestones?private_token=%@", domain.protocol, domain.domain, projectID, session.private_token]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        self.milestonesForProjectOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSArray *array = JSON;
            
            for (NSDictionary *dict in array) {
                
                NSPredicate *issueFinder = [NSPredicate predicateWithFormat:@"identifier = %i AND project_id = %i", [[dict objectForKey:@"id"] integerValue], projectID];
                
                if ([[Milestone MR_findAllWithPredicate:issueFinder] count] == 0) {
                    
                    [Milestone createAndParseJSON:dict andProjectID:projectID];
                } else{
                    Milestone *milestone = [[Milestone MR_findAllWithPredicate:issueFinder] objectAtIndex:0];
                    [milestone parseServerResponseWithDict:dict];
                    milestone.project_id = [NSNumber numberWithInteger:projectID];
                }
            }
            block();
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            PBLog(@"err %@", error);
            block();
        }];
        
        [self.milestonesForProjectOperation start];
    }];
}

- (void) cancelMilestonesForProjectRequest
{
    [self.milestonesForProjectOperation cancel];
}

+(void)loadMilestonesWithProjectID:(NSUInteger)projectID onSucess:(void(^)(NSArray *milestones))block{
    
    if (![[NBNReachabilityChecker sharedChecker] isReachable]) block(@[]);
    
    Domain *domain = [[Domain MR_findAll] lastObject];
    Session *firstSession = [[Session MR_findAll] lastObject];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%i/milestones?private_token=%@", domain.protocol, domain.domain, projectID, firstSession.private_token]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *milestoneJSONArray = JSON;
        NSMutableArray *milestoneArray = [[[NSMutableArray alloc] initWithCapacity:milestoneJSONArray.count] autorelease];
        
        for (NSDictionary *dict in milestoneJSONArray) {
            Milestone *milestone = [Milestone createAndParseJSON:dict andProjectID:projectID];
            [milestoneArray addObject:milestone];
        }
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:nil];
        
        block(milestoneArray);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block(@[]);
    }];
    
    [operation start];
}


@end
