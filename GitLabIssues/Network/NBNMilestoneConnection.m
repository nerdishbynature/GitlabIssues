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
#import "NBNGitlabEngine.h"
#import "ASIHTTPRequest.h"
#import "NBNReachabilityChecker.h"

@interface NBNMilestoneConnection ()

@property (nonatomic, retain) NBNGitlabEngine *milestonesForProjectRequest;

@end

static NBNMilestoneConnection *sharedConnection = nil;

@implementation NBNMilestoneConnection
@synthesize milestonesForProjectRequest;

+ (NBNMilestoneConnection *) sharedConnection {
    
    @synchronized(self){
        
        if (sharedConnection == nil){
            sharedConnection = [[self alloc] init];
        }
    }
    
    return sharedConnection;
}

-(void)loadAllMilestonesForProjectID:(NSUInteger)projectID onSuccess:(void (^)(void))block{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block();
        return;
    }
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        self.milestonesForProjectRequest = [[NBNGitlabEngine alloc] init];
        [self.milestonesForProjectRequest requestWithURL:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%i/milestones?private_token=%@", domain.protocol, domain.domain, projectID, session.private_token] completionHandler:^(MKNetworkOperation *request) {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
            
            for (NSDictionary *dict in array) {
                
                NSPredicate *issueFinder = [NSPredicate predicateWithFormat:@"identifier = %i AND project_id = %i", [[dict objectForKey:@"id"] integerValue], projectID];
                
                if ([[Milestone MR_findAllWithPredicate:issueFinder] count] == 0) {
                    
                    [Milestone createAndParseJSON:dict andProjectID:projectID];
                }
            }
            block();
        } errorHandler:^(NSError *error) {
            PBLog(@"err %@", error);
            block();
        }];
    }];
}

- (void) cancelMilestonesForProjectRequest
{
    [self.milestonesForProjectRequest cancel];
}

+(NSArray *)loadMilestonesWithProjectID:(NSUInteger)projectID{
    
    if (![[NBNReachabilityChecker sharedChecker] isReachable]) return @[];
    
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    Session *firstSession = [[Session findAll] lastObject];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%i/milestones?private_token=%@", domain.protocol, domain.domain, projectID, firstSession.private_token]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSArray *milestoneJSONArray = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
    NSMutableArray *milestoneArray = [[[NSMutableArray alloc] initWithCapacity:milestoneJSONArray.count] autorelease];
    
    for (NSDictionary *dict in milestoneJSONArray) {
        Milestone *milestone = [Milestone createAndParseJSON:dict andProjectID:projectID];
        [milestoneArray addObject:milestone];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    return milestoneArray;
}


@end
