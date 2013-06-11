//
//  NBNIssueDescriptionCell.m
//  GitLabIssues
//
//  Created by Piet Brauer on 31.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNIssueDescriptionCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Author.h"
#import "NSString+NSHash.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NBNIssueDescriptionCell ()

@property (nonatomic, retain) IBOutlet UIImageView *authorImage;
@property (nonatomic, retain) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *issueHeaderLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) Issue *issue;

@end

@implementation NBNIssueDescriptionCell
@synthesize authorImage;
@synthesize authorNameLabel;
@synthesize issueHeaderLabel;
@synthesize descriptionLabel;
@synthesize issue;

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

+(NBNIssueDescriptionCell *)loadCellFromNib{
    return (NBNIssueDescriptionCell *)[[[NSBundle mainBundle] loadNibNamed:@"NBNIssueDescriptionCell" owner:self options:0] objectAtIndex:0];
}

-(void)configureCellWithIssue:(Issue *)_issue{
    self.issue = _issue;
    
    [self loadAuthorImage];
    
    self.authorNameLabel.text = self.issue.author.name;
    self.issueHeaderLabel.text = self.issue.title;
    self.descriptionLabel.text = self.issue.descriptionString;
    
    CGSize expectedSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(self.descriptionLabel.frame.size.width, MAXFLOAT)];
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, expectedSize.height);
}

-(CGFloat)getHeightForCellWithIssue:(Issue *)_issue{
    
    CGSize expectedSize = [_issue.descriptionString sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(self.descriptionLabel.frame.size.width, MAXFLOAT)];
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, expectedSize.height);
    
    return CGSizeMake(self.frame.size.width, self.descriptionLabel.frame.origin.y + expectedSize.height).height;
}

-(void)loadAuthorImage{

    [self.authorImage setImageWithURL:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=44", [self.issue.author.email MD5]]];
    
    CALayer * l = [self.authorImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
}

- (void)dealloc
{
    self.authorImage = nil;
    self.authorNameLabel = nil;
    self.issueHeaderLabel = nil;
    self.descriptionLabel = nil;
    
    [authorImage release];
    [authorNameLabel release];
    [issueHeaderLabel release];
    [descriptionLabel release];
    
    [super dealloc];
}

@end
