//
//  NBNTabBarItem.h
//  GitLabIssues
//
//  Created by Piet Brauer on 14.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBNTabBarItem : UITabBarItem

-(id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)_customHighlightedImage tag:(NSInteger)tag;

@end
