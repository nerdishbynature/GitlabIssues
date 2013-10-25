//
//  NBNIssueCommentCell.m
//  GitLabIssues
//
//  Created by Piet Brauer on 31.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NBNIssueCommentCell.h"
#import "Author.h"
#import "NSString+NSHash.h"
#import "PBEmojiLabel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NBNIssueCommentCell ()

@property (nonatomic, strong) IBOutlet UIImageView *authorImageView;
@property (nonatomic, strong) IBOutlet UILabel *headlineLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel; // PBEmojiLabel
@property (nonatomic, strong) IBOutlet UILabel *dateTimeLabel;
@property (nonatomic, strong) Note *note;

@end

@implementation NBNIssueCommentCell

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

+(NBNIssueCommentCell *)loadCellFromNib{
    return (NBNIssueCommentCell *)[[[NSBundle mainBundle] loadNibNamed:@"NBNIssueCommentCell" owner:self options:0] objectAtIndex:0];
}

-(void)configureCellWithNote:(Note *)note{
    
    self.note = note;
    
    [self loadAuthorImage];
    
    self.headlineLabel.text = [NSString stringWithFormat:@"%@ %@", self.note.author.name, NSLocalizedString(@"commented", nil)];
    
    [self.descriptionLabel setEmojiText:self.note.body];
    
    if ([self.descriptionLabel.text isEqualToString:@"_Status changed to closed_"]) {
        self.descriptionLabel.text = NSLocalizedString(@"Closed", nil);
        self.descriptionLabel.textColor = [UIColor redColor];
        self.headlineLabel.text = [NSString stringWithFormat:@"%@ %@", self.note.author.name, NSLocalizedString(@"changed issue status to", nil)];
    } else if ([self.descriptionLabel.text isEqualToString:@"_Status changed to reopened_"]){
        self.descriptionLabel.text = NSLocalizedString(@"Reopened", nil);
        self.descriptionLabel.textColor = [UIColor greenColor];
        self.headlineLabel.text = [NSString stringWithFormat:@"%@ %@", self.note.author.name, NSLocalizedString(@"changed issue status to", nil)];
    }
    
    CGSize expectedSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(self.descriptionLabel.frame.size.width, MAXFLOAT)];
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, expectedSize.height);

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    
    self.dateTimeLabel.text = [formatter stringFromDate:self.note.created_at];
    
    
    self.dateTimeLabel.frame = CGRectMake(self.dateTimeLabel.frame.origin.x, self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height+3, self.dateTimeLabel.frame.size.width, self.dateTimeLabel.frame.size.height);
}

-(CGFloat)getHeightForCellWithNote:(Note *)note{
    
    CGSize expectedSize = [note.body sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(self.descriptionLabel.frame.size.width, MAXFLOAT)];
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, expectedSize.height);
    self.dateTimeLabel.frame = CGRectMake(self.dateTimeLabel.frame.origin.x, self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height+3, self.dateTimeLabel.frame.size.width, self.dateTimeLabel.frame.size.height);
    
    return CGSizeMake(self.frame.size.width, self.dateTimeLabel.frame.origin.y + self.dateTimeLabel.frame.size.height+5).height;
}

-(void)loadAuthorImage{
    
    [self.authorImageView setImageWithURL:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=44", [self.note.author.email MD5]]];
    CALayer * l = [self.authorImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];

}


@end
