//
//  NBNIssueDetailCell.m
//  GitLabIssues
//
//  Created by Piet Brauer on 31.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNIssueDetailCell.h"
#import "HEBubbleView.h"
#import "HEBubbleViewItem.h"

@interface NBNIssueDetailCell ()

@property (retain, nonatomic) IBOutlet UILabel *headlineLabel;
@property (retain, nonatomic) IBOutlet UIView *bubbleContainer;
@property (nonatomic, retain) NSString *detailString;
@property (retain, nonatomic) HEBubbleView *bubbleView;

@end

@implementation NBNIssueDetailCell
@synthesize headlineLabel;
@synthesize bubbleContainer;
@synthesize bubbleView;
@synthesize detailString;

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

+(NBNIssueDetailCell *)loadCellFromNib{
    return (NBNIssueDetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"NBNIssueDetailCell" owner:self options:0] objectAtIndex:0];
}

-(void)configureCellWithHeadline:(NSString *)headline andDescription:(NSString *)_descriptionString{

    self.headlineLabel.text = headline;
    
    CGSize headlineLabelSize =  [self.headlineLabel.text sizeWithFont:self.headlineLabel.font
                                                    constrainedToSize:CGSizeMake(MAXFLOAT, self.headlineLabel.frame.size.height)
                                                        lineBreakMode:NSLineBreakByWordWrapping];
    self.headlineLabel.frame = CGRectMake(self.headlineLabel.frame.origin.x, self.headlineLabel.frame.origin.y, headlineLabelSize.width, self.headlineLabel.frame.size.height);
    
    self.bubbleView = [[HEBubbleView alloc] initWithFrame:CGRectMake(self.headlineLabel.frame.origin.x+self.headlineLabel.frame.size.width+5, self.bubbleContainer.frame.origin.y, self.bubbleContainer.frame.size.width, self.bubbleContainer.frame.size.height)];
    
    self.detailString = _descriptionString;
    
    if (self.detailString.length > 0) {
        self.bubbleView.alwaysBounceVertical = NO;
        self.bubbleView.alwaysBounceHorizontal = NO;
        self.bubbleView.bubbleDataSource = self;
        self.bubbleView.bubbleDelegate = self;
        self.bubbleView.selectionStyle = HEBubbleViewSelectionStyleDefault;
        
        [self addSubview:self.bubbleView];
        
        [self.bubbleView addItemAnimated:YES];

    }    
}

- (void)dealloc {
    [headlineLabel release];
    [bubbleContainer release];
    [bubbleView release];
    [detailString release];
    [super dealloc];
}

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
    
    item.textLabel.text = self.detailString;
    
    return item;
}


#pragma mark - bubble view delegate

-(void)bubbleView:(HEBubbleView *)bubbleView didSelectBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"selected bubble at index %i", index);
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


@end
