//
//  HATabItem.m
//  HotelApp
//
//  Created by Piet Brauer on 12.07.12.
//  Copyright (c) 2012 APPSfactory GmbH. All rights reserved.
//

#import "PBTabItem.h"

@interface PBTabItem (){
    id content;
}

@end

@implementation PBTabItem

@synthesize unselectedImageNamed;
@synthesize selectedImageNamed;
@synthesize labelText;
@synthesize viewController;

-(id)initWithSelectedImageNamed:(NSString *)_selectedImageName unselectedImageName:(NSString *)_unselectedImageNamed labelText:(NSString *)_labelText headLine:(NSString *)_headline andViewController:(id)_viewController{

    self = [super init];
    
    if (self) {
        self.selectedImageNamed = _selectedImageName;
        self.unselectedImageNamed = _unselectedImageNamed;
        self.labelText = _labelText;
        self.viewController = _viewController;
    }
    
    return self;
}

@end
