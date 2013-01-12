//
//  Issue.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "Issue.h"
#import "Assignee.h"
#import "Author.h"
#import "Milestone.h"
#import "Domain.h"
#import "Session.h"
#import "ASIHTTPRequest.h"


@implementation Issue

@dynamic closed;
@dynamic created_at;
@dynamic descriptionString;
@dynamic identifier;
@dynamic labels;
@dynamic project_id;
@dynamic title;
@dynamic updated_at;
@dynamic assignee;
@dynamic author;
@dynamic milestone;
@dynamic notes;

+(Issue *)createAndParseJSON:(NSDictionary *)dict{
    Issue *issue = [Issue createEntity];
    /*{
     "id": 42,
     "project_id": 8,
     "title": "Add user settings",
     "description": "",
     "labels": [
         "feature"
     ],
     "milestone": {
         "id": 1,
         "title": "v1.0",
         "description": "",
         "due_date": "2012-07-20",
         "closed": false,
         "updated_at": "2012-07-04T13:42:48Z",
         "created_at": "2012-07-04T13:42:48Z"
     },
     "assignee": {
         "id": 2,
         "email": "jack@example.com",
         "name": "Jack Smith",
         "blocked": false,
         "created_at": "2012-05-23T08:01:01Z"
     },
     "author": {
         "id": 1,
         "email": "john@example.com",
         "name": "John Smith",
         "blocked": false,
         "created_at": "2012-05-23T08:00:58Z"
     },
     "closed": false,
     "updated_at": "2012-07-12T13:43:19Z",
     "created_at": "2012-06-28T12:58:06Z"
     }*/
    
    [issue parseServerResponse:dict];
    
    return issue;
}

-(void)save{
}

//@see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/issues.md#edit-issue

-(void)saveChanges{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues/%@?private_token=%@",domain.protocol, domain.domain, self.project_id , self.identifier, session.private_token]];
        PBLog(@"url %@", url);
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setRequestMethod:@"PUT"];
        
        [request appendPostData:[self toJSON]];
        [request startSynchronous];
        
        if (request.error) {
            PBLog(@"%@", request.error);
        }
    }];
}

//@see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/issues.md#new-issue

-(void)createANewOnServer{
    
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/issues?private_token=%@",domain.protocol, domain.domain, self.project_id, session.private_token]];
        PBLog(@"url %@", url);
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        
        [request appendPostData:[self toCreateJSON]];
        [request startSynchronous];
        
        if (request.error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:request.responseStatusMessage message:request.error.localizedFailureReason delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            [alert release];
            PBLog(@"%@", request.error);
        }
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
        
        [self parseServerResponse:responseDict];
    }];
}

