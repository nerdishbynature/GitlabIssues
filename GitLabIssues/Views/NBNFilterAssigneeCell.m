//
//  NBNFilterAssigneeCell.m
//  GitLabIssues
//
//  Created by Piet Brauer on 17.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNFilterAssigneeCell.h"

@interface NBNFilterAssigneeCell ()

@property (nonatomic, retain) Assignee *assignee;
@property (retain, nonatomic) IBOutlet UILabel *headlineLabel;
@property (retain, nonatomic) IBOutlet UIView *bubbleContainer;
@property (retain, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, retain) HEBubbleView *bubbleView;
@property (nonatomic, retain) IBOutlet UIButton *clearButton;

@end

@implementation NBNFilterAssigneeCell
@synthesize delegate;
@synthesize bubbleView;
@synthesize clearButton;
@synthesize assignee;

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

+(NBNFilterAssigneeCell *)loadCellFromNib{
    return (NBNFilterAssigneeCell *)[[[NSBundle mainBundle] loadNibNamed:@"NBNFilterAssigneeCell" owner:self options:kNilOptions] objectAtIndex:0];
}

-(void)configureCellWithAssignee:(Assignee *)_assignee{
    self.assignee = _assignee;
    self.headlineLabel.text = NSLocalizedString(@"Assigned:", nil);
    self.placeholderLabel.text = NSLocalizedString(@"Anyone", nil);
    
    CGSize headlineLabelSize =  [self.headlineLabel.text sizeWithFont:self.headlineLabel.font
                                                    constrainedToSize:CGSizeMake(MAXFLOAT, self.headlineLabel.frame.size.height)
                                                        lineBreakMode:NSLineBreakByWordWrapping];
    self.headlineLabel.frame = CGRectMake(self.headlineLabel.frame.origin.x, self.headlineLabel.frame.origin.y, headlineLabelSize.width, self.headlineLabel.frame.size.height);
    
    self.bubbleView = [[[HEBubbleView alloc] initWithFrame:CGRectMake(self.headlineLabel.frame.origin.x+self.headlineLabel.frame.size.width+5, self.bubbleContainer.frame.origin.y, self.bubbleContainer.frame.size.width, self.bubbleContainer.frame.size.height)] autorelease];
    
    if (self.assignee) {
        self.placeholderLabel.hidden = YES;
        self.clearButton.hidden = NO;
        
        self.bubbleView.alwaysBounceVertical = NO;
        self.bubbleView.alwaysBounceHorizontal = NO;
        self.bubbleView.bubbleDataSource = self;
        self.bubbleView.bounces = NO;
        self.bubbleView.bubbleDelegate = self;
        self.bubbleView.selectionStyle = HEBubbleViewSelectionStyleDefault;
        
        [self addSubview:self.bubbleView];
        
        [self.bubbleView addItemAnimated:YES];
    } else{
        self.placeholderLabel.hidden = NO;
        self.clearButton.hidden = YES;
    }
    
}

-(IBAction)clearButtonPushed:(id)sender{
    
    [self.delegate clearAssignee];
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
        item = [[[HEBubbleViewItem alloc] initWithReuseIdentifier:itemIdentifier] autorelease];
    }
    

    item.textLabel.text = self.assignee.name;
    
    return item;
}


#pragma mark - bubble view delegate

-(void)bubbleView:(HEBubbleView *)bubbleView didSelectBubbleItemAtIndex:(NSInteger)index
{
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
    
    [assignee release];    
    [_headlineLabel release];
    [_bubbleContainer release];
    [_placeholderLabel release];
    
    [super dealloc];
}



@end
