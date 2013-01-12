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
#import "NBNGitlabEngine.h"
#import "NSString+NSHash.h"
#import "PBEmojiLabel.h"

@interface NBNIssueCommentCell ()

@property (nonatomic, retain) IBOutlet UIImageView *authorImageView;
@property (nonatomic, retain) IBOutlet UILabel *headlineLabel;
@property (nonatomic, retain) IBOutlet PBEmojiLabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateTimeLabel;
@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) NBNGitlabEngine *requestEngine;

@end

@implementation NBNIssueCommentCell
@synthesize authorImageView;
@synthesize headlineLabel;
@synthesize descriptionLabel;
@synthesize dateTimeLabel;
@synthesize note;
@synthesize requestEngine;

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

-(void)configureCellWithNote:(Note *)_note{
    
    self.note = _note;
    
    [self loadAuthorImage];
    
    self.headlineLabel.text = [NSString stringWithFormat:@"%@ commented", self.note.author.name];
    
    [self.descriptionLabel setEmojiText:self.note.body];
    
    if ([self.descriptionLabel.text isEqualToString:@"_Status changed to closed_"]) {
        self.descriptionLabel.text = @"Closed";
        self.descriptionLabel.textColor = [UIColor redColor];
        self.headlineLabel.text = [NSString stringWithFormat:@"%@ changed issue status to", self.note.author.name];
    } else if ([self.descriptionLabel.text isEqualToString:@"_Status changed to reopened_"]){
        self.descriptionLabel.text = @"Reopened";
        self.descriptionLabel.textColor = [UIColor greenColor];
        self.headlineLabel.text = [NSString stringWithFormat:@"%@ changed issue status to", self.note.author.name];
    }
    
    CGSize expectedSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(self.descriptionLabel.frame.size.width, MAXFLOAT)];
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, expectedSize.height);
    
//    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.note.created_at];
//    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
//    if([today day] == [otherDay day] &&
//       [today month] == [otherDay month] &&
//       [today year] == [otherDay year] &&
//       [today era] == [otherDay era]) {
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"hh:mm a"];
//        
//        self.dateTimeLabel.text = [formatter stringFromDate:self.note.created_at];
//        
//        [formatter release];
//    } else{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    
    self.dateTimeLabel.text = [formatter stringFromDate:self.note.created_at];
    
    [formatter release];
        
//    }
    
    self.dateTimeLabel.frame = CGRectMake(self.dateTimeLabel.frame.origin.x, self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height+3, self.dateTimeLabel.frame.size.width, self.dateTimeLabel.frame.size.height);

    
}

-(CGFloat)getHeightForCellWithNote:(Note *)_note{
    
    CGSize expectedSize = [_note.body sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(self.descriptionLabel.frame.size.width, MAXFLOAT)];
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, expectedSize.height);
    self.dateTimeLabel.frame = CGRectMake(self.dateTimeLabel.frame.origin.x, self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height+3, self.dateTimeLabel.frame.size.width, self.dateTimeLabel.frame.size.height);
    
    return CGSizeMake(self.frame.size.width, self.dateTimeLabel.frame.origin.y + self.dateTimeLabel.frame.size.height+5).height;
}

-(void)loadAuthorImage{
    self.requestEngine = [[NBNGitlabEngine alloc] init];
    
    [self.requestEngine requestWithURL:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=44", [self.note.author.email MD5]] completionHandler:^(MKNetworkOperation *request) {
        self.authorImageView.image = [UIImage imageWithData:request.responseData];
        CALayer * l = [self.authorImageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:5.0];
    } errorHandler:^(NSError *error) {
        PBLog(@"%@", [error localizedDescription]);
    }];
}

- (void)dealloc
{
    self.authorImageView = nil;
    self.headlineLabel = nil;
    self.descriptionLabel = nil;
    self.dateTimeLabel = nil;
    self.note = nil;
    self.requestEngine = nil;
    
    [authorImageView release];
    [headlineLabel release];
    [descriptionLabel release];
    [dateTimeLabel release];
    [note release];
    [requestEngine release];
    
    [super dealloc];
}

@end
