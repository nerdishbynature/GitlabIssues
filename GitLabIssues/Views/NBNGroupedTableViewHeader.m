//
//  NBNGroupedTableViewHeader.m
//  GitLabIssues
//
//  Created by Piet Brauer on 12.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNGroupedTableViewHeader.h"

@interface NBNGroupedTableViewHeader ()

@property (nonatomic, retain) IBOutlet UILabel *label;

@end

@implementation NBNGroupedTableViewHeader
@synthesize label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(NBNGroupedTableViewHeader *)loadViewFromNib{
    return (NBNGroupedTableViewHeader*)[[[NSBundle mainBundle] loadNibNamed:@"NBNGroupedTableViewHeader" owner:self options:0] objectAtIndex:0];
}

-(void)configureWithTitle:(NSString *)title{
    self.label.text = title;
}

-(void)dealloc{
    self.label = nil;
    
    [label release];
    [super dealloc];
}

@end
