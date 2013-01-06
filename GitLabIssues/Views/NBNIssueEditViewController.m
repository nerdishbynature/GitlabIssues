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
@synthesize editMode;

+(NBNIssueEditViewController *)loadViewControllerWithIssue:(Issue *)_issue{
    NBNIssueEditViewController *editViewController = [[[NBNIssueEditViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    editViewController.issue = _issue;
    
    return editViewController;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.editMode){
        self.title = [NSString stringWithFormat:@"Edit Issue #%@", self.issue.project_id];
    } else{
        self.title = @"New Issue";
    }
    
    [self setupBarButtons];
    
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
    }];
    
    
    
    [self.formModel loadFieldsWithObject:self.issue];
}

-(void)setupBarButtons{
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Discard" style:UIBarButtonItemStyleBordered target:self action:@selector(discard)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(saveIssue)] autorelease];
}

-(void)discard{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to discard your changes?" message:@"" delegate:self cancelButtonTitle:@"Keep" otherButtonTitles:@"Discard", nil];
    [alert show];
    [alert release];
}

-(void)saveIssue{
    PBLog(@"Issue: %@", self.issue);
    if (self.editMode) {
        [self.issue saveChanges];
    } else{
        [self.issue createANewOnServer];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSManagedObjectContext MR_defaultContext] MR_save];
}

#pragma mark - UIAlertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        // do nothing
        [self dismissViewControllerAnimated:YES completion:nil];
    } else{
        
    }
    
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
