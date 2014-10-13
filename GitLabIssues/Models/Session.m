//
//  Session.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "Session.h"
#import "Domain.h"
#import <AFNetworking/AFHTTPClient.h>
#import <AFNetworking/AFHTTPRequestOperation.h>

@implementation Session

@dynamic blocked;
@dynamic created_at;
@dynamic email;
@dynamic identifier;
@dynamic name;
@dynamic private_token;

+(void)generateSessionWithCompletion:(void (^)(Session *session))block onError:(void (^)(NSError *error))errorBlock{
    __weak Session *session = [Session MR_createEntity];
    
    Domain *domain = [[Domain MR_findAll] lastObject];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/session/", domain.protocol, domain.domain]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{@"email": domain.email, @"password": domain.password};
    
    [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 201) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
            
            /*{
             "private_token" : "xxxxxx",
             "id" : 2,
             "created_at" : "2012-11-21T08:18:51Z",
             "email" : "piet@nerdishbynature.com",
             "blocked" : false,
             "name" : "Piet"
             }*/
            session.private_token = [dict objectForKey:@"private_token"];
            session.identifier = [NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]];
            session.email = [dict objectForKey:@"email"];
            session.blocked = [NSNumber numberWithBool:[[dict objectForKey:@"blocked"] boolValue]];
            session.name = [dict objectForKey:@"name"];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            if (!session.private_token) {
                errorBlock(nil);
            } else{
                block(session);
            }
            
        } else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                            message:NSLocalizedString(@"Server sent unexpected response, please try again later.", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                                                  otherButtonTitles:nil];
            [alert show];
            errorBlock(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PBLog(@"%@", error);
        [Flurry logError:@"generateSessionWithCompletion:onError:" message:error.localizedFailureReason error:error];
        errorBlock(error);
    }];
}

+(void)getCurrentSessionWithCompletion:(void (^)(Session *session))block{
    
    if ([Session MR_findAll].count > 0) {
        Session *session = [[Session MR_findAll] lastObject]; //there can only be one
        block(session);
    } else{
        [Session generateSessionWithCompletion:^(Session *session) {
            block(session);
        } onError:^(NSError *error) {
            block(nil);
            PBLog(@"failed to generate session %@", error);
        }];
    }
}

@end
