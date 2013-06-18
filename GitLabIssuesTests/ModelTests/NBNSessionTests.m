//
//  NBNSessionTests.m
//  GitLabIssues
//
//  Created by Piet Brauer on 11.06.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "Session.h"
#import "Domain.h"
#import "Kiwi.h"

SPEC_BEGIN(NBNSessionTests)

describe(@"Session", ^{
    beforeAll(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
        
        Domain *domain = [Domain MR_createEntity];
        domain.domain = @"gitlab.com";
        domain.email = @"piet@nerdishbynature.com";
        domain.password = @"!Qayxsw2";
        domain.protocol = @"https";
    });
    
   context(@"getting a session", ^{
              
       it(@"fetching should succeed", ^{
           [Session generateSessionWithCompletion:^(Session *session) {
               [session shouldNotBeNil];
               [[session.blocked shouldNot] beFalse];
               [session.created_at shouldNotBeNil];
               [session.email shouldNotBeNil];
               [session.identifier shouldNotBeNil];
               [session.name shouldNotBeNil];
               [session.private_token shouldNotBeNil];
           } onError:^(NSError *error) {
               [error shouldBeNil];
           }];
       });
       
       it(@"Session should get a valid session", ^{
           [Session getCurrentSessionWithCompletion:^(Session *session) {
               [session shouldNotBeNil];
               [[session.blocked should] beFalse];
//               [session.created_at shouldNotBeNil];
//               [session.email shouldNotBeNil];
//               [session.identifier shouldNotBeNil];
//               [session.name shouldNotBeNil];
//               [session.private_token shouldNotBeNil];
           }];
       });
   });
});

SPEC_END