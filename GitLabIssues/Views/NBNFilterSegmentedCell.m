//
//  NBNFilterSegmentedCell.m
//  GitLabIssues
//
//  Created by Piet Brauer on 07.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNFilterSegmentedCell.h"

@interface NBNFilterSegmentedCell ()

@property (nonatomic, assign) BOOL isClosedCell;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation NBNFilterSegmentedCell
@synthesize isClosedCell;
@synthesize segmentedControl;

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

+(NBNFilterSegmentedCell *)loadCellFromNib{
    return (NBNFilterSegmentedCell *)[[[NSBundle mainBundle] loadNibNamed:@"NBNFilterSegmentedCell" owner:self options:kNilOptions] objectAtIndex:0];
}

-(void)configureCellIsClosedCell:(BOOL)_isClosedCell{
    self.isClosedCell = _isClosedCell;
    
    if (self.isClosedCell) {
        self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Open Issues",@"Closes Issues"]];
    } else{
        self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Created", @"Updated"]];
    }
}

-(void)dealloc{
    self.segmentedControl = nil;

    [segmentedControl release];

    [super dealloc];
}

@end
