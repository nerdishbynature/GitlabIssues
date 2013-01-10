//
//  NBNLabelsConnection.m
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNLabelsConnection.h"
#import "ASIHTTPRequest.h"
#import "Domain.h"
#import "Session.h"

@interface NBNLabelsConnection ()

@property (nonatomic, retain) ASIHTTPRequest *labelsConnection;

@end

static NBNLabelsConnection *sharedConnection = nil;

@implementation NBNLabelsConnection
@synthesize labelsConnection;

+ (NBNLabelsConnection *) sharedConnection {
    
    @synchronized(self){
        
        if (sharedConnection == nil){
            sharedConnection = [[self alloc] init];
        }
    }
    
    return sharedConnection;
}

-(void)loadAllLabelsForProjectID:(NSUInteger)projectID onSuccess:(void (^)(void))block{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%i/labels?private_token=%@", domain.protocol, domain.domain, projectID, session.private_token]];
        PBLog(@"%@", url);
        self.labelsConnection = [ASIHTTPRequest requestWithURL:url];
        
        [self.labelsConnection setCompletionBlock:^{
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
        }];
        
        [self.labelsConnection setFailedBlock:^{
            PBLog(@"err %@", [self.labelsConnection error]);
        }];
        
        [self.labelsConnection startAsynchronous];
    }];
}

- (void) cancelLabelsRequest
{
    if ([self.labelsConnection isExecuting]){
        [self.labelsConnection clearDelegatesAndCancel];
        self.labelsConnection = nil;
        PBLog(@"cancel labelsConnection!");
    }
}


@end
