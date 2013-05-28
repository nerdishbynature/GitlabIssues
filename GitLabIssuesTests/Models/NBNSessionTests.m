//
//  NBNSessionTests.m
//  GitLabIssues
//
//  Created by Piet Brauer on 30.03.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNSessionTests.h"
#import "MTTestSemaphor.h"
#import "Session.h"
#import "Domain.h"

@implementation NBNSessionTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"GitLabIssuesTest.sqlite"];
    [Domain MR_truncateAll];
    
    if ([Domain MR_countOfEntities] == 0) {
        Domain *domain = [Domain createEntity];
        domain.domain = @"www.nerdishbynature.biz";
        domain.protocol = @"https://";
        domain.email = @"appledemo@nerdishbynature.com";
        domain.password = @"!Qayxsw2";
    } else{
        STFail(@"Domains are not empty");
    }
}

-(void)tearDown{
    [super tearDown];
}

-(void)testBadKnowSessionGetting{
    NSString* sempahoreKey = @"testBadKnowSessionGetting";
    
    [Session generateSessionWithCompletion:^(Session *session) {
        STAssertFalse(session, @"successful loaded session");
        [[MTTestSemaphor semaphore] lift: sempahoreKey];
    } onError:^(NSError *error) {
        STAssertTrue(error, error.localizedDescription);
        [[MTTestSemaphor semaphore] lift: sempahoreKey];
    }];
    
    [[MTTestSemaphor semaphore] waitForKey: sempahoreKey];
}

-(void)testGoodKnowSessionGetting{
    
    NSString* testKey = @"testGoodKnowSessionGetting";
    
    [Session generateSessionWithCompletion:^(Session *session) {
        STAssertTrue(session, @"successful loaded session");
        [[MTTestSemaphor semaphore] lift: testKey];
    } onError:^(NSError *error) {
        STAssertFalse(error, error.localizedDescription);
        [[MTTestSemaphor semaphore] lift: testKey];
    }];
    
    [[MTTestSemaphor semaphore] waitForKey: testKey];
}

@end
