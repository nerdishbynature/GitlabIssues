//
//  NBNFilterComponentsCell.m
//  GitLabIssues
//
//  Created by Piet Brauer on 07.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNFilterComponentsCell.h"

@interface NBNFilterComponentsCell ()

@property (nonatomic, retain) Milestone *milestone;
@property (nonatomic, retain) NSArray *labels;
@property (retain, nonatomic) IBOutlet UILabel *headlineLabel;
@property (retain, nonatomic) IBOutlet UIView *bubbleContainer;
@property (retain, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, retain) HEBubbleView *bubbleView;
@property (nonatomic, retain) IBOutlet UIButton *clearButton;

@end

@implementation NBNFilterComponentsCell
@synthesize milestone;
@synthesize labels;
@synthesize bubbleView;
@synthesize clearButton;
@synthesize delegate;

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

-(void)configureCellWithMilestone:(Milestone *)_milestone{
    self.milestone = _milestone;
    self.headlineLabel.text = @"Milestone:";
    self.placeholderLabel.text = @"None";
    
    CGSize headlineLabelSize =  [self.headlineLabel.text sizeWithFont:self.headlineLabel.font
                                                    constrainedToSize:CGSizeMake(MAXFLOAT, self.headlineLabel.frame.size.height)
                                                        lineBreakMode:NSLineBreakByWordWrapping];
    self.headlineLabel.frame = CGRectMake(self.headlineLabel.frame.origin.x, self.headlineLabel.frame.origin.y, headlineLabelSize.width, self.headlineLabel.frame.size.height);
    
    self.bubbleView = [[[HEBubbleView alloc] initWithFrame:CGRectMake(self.headlineLabel.frame.origin.x+self.headlineLabel.frame.size.width+5, self.bubbleContainer.frame.origin.y, self.bubbleContainer.frame.size.width, self.bubbleContainer.frame.size.height)] autorelease];
    
    if (self.milestone) {
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
        self.clearButton.hidden = YES;
        self.placeholderLabel.hidden = NO;
    }
}

-(void)configureCellWithLabels:(NSArray *)_labels{
    self.labels = _labels;
}

-(IBAction)clearButtonPushed:(id)sender{

    [self.delegate clearMilestone];
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
    

    item.textLabel.text = self.milestone.title;
    
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
    self.milestone = nil;
    self.labels = nil;
    
    [milestone release];
    [labels release];

    [_headlineLabel release];
    [_bubbleContainer release];
    [_placeholderLabel release];

    [super dealloc];
}

@end
