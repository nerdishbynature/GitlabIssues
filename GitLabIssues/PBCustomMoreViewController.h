//
//  PBCustomMoreViewController.h
//  HotelApp
//
//  Created by Piet Brauer on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBTabItem.h"

@interface PBCustomMoreViewController : UITableViewController{
    NSArray *viewController;
    NSArray *rootItems;
}

-(id)initWithViewController:(NSArray *)viewController andRootItems:(NSArray *)rootItems;

@property (nonatomic, strong) NSArray *viewController;
@property (nonatomic, strong) NSArray *rootItems;

@end
