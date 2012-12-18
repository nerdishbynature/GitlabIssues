//
//  GLLoginViewController.m
//  GitLab
//
//  Created by Piet Brauer on 05.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "GLLoginViewController.h"
#import "GLProjectsViewController.h"
#import "FormKit.h"
#import "Domain.h"
#import "Session.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"

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
        Domain *domain = [Domain createEntity];
        domain.protocol = @"http";
        domain.domain = @"<ip>";
        domain.email = @"<user>";
        domain.password = @"<pw>";
    } else{
        
        self.domain = [[Domain findAll] objectAtIndex:0];
    
    }
    
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
        [mapping mapAttribute:@"domain" title:@"Domain" type:FKFormAttributeMappingTypeText];
        [mapping mapAttribute:@"email" title:@"Email" type:FKFormAttributeMappingTypeText];
        [mapping mapAttribute:@"password" title:@"Password" type:FKFormAttributeMappingTypePassword];
        [mapping mapAttribute:@"remember_me" title:@"Remember me" type:FKFormAttributeMappingTypeBoolean];

        [self.formModel registerMapping:mapping];
        
        [mapping buttonSave:@"Connect" handler:^{
            PBLog(@"save pressed");
            
            [request setCompletionBlock:^{
                PBLog(@"Domain: %@", self.domain);
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSManagedObjectContext MR_defaultContext] MR_save];
            }];
            
            [request setFailedBlock:^{
                PBLog(@"err %@",request.error);
            }];
            
            [request startSynchronous];
            
        }];
    }];
    
    
    
    [self.formModel loadFieldsWithObject:self.domain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
