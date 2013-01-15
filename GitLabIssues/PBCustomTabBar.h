//
//  PBCustomTabBar.h
//  HotelApp
//
//  Created by Piet Brauer on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBCustomMoreViewController.h"

@interface PBCustomTabBar : UITabBarController

/**
 Shows new tab bar
 */

- (void)showNewTabBar;

/**
 Hides new tab bar
 */

- (void)hideNewTabBar;

/**
 Initializes custom Tabbar with rootItems
 @param _rootItems Array of PBTabItems
 */

-(id)initWithRootItems:(NSArray *)_rootItems;


@end
