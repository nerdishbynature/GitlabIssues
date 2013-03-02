//
//  Session.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "Session.h"
#import "ASIFormDataRequest.h"
#import "Domain.h"

@implementation Session

@dynamic blocked;
@dynamic created_at;
@dynamic email;
@dynamic identifier;
@dynamic name;
@dynamic private_token;

+(void)generateSessionWithCompletion:(void (^)(Session *session))block onError:(void (^)(NSError *error))errorBlock{
    __block Session *session = [Session createEntity];
    
    Domain *domain = [[Domain findAll] lastObject];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/session/", domain.protocol, domain.domain]];
    PBLog(@"url %@", url);
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:domain.email forKey:@"email"];
    [request addPostValue:domain.password forKey:@"password"];
    [request setValidatesSecureCertificate:NO];
    
    [request setCompletionBlock:^{
        if (request.responseStatusCode == 201) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
            
            
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
            
            if (!session.private_token) {
                errorBlock(request.error);
            } else{
                block(session);
            }
            
        } else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Server sent unexpected response, please try again later." delegate:nil cancelButtonTitle:@"Dsmiss" otherButtonTitles:nil];
            [alert show];
            errorBlock(request.error);
        }
    }];
    
    [request setFailedBlock:^{
        PBLog(@"err %@",request.error);
        [Flurry logError:@"generateSessionWithCompletion:onError:" message:request.error.localizedFailureReason error:request.error];
        errorBlock(request.error);
    }];
    
    [request startAsynchronous];
}

+(void)getCurrentSessionWithCompletion:(void (^)(Session *session))block{
    
    if ([Session findAll].count > 0) {
        Session *session = [[Session findAll] lastObject]; //there can only be one
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
