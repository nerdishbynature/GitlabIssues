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
    [[NBNUsersConnection sharedConnection] cancelMembersRequest];
    [[NBNMilestoneConnection sharedConnection] cancelMilestonesForProjectRequest];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(self.editMode){
        self.title = [NSString stringWithFormat:@"Edit Issue #%@", self.issue.project_id];
    } else{
        self.title = @"New Issue";
    }
    
    [self setupBarButtons];
    
    self.formModel = [FKFormModel formTableModelForTableView:self.tableView navigationController:self.navigationController];
    
    [self doMappingWithCompletion:^{
        [self.formModel loadFieldsWithObject:self.issue];
    }];
}

-(void)doMappingWithCompletion:(void(^)(void))block{
    [FKFormMapping mappingForClass:[Issue class] block:^(FKFormMapping *mapping) {
        [mapping sectionWithTitle:@"" footer:@"" identifier:@"edit"];
        
        [mapping mapAttribute:@"title" title:@"Title" type:FKFormAttributeMappingTypeText];
        [mapping mapAttribute:@"descriptionString" title:@"Description" type:FKFormAttributeMappingTypeBigText];
        
        
        [[NBNUsersConnection sharedConnection] loadMembersWithProjectID:[self.issue.project_id integerValue] onSuccess:^(NSArray *array) {
            
            [self mapAssigneesWithArray:array andMapping:mapping];
            
            [NBNMilestoneConnection loadMilestonesWithProjectID:[self.issue.project_id integerValue] onSucess:^(NSArray *milestones) {
                
                [self mapMilestonesWithArray:milestones andMapping:mapping];
                
                [self.formModel registerMapping:mapping];
                
                block();
            }];
        }];
    }];
}

-(void)mapMilestonesWithArray:(NSArray *)milestones andMapping:(FKFormMapping *)mapping{
    if (milestones.count > 0) {
        [mapping mapAttribute:@"milestone"
                        title:@"Milestone"
                 showInPicker:YES
            selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                *selectedValueIndex = 0;
                
                NSMutableArray *milestoneNameArray = [[NSMutableArray alloc] init];
                for (Milestone *milestone in milestones) {
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
}

-(void)mapAssigneesWithArray:(NSArray *)array andMapping:(FKFormMapping *)mapping{
    [mapping mapAttribute:@"assignee"
                    title:@"Assignee"
             showInPicker:YES
        selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
            *selectedValueIndex = 0;
            
            NSMutableArray *assigneeNameArray = [[NSMutableArray alloc] init];
            for (Assignee *assignee in array) {
                [assigneeNameArray addObject:assignee.name];
            }
            return assigneeNameArray;
            
        } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", value];
            self.issue.assignee = [[Assignee findAllWithPredicate:predicate] objectAtIndex:0];
            
            [[NSManagedObjectContext MR_defaultContext] MR_save];
            
            return self.issue.assignee;
        } labelValueBlock:^id(id value, id object) {
            
            Assignee *assignee = (Assignee *)value;
            return assignee.name;
        }];
}

-(void)setupBarButtons{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"Discard" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
	[button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [button addTarget:self action:@selector(discard) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
	UIButton *applybutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[applybutton setTitle:@"Apply" forState:UIControlStateNormal];
	[applybutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
	[applybutton setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [applybutton setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [applybutton addTarget:self action:@selector(saveIssue) forControlEvents:UIControlEventTouchUpInside];
    [applybutton setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:applybutton] autorelease];
}

-(void)discard{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to discard your changes?" message:@"" delegate:self cancelButtonTitle:@"Keep" otherButtonTitles:@"Discard", nil];
    [alert show];
    [alert release];
}

-(void)saveIssue{
    PBLog(@"Issue: %@", self.issue);
    [self.formModel save];
    
    if (self.editMode) {
        [self.issue saveChangesonSuccess:^{
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSManagedObjectContext MR_defaultContext] MR_save];
        }];
    } else{
        [self.issue createANewOnServerOnSuccess:^{
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSManagedObjectContext MR_defaultContext] MR_save];
        }];
    }
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

    PBLog(@"deallocing %@", [self class]);
    [super dealloc];
}

@end
