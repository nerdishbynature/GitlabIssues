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
#import "MBProgressHUD.h"
#import "WBErrorNoticeView.h"

@interface GLLoginViewController ()

@property (nonatomic, strong) FKFormModel *formModel;
@property (nonatomic, strong) Domain *domain;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation GLLoginViewController
@synthesize formModel;
@synthesize domain;
@synthesize HUD;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([Domain MR_findAll].count == 0) {
        self.domain = [Domain MR_createEntity];
        self.domain.protocol = @"https";
        self.domain.domain = @"";
        self.domain.email = @"";
        self.domain.password = @"";
    } else{
        [Domain MR_truncateAll];
        
        self.domain = [Domain MR_createEntity];
        self.domain.protocol = @"https";
        self.domain.domain = @"";
        self.domain.email = @"";
        self.domain.password = @"";
    }
    
    [self createDoneButton];
    self.title = NSLocalizedString(@"Add your domain", nil);
    
    self.formModel = [FKFormModel formTableModelForTableView:self.tableView navigationController:self.navigationController];
    
    [FKFormMapping mappingForClass:[Domain class] block:^(FKFormMapping *mapping) {
        [mapping sectionWithTitle:@"" footer:@"" identifier:@"login"];
        
        [mapping mapAttribute:@"protocol"
                        title:NSLocalizedString(@"Protocol", nil)
                 showInPicker:NO
            selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                selectedValueIndex = 0;
                return [NSArray arrayWithObjects:@"https", @"http", nil];
            } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                return value;
            } labelValueBlock:^id(id value, id object) {
                return value;
            }];
        [mapping mapAttribute:@"domain"
                        title:NSLocalizedString(@"Domain", nil)
              placeholderText:NSLocalizedString(@"www.example.com", nil)
                 keyboardType:UIKeyboardTypeURL
                         type:FKFormAttributeMappingTypeText];
        
        [mapping mapAttribute:@"email"
                        title:NSLocalizedString(@"Email", nil)
              placeholderText:NSLocalizedString(@"me@example.com", nil)
                 keyboardType:UIKeyboardTypeEmailAddress
                         type:FKFormAttributeMappingTypeText];

        [mapping mapAttribute:@"password"
                        title:NSLocalizedString(@"Password", nil)
              placeholderText:NSLocalizedString(@"password", nil)
                         type:FKFormAttributeMappingTypePassword];

        [self.formModel registerMapping:mapping];
    }];
    
    
    
    [self.formModel loadFieldsWithObject:self.domain];
}

-(void)connect:(id)sender{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // Show the HUD while the provided method executes in a new thread
    [HUD show:YES];
    
    [self.formModel save];
    
    PBLog(@"save pressed");
    PBLog(@"Domain: %@", self.domain);
    
    [Session generateSessionWithCompletion:^(Session *session) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:nil];
        [self.HUD setHidden:YES];
        [self.HUD removeFromSuperview];
    } onError:^(NSError *error) {
        [self.HUD setHidden:YES];
        [self.HUD removeFromSuperview];
        
        WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.tableView
                                                                   title:NSLocalizedString(@"Signup Error", nil)
                                                                 message:NSLocalizedString(@"You need to fill out all entries in this screen to signup.", nil)];
        notice.sticky = YES;
        [notice show];
    }];
}

-(void)createDoneButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
    [button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [button addTarget:self action:@selector(connect:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
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
    self.HUD = nil;
    PBLog(@"deallocing %@", [self class]);
}

@end
