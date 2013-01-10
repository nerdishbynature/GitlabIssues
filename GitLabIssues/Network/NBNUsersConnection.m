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

-(NSArray *)loadMembersWithProjectID:(NSUInteger)project_id{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    Session *firstSession = [[Session findAll] lastObject];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%i/members?private_token=%@", domain.protocol, domain.domain, project_id, firstSession.private_token]];
    self.membersConnection = [ASIHTTPRequest requestWithURL:url];
    [self.membersConnection startSynchronous];
    
    NSArray *memberJSONArray = [NSJSONSerialization JSONObjectWithData:[self.membersConnection responseData] options:kNilOptions error:nil];
    
    NSMutableArray *memberArray = [[[NSMutableArray alloc] initWithCapacity:memberJSONArray.count] autorelease];
    
    for (NSDictionary *dict in memberJSONArray) {
        [memberArray addObject:[Assignee createAndParseJSON:dict]];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    return memberArray;
}

- (void) cancelMembersRequest
{
    if ([self.membersConnection isExecuting]){
        [self.membersConnection clearDelegatesAndCancel];
        self.membersConnection = nil;
        PBLog(@"cancel membersConnection!");
    }
}

@end
