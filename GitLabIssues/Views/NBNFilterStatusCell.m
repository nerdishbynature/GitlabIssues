//
//  NBNFilterStatusCell.m
//  GitLabIssues
//
//  Created by Piet Brauer on 12.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNFilterStatusCell.h"
#import "SVSegmentedControl.h"

@implementation NBNFilterStatusCell
@synthesize delegate;
@synthesize closed;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    return self;
}

-(void)configureView{
    SVSegmentedControl *navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:NSLocalizedString(@"Open Issues", nil), NSLocalizedString(@"Closed Issues", nil), nil]];
    
    [navSC setSelectedSegmentIndex:self.closed ? 1 : 0 animated:YES];
    
    navSC.changeHandler = ^(NSUInteger newIndex) {
        if (newIndex == 0) {
            self.closed = NO;
        } else{
            self.closed = YES;
        }
        
        [self.delegate didChangeStatusTo:self.closed];
    };
    
    navSC.frame = CGRectMake(10.f, 0.f, self.frame.size.width-20.f, self.frame.size.height);
    
    [self addSubview:navSC];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
