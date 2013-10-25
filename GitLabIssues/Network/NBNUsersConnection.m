//
//  NBNUsersConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 18.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNUsersConnection.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import "Domain.h"
#import "Session.h"
#import "Assignee.h"
#import "NBNReachabilityChecker.h"

@interface NBNUsersConnection ()

@property (nonatomic, strong) AFJSONRequestOperation *membersOperation;

@end

static NBNUsersConnection *sharedConnection = nil;

@implementation NBNUsersConnection

+ (NBNUsersConnection *) sharedConnection {
    
    @synchronized(self){
        
        if (sharedConnection == nil){
            sharedConnection = [[self alloc] init];
        }
    }
    
    return sharedConnection;
}

- (void) cancelMembersRequest
{
    [self.membersOperation cancel];
}

-(void)loadMembersWithProjectID:(NSUInteger)project_id onSuccess:(void (^)(NSArray *array))block{

    if (![[NBNReachabilityChecker sharedChecker] isReachable]) block(@[]);
    
    Domain *domain = [[Domain MR_findAll] lastObject];
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%i/members?private_token=%@", domain.protocol, domain.domain, project_id, session.private_token]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        self.membersOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSArray *memberJSONArray = JSON;
            
            NSMutableArray *memberArray = [[NSMutableArray alloc] initWithCapacity:memberJSONArray.count];
            
            for (NSDictionary *dict in memberJSONArray) {
                NSArray *assigneeArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Assignee"] where:@"identifier == %@", [dict objectForKey:@"id"]] toArray];
                
                if (assigneeArray.count == 0) {
                    [memberArray addObject:[Assignee createAndParseJSON:dict]];
                } else{
                    Assignee *assignee = [assigneeArray objectAtIndex:0];
                    [assignee parseServerResponseWithDict:dict];
                    [memberArray addObject:assignee];
                }
            }
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:nil];
            
            block(memberArray);
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            PBLog(@"%@", error.localizedDescription);
            block(@[]);
        }];
    }];
}

@end
