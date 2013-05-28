//
//  NBNMilestoneConnectionTests.m
//  GitLabIssues
//
//  Created by Piet Brauer on 30.03.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNMilestoneConnectionTests.h"
#import "Domain.h"
#import "NBNMilestoneConnection.h"
#import "Session.h"

@implementation NBNMilestoneConnectionTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"GitLabIssuesTest.sqlite"];
    if ([Domain MR_countOfEntities] == 0) {
        Domain *domain = [Domain createEntity];
        domain.domain = @"www.nerdishbynature.biz";
        domain.protocol = @"https://";
        domain.email = @"appledemo@nerdishbynature.com";
        domain.password = @"password";
    }
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testMilestoneLoading
{
    STAssertTrue(@"test", @"Yihaa");
}

@end
