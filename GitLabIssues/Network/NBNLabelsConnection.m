//
//  NBNLabelsConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNLabelsConnection.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import "Domain.h"
#import "Session.h"
#import "NBNReachabilityChecker.h"

@interface NBNLabelsConnection ()

@property (nonatomic, retain) AFJSONRequestOperation *labelsOperation;

@end

static NBNLabelsConnection *sharedConnection = nil;

@implementation NBNLabelsConnection

+ (NBNLabelsConnection *) sharedConnection {
    
    @synchronized(self){
        
        if (sharedConnection == nil){
            sharedConnection = [[self alloc] init];
        }
    }
    
    return sharedConnection;
}

-(void)loadAllLabelsForProjectID:(NSUInteger)projectID onSuccess:(void (^)(void))block{
    Domain *domain = [[Domain MR_findAll] lastObject];

    if (![[NBNReachabilityChecker sharedChecker] isReachable]){
        block();
        return;
    }
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%i/labels?private_token=%@", domain.protocol, domain.domain, projectID, session.private_token]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        self.labelsOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            //        NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
            //
            //        for (NSDictionary *dict in array) {
            //
            //            NSPredicate *issueFinder = [NSPredicate predicateWithFormat:@"identifier = %i AND project_id = %i", [[dict objectForKey:@"id"] integerValue], projectID];
            //
            //            if ([[Milestone MR_findAllWithPredicate:issueFinder] count] == 0) {
            //
            //                [Milestone createAndParseJSON:dict andProjectID:projectID];
            //            }
            //        }
            PBLog(@"not yet supported");
            block();
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            PBLog(@"err %@", error.localizedDescription);
        }];
        
        [self.labelsOperation start];
    }];
}

- (void) cancelLabelsRequest
{
    [self.labelsOperation cancel];
}


@end
