//
//  NBNFilterSortCell.m
//  GitLabIssues
//
//  Created by Piet Brauer on 12.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNFilterSortCell.h"
#import "SVSegmentedControl.h"

@implementation NBNFilterSortCell
@synthesize delegate;
@synthesize created;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureView{
    SVSegmentedControl *navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:NSLocalizedString(@"Created", nil), NSLocalizedString(@"Updated", nil), nil]];
    navSC.selectedIndex = self.created ? 0 : 1;
    navSC.changeHandler = ^(NSUInteger newIndex) {
        self.created = newIndex;
        [self.delegate didChangeSortingTo:self.created];
    };
    
    navSC.frame = CGRectMake(10.f, 0.f, self.contentView.frame.size.width-20.f, self.contentView.frame.size.height);
    
    [self addSubview:navSC];
}

@end
