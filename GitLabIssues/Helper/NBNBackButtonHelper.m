//
//  NBNBackButtonHelper.m
//  GitLabIssues
//
//  Created by Piet Brauer on 12.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNBackButtonHelper.h"

@implementation NBNBackButtonHelper

+(void)setCustomBackButtonForViewController:(id)viewController andNavigationItem:(UINavigationItem *)item{
    
    UIImage *backImage = [UIImage imageNamed:@"backButton.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20.f, 0.f, backImage.size.width, backImage.size.height);
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:viewController action:@selector(pushBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setAccessibilityLabel:@"BackButton"];
    
    UIBarButtonItem *backBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    backBarButtonItem.accessibilityLabel = @"back";
    item.hidesBackButton = YES;
    item.leftBarButtonItem = backBarButtonItem;
}

@end
