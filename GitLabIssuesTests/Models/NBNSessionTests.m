//
//  NBNSessionTests.m
//  GitLabIssues
//
//  Created by Piet Brauer on 30.03.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNSessionTests.h"
#import "Session.h"
#import "Domain.h"

@implementation NBNSessionTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"GitLabIssuesTest.sqlite"];
    Domain *domain = [Domain createEntity];
    domain.domain = @"www.nerdishbynature.biz";
    domain.protocol = @"https://";
    domain.email = @"appledemo@nerdishbynature.com";
    domain.password = @"password";
}

-(void)testSessionGetting{
    [Session generateSessionWithCompletion:^(Session *session) {
        STAssertTrue(@"Sessions was generated", @"success");
    } onError:^(NSError *error) {
        STAssertFalse(@"Session could not be generated", error.localizedDescription);
    }];
}

@end
