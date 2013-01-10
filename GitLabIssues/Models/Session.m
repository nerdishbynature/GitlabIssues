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

+(Session *)generateSession{
    __block Session *session = [Session createEntity];
    
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/session", domain.protocol, domain.domain]];
    PBLog(@"url %@", url);
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:domain.email forKey:@"email"];
    [request addPostValue:domain.password forKey:@"password"];
    
    
    [request setCompletionBlock:^{
        
        PBLog(@"jsonString %@",[request responseString]);
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
        
    }];
    
    [request setFailedBlock:^{
        PBLog(@"err %@",request.error);
    }];
    
    [request startSynchronous];
    
    return session;
}


+(void)generateSessionWithCompletion:(void (^)(Session *session))block onError:(void (^)(NSError *error))errorBlock{
    __block Session *session = [Session createEntity];
    
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/session", domain.protocol, domain.domain]];
    PBLog(@"url %@", url);
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:domain.email forKey:@"email"];
    [request addPostValue:domain.password forKey:@"password"];
    
    
    [request setCompletionBlock:^{
        
        PBLog(@"jsonString %@",[request responseString]);
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
        
        block(session);
    }];
    
    [request setFailedBlock:^{
        errorBlock(request.error);
        PBLog(@"err %@",request.error);
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
            PBLog(@"failed to generate session %@", error);
        }];
    }
}

@end
