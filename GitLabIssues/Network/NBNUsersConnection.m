//
//  NBNUsersConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 18.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNUsersConnection.h"
#import "ASIHTTPRequest.h"
#import "Domain.h"
#import "Session.h"
#import "Assignee.h"
#import "NBNReachabilityChecker.h"

@interface NBNUsersConnection ()

@property (nonatomic, retain) ASIHTTPRequest *membersConnection;

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
    if ([self.membersConnection isExecuting]){
        [self.membersConnection clearDelegatesAndCancel];
        self.membersConnection = nil;
        PBLog(@"cancel membersConnection!");
    }
}

-(void)loadMembersWithProjectID:(NSUInteger)project_id onSuccess:(void (^)(NSArray *array))block{

    if (![[NBNReachabilityChecker sharedChecker] isReachable]) block(@[]);
    
    Domain *domain = [[Domain findAll] lastObject];
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%i/members?private_token=%@", domain.protocol, domain.domain, project_id, session.private_token]];
        self.membersConnection = [ASIHTTPRequest requestWithURL:url];
        [self.membersConnection setValidatesSecureCertificate:NO];
        
        [self.membersConnection setCompletionBlock:^{
            NSArray *memberJSONArray = [NSJSONSerialization JSONObjectWithData:[self.membersConnection responseData] options:kNilOptions error:nil];
            
            NSMutableArray *memberArray = [[[NSMutableArray alloc] initWithCapacity:memberJSONArray.count] autorelease];
            
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
        }];
        
        [self.membersConnection setFailedBlock:^{
            PBLog(@"%@", self.membersConnection.error);
            block(@[]);
        }];
        
        [self.membersConnection startAsynchronous];
    }];
}

@end
