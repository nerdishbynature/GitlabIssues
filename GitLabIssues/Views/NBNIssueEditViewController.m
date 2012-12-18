//
//  NBNIssueEditViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 18.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNIssueEditViewController.h"
#import "NBNMilestoneConnection.h"
#import "NBNUsersConnection.h"
#import "FormKit.h"
#import "Issue.h"
#import "Assignee.h"
#import "Milestone.h"

@interface NBNIssueEditViewController ()
@property (nonatomic, retain) FKFormModel *formModel;
@property (nonatomic, retain) Issue *issue;
@end

@implementation NBNIssueEditViewController
@synthesize formModel;
@synthesize issue;

+(NBNIssueEditViewController *)loadViewControllerWithIssue:(Issue *)_issue{
    NBNIssueEditViewController *editViewController = [[NBNIssueEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
    editViewController.issue = _issue;
    
    return editViewController;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Add your domain";
    
    self.formModel = [FKFormModel formTableModelForTableView:self.tableView navigationController:self.navigationController];
    
    [FKFormMapping mappingForClass:[Issue class] block:^(FKFormMapping *mapping) {
        [mapping sectionWithTitle:@"" footer:@"" identifier:@"edit"];
        
        [mapping mapAttribute:@"title" title:@"Title" type:FKFormAttributeMappingTypeText];
        [mapping mapAttribute:@"descriptionString" title:@"Description" type:FKFormAttributeMappingTypeBigText];
        
        [mapping mapAttribute:@"assignee"
                        title:@"Assignee"
                 showInPicker:YES
            selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                *selectedValueIndex = 0;
                
                NSMutableArray *assigneNameArray = [[NSMutableArray alloc] init];
                for (Assignee *assignee in [NBNUsersConnection loadMembersWithProjectID:[self.issue.project_id integerValue]]) {
                    [assigneNameArray addObject:assignee.name];
                }
                return assigneNameArray;
                
                
            } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", value];
                self.issue.assignee = [[Assignee findAllWithPredicate:predicate] objectAtIndex:0];
                
                [[NSManagedObjectContext MR_defaultContext] MR_save];
                
                return self.issue.assignee;
            } labelValueBlock:^id(id value, id object) {
                
                Assignee *assignee = (Assignee *)value;
                return assignee.name;
            }];
        
        NSArray *milestoneArray = [NBNMilestoneConnection loadMilestonesWithProjectID:[self.issue.project_id integerValue]];
        
        if (milestoneArray.count > 0) {
            [mapping mapAttribute:@"milestone"
                            title:@"Milestone"
                     showInPicker:YES
                selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                    *selectedValueIndex = 0;
                    
                    NSMutableArray *milestoneNameArray = [[NSMutableArray alloc] init];
                    for (Milestone *milestone in [NBNMilestoneConnection loadMilestonesWithProjectID:[self.issue.project_id integerValue]]) {
                        [milestoneNameArray addObject:milestone.title];
                    }
                    return milestoneNameArray;
                    
                    
                } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", value];
                    self.issue.milestone = [[Milestone findAllWithPredicate:predicate] objectAtIndex:0];
                    
                    [[NSManagedObjectContext MR_defaultContext] MR_save];
                    
                    return self.issue.milestone;
                } labelValueBlock:^id(id value, id object) {
                    
                    Milestone *milestone = (Milestone *)value;
                    return milestone.title;
                }];
        }
        
        
        
        [self.formModel registerMapping:mapping];
        
        [mapping buttonSave:@"Save" handler:^{
            PBLog(@"Issue: %@", self.issue);
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSManagedObjectContext MR_defaultContext] MR_save];
        }];
    }];
    
    
    
    [self.formModel loadFieldsWithObject:self.issue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.formModel = nil;
    self.issue = nil;
    
    [formModel release];
    [issue release];
    
    [super dealloc];
}

@end
