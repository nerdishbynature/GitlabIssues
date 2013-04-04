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
#import "WBErrorNoticeView.h"

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
    editViewController.view.backgroundColor = [UIColor whiteColor];
    
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
        self.title = [NSString stringWithFormat:@"%@ #%@", NSLocalizedString(@"Edit Issue", nil), self.issue.identifier];
    } else{
        self.title = NSLocalizedString(@"New Issue", nil);
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
        
        [mapping mapAttribute:@"title" title:NSLocalizedString(@"Title", nil) placeholderText:NSLocalizedString(@"title", nil) type:FKFormAttributeMappingTypeText];
        [mapping mapAttribute:@"descriptionString" title:NSLocalizedString(@"Description", nil) placeholderText:NSLocalizedString(@"description", nil) type:FKFormAttributeMappingTypeBigText];
        
        
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
                        title:NSLocalizedString(@"Milestone", nil)
                 showInPicker:NO
            selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                *selectedValueIndex = 0;
                
                NSMutableArray *milestoneNameArray = [[NSMutableArray alloc] init];
                for (Milestone *milestone in milestones) {
                    [milestoneNameArray addObject:milestone.title];
                }
                
                [milestoneNameArray addObject:NSLocalizedString(@"None", nil)];
                
                return milestoneNameArray;
                
                
            } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                
                if (![value isEqual:NSLocalizedString(@"None", nil)]) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", value];
                    self.issue.milestone = [[Milestone findAllWithPredicate:predicate] objectAtIndex:0];
                    
                    [[NSManagedObjectContext MR_defaultContext] MR_save];
                    
                    return self.issue.milestone;
                }else{
                    self.issue.milestone = nil;
                    [[NSManagedObjectContext MR_defaultContext] MR_save];
                    
                    return self.issue.milestone;
                }
                
            } labelValueBlock:^id(id value, id object) {
                
                if (![value isEqual:NSLocalizedString(@"None", nil)]) {
                    Milestone *milestone = (Milestone *)value;
                    return milestone.title;
                } else{
                    return @"";
                }
                
            }];
    }
}

-(void)mapAssigneesWithArray:(NSArray *)array andMapping:(FKFormMapping *)mapping{
    [mapping mapAttribute:@"assignee"
                    title:NSLocalizedString(@"Assignee", nil)
             showInPicker:NO
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
	[button setTitle:NSLocalizedString(@"Discard", nil) forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
	[button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [button addTarget:self action:@selector(discard) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
	UIButton *applybutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[applybutton setTitle:NSLocalizedString(@"Apply", nil) forState:UIControlStateNormal];
	[applybutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
	[applybutton setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [applybutton setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [applybutton addTarget:self action:@selector(saveIssue) forControlEvents:UIControlEventTouchUpInside];
    [applybutton setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:applybutton] autorelease];
}

-(void)discard{
    [self.view endEditing:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Do you want to discard your changes?", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Keep", nil) otherButtonTitles:NSLocalizedString(@"Discard", nil), nil];
    [alert show];
    [alert release];
}

-(void)saveIssue{
    PBLog(@"Issue: %@", self.issue);
    [self.formModel save];
    [self.view endEditing:YES];
    
    if (self.editMode) {
        [self.issue saveChangesonSuccess:^(BOOL success){
            if (!success) {
                WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.tableView title:NSLocalizedString(@"Error", nil)
                                                                         message:NSLocalizedString(@"An error occured, check if you have the rights to perform this action.", nil)];
                notice.duration = 1.f;
                [notice setDismissalBlock:^(BOOL dismissedInteractively) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [notice show];
            } else{
                [[NSManagedObjectContext MR_defaultContext] MR_save];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
         
            
        }];
    } else{
        [self.issue createANewOnServerOnSuccess:^(BOOL success){
            if (success) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSManagedObjectContext MR_defaultContext] MR_save];
            } else{
                WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.tableView
                                                                          title:NSLocalizedString(@"Error", nil)
                                                                         message:NSLocalizedString(@"Issue could not be created.", nil)];
                notice.duration = 1.f;
                
                [notice setDismissalBlock:^(BOOL dismissedInteractively) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            
                [notice show];
            }
            
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
