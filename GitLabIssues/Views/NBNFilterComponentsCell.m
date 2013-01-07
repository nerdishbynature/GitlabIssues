//
//  NBNFilterComponentsCell.m
//  GitLabIssues
//
//  Created by Piet Brauer on 07.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNFilterComponentsCell.h"

@interface NBNFilterComponentsCell ()

@property (nonatomic, retain) Assignee *assignee;
@property (nonatomic, retain) Milestone *milestone;
@property (nonatomic, retain) NSArray *labels;
@property (retain, nonatomic) IBOutlet UILabel *headlineLabel;
@property (retain, nonatomic) IBOutlet UIView *bubbleContainer;
@property (retain, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (retain, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic, retain) HEBubbleView *bubbleView;

@end

@implementation NBNFilterComponentsCell
@synthesize assignee;
@synthesize milestone;
@synthesize labels;
@synthesize bubbleView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NBNFilterComponentsCell *)loadCellFromNib{
    return (NBNFilterComponentsCell *)[[[NSBundle mainBundle] loadNibNamed:@"NBNFilterComponentsCell" owner:self options:kNilOptions] objectAtIndex:0];
}

-(void)configureCellWithAssignee:(Assignee *)_assignee{
    self.assignee = _assignee;
    self.headlineLabel.text = @"Assigned:";
    self.placeholderLabel.text = @"Anyone";
    
    [self.addButton addTarget:self action:@selector(moveToAssigneeView:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize headlineLabelSize =  [self.headlineLabel.text sizeWithFont:self.headlineLabel.font
                                                    constrainedToSize:CGSizeMake(MAXFLOAT, self.headlineLabel.frame.size.height)
                                                        lineBreakMode:NSLineBreakByWordWrapping];
    self.headlineLabel.frame = CGRectMake(self.headlineLabel.frame.origin.x, self.headlineLabel.frame.origin.y, headlineLabelSize.width, self.headlineLabel.frame.size.height);
    
    self.bubbleView = [[HEBubbleView alloc] initWithFrame:CGRectMake(self.headlineLabel.frame.origin.x+self.headlineLabel.frame.size.width+5, self.bubbleContainer.frame.origin.y, self.bubbleContainer.frame.size.width, self.bubbleContainer.frame.size.height)];
    
    if (self.assignee) {
        self.addButton.hidden = YES;
        
        self.bubbleView.alwaysBounceVertical = NO;
        self.bubbleView.alwaysBounceHorizontal = NO;
        self.bubbleView.bubbleDataSource = self;
        self.bubbleView.bounces = NO;
        self.bubbleView.bubbleDelegate = self;
        self.bubbleView.selectionStyle = HEBubbleViewSelectionStyleDefault;
        
        [self addSubview:self.bubbleView];
        
        [self.bubbleView addItemAnimated:YES];
    }
    
}

-(void)configureCellWithMilestone:(Milestone *)_milestone{
    self.milestone = _milestone;
    self.headlineLabel.text = @"Milestone:";
    self.placeholderLabel.text = @"None";
    [self.addButton addTarget:self action:@selector(moveToMilestoneView:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize headlineLabelSize =  [self.headlineLabel.text sizeWithFont:self.headlineLabel.font
                                                    constrainedToSize:CGSizeMake(MAXFLOAT, self.headlineLabel.frame.size.height)
                                                        lineBreakMode:NSLineBreakByWordWrapping];
    self.headlineLabel.frame = CGRectMake(self.headlineLabel.frame.origin.x, self.headlineLabel.frame.origin.y, headlineLabelSize.width, self.headlineLabel.frame.size.height);
    
    self.bubbleView = [[HEBubbleView alloc] initWithFrame:CGRectMake(self.headlineLabel.frame.origin.x+self.headlineLabel.frame.size.width+5, self.bubbleContainer.frame.origin.y, self.bubbleContainer.frame.size.width, self.bubbleContainer.frame.size.height)];
    
    if (self.milestone) {
        self.addButton.hidden = YES;
        
        self.bubbleView.alwaysBounceVertical = NO;
        self.bubbleView.alwaysBounceHorizontal = NO;
        self.bubbleView.bubbleDataSource = self;
        self.bubbleView.bounces = NO;
        self.bubbleView.bubbleDelegate = self;
        self.bubbleView.selectionStyle = HEBubbleViewSelectionStyleDefault;
        
        [self addSubview:self.bubbleView];
        
        [self.bubbleView addItemAnimated:YES];
    }
}

-(void)configureCellWithLabels:(NSArray *)_labels{
    self.labels = _labels;
}

-(void)moveToAssigneeView:(id)sender{

}

-(void)moveToMilestoneView:(id)sender{
    
}

#pragma mark - HEBubbleViewStuff

#pragma mark - bubble view data source

-(NSInteger)numberOfItemsInBubbleView:(HEBubbleView *)bubbleView
{
    return 1;
}

-(HEBubbleViewItem *)bubbleView:(HEBubbleView *)bubbleViewIN bubbleItemForIndex:(NSInteger)index
{
    NSString *itemIdentifier = @"bubble";
    
    HEBubbleViewItem *item = [bubbleView dequeueItemUsingReuseIdentifier:itemIdentifier];
    
    if (item == nil) {
        item = [[HEBubbleViewItem alloc] initWithReuseIdentifier:itemIdentifier];
    }
    
    if (self.assignee) {
        item.textLabel.text = self.assignee.name;
    } else if (self.milestone){
        item.textLabel.text = self.milestone.title;
    }
    
    return item;
}


#pragma mark - bubble view delegate

-(void)bubbleView:(HEBubbleView *)bubbleView didSelectBubbleItemAtIndex:(NSInteger)index
{
    if (self.assignee) {
        [self moveToAssigneeView:nil];
    } else if (self.milestone){
        [self moveToMilestoneView:nil];
    }

}

// returns wheter to show a menu callout or not for a given index
-(BOOL)bubbleView:(HEBubbleView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index
{
    return YES;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}


/*
 Create the menu items you want to show in the callout and return them. Provide selectors
 that are implemented in your bubbleview delegate. override canBecomeFirstResponder and return
 YES, otherwise menu will not be shown
 */

-(NSArray *)bubbleView:(HEBubbleView *)bubbleView menuItemsForBubbleItemAtIndex:(NSInteger)index
{
    return  @[];
}

-(void)bubbleView:(HEBubbleView *)bubbleView didHideMenuForBubbleItemAtIndex:(NSInteger)index
{
}

-(void)dealloc{
    self.assignee = nil;
    self.milestone = nil;
    self.labels = nil;
    
    [assignee release];
    [milestone release];
    [labels release];

    [_headlineLabel release];
    [_bubbleContainer release];
    [_placeholderLabel release];
    [_addButton release];
    [super dealloc];
}

@end