-(void)parseServerResponse:(NSDictionary *)dict{
    self.identifier = [NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]];
    self.project_id = [NSNumber numberWithInt:[[dict objectForKey:@"project_id"] integerValue]];
    self.title = [dict objectForKey:@"title"];
    
    int closedInt = [[dict valueForKey:@"closed"] integerValue];
    self.closed = [NSNumber numberWithInt:closedInt];
    
    if (![[dict objectForKey:@"description"] isMemberOfClass:[NSNull class]]) {
        self.descriptionString = [dict objectForKey:@"description"];
    }
    
    if (![[dict objectForKey:@"assignee"] isMemberOfClass:[NSNull class]]) {
<<<<<<< HEAD
        NSArray *assigneeArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Assignee"] where:@"identifier == %@", [[dict objectForKey:@"assignee"] objectForKey:@"id"] ] toArray];
        
        if (assigneeArray.count > 0) {
            self.assignee = [assigneeArray objectAtIndex:0];
        } else{
            self.assignee = [Assignee createAndParseJSON:[dict objectForKey:@"assignee"]];
        }
    }
    
    if (![[dict objectForKey:@"milestone"] isMemberOfClass:[NSNull class]]) {
        NSArray *milestoneArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Milestone"] where:@"identifier == %@", [[dict objectForKey:@"milestone"] objectForKey:@"id"] ] toArray];
        
        if (milestoneArray.count > 0) {
            self.milestone = [milestoneArray objectAtIndex:0];
        } else{
            self.milestone = [Milestone createAndParseJSON:[dict objectForKey:@"milestone"] andProjectID:[self.project_id integerValue]];
=======
        NSArray *assigneeArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Assignee"] where:@"identifier == %@", [[dict objectForKey:@"assignee"] objectForKey:@"id"]] toArray];
        if (assigneeArray.count == 0) {
            self.assignee = [Assignee createAndParseJSON:[dict objectForKey:@"assignee"]];
        } else if (assigneeArray.count == 1){
            self.assignee = [assigneeArray objectAtIndex:0];
            [self.assignee parseServerResponseWithDict:[dict objectForKey:@"assignee"]];
        }
        
    }
    
    if (![[dict objectForKey:@"milestone"] isMemberOfClass:[NSNull class]]) {
        NSArray *milestoneArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Milestone"] where:@"identifier == %@", [[dict objectForKey:@"milestone"] objectForKey:@"id"], self.project_id] toArray];
        
        if (milestoneArray.count == 0) {
            self.milestone = [Milestone createAndParseJSON:[dict objectForKey:@"milestone"] andProjectID:[self.project_id integerValue]];
        } else if (milestoneArray.count == 1){
            self.milestone = [milestoneArray objectAtIndex:0];
            [self.milestone parseServerResponseWithDict:[dict objectForKey:@"milestone"]];
>>>>>>> develop
        }
    }
    
    if (![[dict objectForKey:@"author"] isMemberOfClass:[NSNull class]]) {
        NSArray *authorArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Author"] where:@"identifier == %@", [[dict objectForKey:@"author"] objectForKey:@"id"] ] toArray];
        
        if (authorArray.count == 1) {
            self.author = [authorArray objectAtIndex:0];
            [self.author parseServerResonse:[dict objectForKey:@"author"]];
        } else{
            self.author = [Author createAndParseJSON:[dict objectForKey:@"author"]];
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    
    self.created_at = [formatter dateFromString:[dict objectForKey:@"created_at"]];
    self.updated_at = [formatter dateFromString:[dict objectForKey:@"updated_at"]];
    
    [formatter release];
}

#pragma mark - toJSON

-(NSData *)toCreateJSON{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.project_id forKey:@"id"];
    
    if (self.title)
        [dict setObject:self.title forKey:@"title"];
    
    if (self.descriptionString)
        [dict setObject:self.descriptionString forKey:@"description"];
    
    if (self.assignee.identifier)
        [dict setObject:self.assignee.identifier forKey:@"assignee_id"];
    
    if (self.milestone.identifier)
        [dict setObject:self.milestone.identifier forKey:@"milestone_id"];
    
    return [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
}

-(NSData *)toJSON{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.project_id forKey:@"id"];
    [dict setObject:self.identifier forKey:@"issue_id"];
    
    if (self.title)
        [dict setObject:self.title forKey:@"title"];

    if (self.descriptionString)
        [dict setObject:self.descriptionString forKey:@"description"];
    
    if (self.assignee.identifier)
        [dict setObject:self.assignee.identifier forKey:@"assignee_id"];
    
    if (self.milestone.identifier)
        [dict setObject:self.milestone.identifier forKey:@"milestone_id"];
    
    if (self.closed)
        [dict setObject:self.closed forKey:@"closed"];
    
    return [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
}

-(void)saveMilestone{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v3/projects/%@/milestones/%@?private_token=%@",domain.protocol, domain.domain, self.project_id , self.milestone.identifier, session.private_token]];
        PBLog(@"url %@", url);
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setRequestMethod:@"PUT"];
        
        [request appendPostData:[self milestoneToJSON]];
        [request startSynchronous];
        
        PBLog(@"%@", request.error);
        PBLog(@"%@", request.responseString);
    }];
}

-(NSData *)milestoneToJSON{
    NSDictionary *dict = @{
    @"id" : self.project_id,
    @"milestone_id": self.milestone.identifier,
    @"title": self.milestone.title,
    @"description": self.milestone.descriptionString,
    @"closed": self.milestone.closed };
    
    return [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
}

@end
