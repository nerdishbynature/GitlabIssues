//
//  GLLoginViewController.m
//  GitLab
//
//  Created by Piet Brauer on 05.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "GLLoginViewController.h"
#import "FormKit.h"
#import "Domain.h"
#import "Session.h"

@interface GLLoginViewController ()

@property (nonatomic, strong) FKFormModel *formModel;
@property (nonatomic, strong) Domain *domain;

@end

@implementation GLLoginViewController
@synthesize formModel;
@synthesize domain;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([Domain findAll].count == 0) {
        self.domain = [Domain createEntity];
        self.domain.protocol = @"http";
        self.domain.domain = @"";
        self.domain.email = @"";
        self.domain.password = @"";
    } else{
        
        self.domain = [[Domain findAll] objectAtIndex:0];
    
    }
    
    self.title = @"Add your domain";
    
    self.formModel = [FKFormModel formTableModelForTableView:self.tableView navigationController:self.navigationController];
    
    [FKFormMapping mappingForClass:[Domain class] block:^(FKFormMapping *mapping) {
        [mapping sectionWithTitle:@"" footer:@"" identifier:@"login"];
        
        [mapping mapAttribute:@"protocol"
                        title:@"Protocol"
                 showInPicker:YES
            selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                *selectedValueIndex = 1;
                return [NSArray arrayWithObjects:@"http", @"https", nil];
            } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                return value;
            } labelValueBlock:^id(id value, id object) {
                return value;
            }];
        [mapping mapAttribute:@"domain" title:@"Domain" type:FKFormAttributeMappingTypeText keyboardType:UIKeyboardTypeURL];
        [mapping mapAttribute:@"email" title:@"Email" type:FKFormAttributeMappingTypeText keyboardType:UIKeyboardTypeEmailAddress];
        [mapping mapAttribute:@"password" title:@"Password" type:FKFormAttributeMappingTypePassword];

        [self.formModel registerMapping:mapping];
        
        [mapping buttonSave:@"Connect" handler:^{
            PBLog(@"save pressed");
            PBLog(@"Domain: %@", self.domain);
            
            [Session generateSessionWithCompletion:^(Session *session) {
                if (session.private_token) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [[NSManagedObjectContext MR_defaultContext] MR_save];
                } else{
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong, please check your input." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [view show];
                }
            }];
            
            
            
        }];
    }];
    
    
    
    [self.formModel loadFieldsWithObject:self.domain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.formModel = nil;
    self.domain = nil;
}

@end
