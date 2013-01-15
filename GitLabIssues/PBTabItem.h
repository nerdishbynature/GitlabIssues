//
//  HATabItem.h
//  HotelApp
//
//  Created by Piet Brauer on 12.07.12.
//  Copyright (c) 2012 APPSfactory GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBTabItem : NSObject

/**
 Initializes the TabItem for usage in PBCustomTabBar
 @param _selectedImageName The image name which is used to load the selected image
 @param _unselectedImageNamed The image name which is used to load the unselected image
 @param _labelText The text which is used for the label of the tab item
 @param _headline The text which can be used for the viewcontrollers title
 @param _viewController The ViewController which should be presented
 */
-(id)initWithSelectedImageNamed:(NSString *)_selectedImageName unselectedImageName:(NSString *)_unselectedImageNamed labelText:(NSString *)_labelText headLine:(NSString *)_headline andViewController:(id)_viewController;

@property (nonatomic, strong) NSString *unselectedImageNamed;
@property (nonatomic, strong) NSString *selectedImageNamed;
@property (nonatomic, strong) NSString *labelText;
@property (nonatomic, strong) id viewController;

@end
