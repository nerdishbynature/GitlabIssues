//
//  NBNTabBarItem.m
//  GitLabIssues
//
//  Created by Piet Brauer on 14.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNTabBarItem.h"

@interface NBNTabBarItem ()

@property (nonatomic, retain) UIImage *customHighlightedImage;

@end

@implementation NBNTabBarItem
@synthesize customHighlightedImage;

-(id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)_customHighlightedImage tag:(NSInteger)tag{
    self = [super initWithTitle:title image:image tag:tag];
    if (self) {
        self.customHighlightedImage = _customHighlightedImage;
    }

    return self;
}

- (void)dealloc {
    self.customHighlightedImage = nil;
    
    [customHighlightedImage release];
    [super dealloc];
}

-(UIImage *)selectedImage {
    return self.customHighlightedImage;
}

-(UIImage *)image{
    return self.image;
}

@end
