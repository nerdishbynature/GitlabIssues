//
//  NBNIssueCell.m
//  GitLabIssues
//
//  Created by Piet Brauer on 30.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNIssueCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Author.h"
#import "NSString+NSHash.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NBNIssueCell ()

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (retain, nonatomic) IBOutlet UIImageView *developerProfilePicture;
@property (retain, nonatomic) IBOutlet UILabel *developerTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *createdLabel;
@property (nonatomic, retain) Issue *issue;

@end


@implementation NBNIssueCell

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

-(void)configureCellWithIssue:(Issue *)issue{
    self.issue = issue;
    
    self.titleLabel.text = self.issue.title;
    
    self.descriptionLabel.text = self.issue.descriptionString;
    
    self.developerTitleLabel.text = self.issue.author.name;
    
    self.createdLabel.text = [NSString stringWithFormat:@"%@ #%@", NSLocalizedString(@"created", nil),self.issue.identifier];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    
    self.dateLabel.text = [formatter stringFromDate:self.issue.created_at];
    
    [formatter release];
    
    [self calculateSizes];
    
    
    [self.developerProfilePicture setImageWithURL:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=44", [self.issue.author.email MD5]]];
    
    CALayer * l = [self.developerProfilePicture layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
}

-(void)calculateSizes{
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, [self getHeightForLabel:self.titleLabel]);
    self.titleLabel.numberOfLines = [self getLinesForLabel:self.titleLabel];
    
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+3, self.descriptionLabel.frame.size.width, [self getHeightForLabel:self.descriptionLabel]);
    
    self.descriptionLabel.numberOfLines = [self getLinesForLabel:self.descriptionLabel];
    
    CGSize developerTitleLabelSize =  [self.developerTitleLabel.text sizeWithFont:self.developerTitleLabel.font
                                                                constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    self.developerTitleLabel.frame = CGRectMake(self.developerTitleLabel.frame.origin.x, self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height+3, developerTitleLabelSize.width, self.developerTitleLabel.frame.size.height);
    
    self.createdLabel.frame = CGRectMake(self.developerTitleLabel.frame.origin.x+self.developerTitleLabel.frame.size.width+2.f, self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height+3, self.createdLabel.frame.size.width, self.createdLabel.frame.size.height);

    self.developerProfilePicture.frame = CGRectMake(self.developerProfilePicture.frame.origin.x, self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height+3, self.developerProfilePicture.frame.size.width, self.developerProfilePicture.frame.size.height);
}

-(CGFloat)getHeightForLabel:(UILabel *)label{
    CGFloat labelHeight =  [label.text sizeWithFont:label.font
                                constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT)
                                    lineBreakMode:NSLineBreakByWordWrapping].height;
    return labelHeight;
}

-(int)getLinesForLabel:(UILabel *)label{
    int lines =  [label.text sizeWithFont:label.font
                  constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT)
                      lineBreakMode:NSLineBreakByWordWrapping].height /label.font.pointSize;//16 is font size
    return lines;
}

-(CGFloat)getCalculatedHeight:(Issue *)_issue{
    return self.developerTitleLabel.frame.origin.y+self.developerTitleLabel.frame.size.height+10.f;
}

+(NBNIssueCell *)loadCellFromNib{
    return (NBNIssueCell *)[[[NSBundle mainBundle] loadNibNamed:@"NBNIssueCell" owner:self options:0] objectAtIndex:0];
}

- (void)dealloc {
    self.titleLabel = nil;
    self.dateLabel = nil;
    self.descriptionLabel = nil;
    self.developerProfilePicture = nil;
    self.developerTitleLabel = nil;
    self.createdLabel = nil;
    self.issue = nil;
    
    [_titleLabel release];
    [_dateLabel release];
    [_descriptionLabel release];
    [_developerProfilePicture release];
    [_developerTitleLabel release];
    [_createdLabel release];
    [_issue release];
    
    [super dealloc];
}
@end
