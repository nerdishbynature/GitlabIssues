//
//  ActionSheetPicker.h
//  ActionSheetPicker
//
//  Created by  on 13/03/2012.
//  Copyright (c) 2012 Club 15CC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AbstractActionSheetPicker.h"
#import "ActionSheetCustomPickerDelegate.h"

@interface ActionSheetCustomPicker : AbstractActionSheetPicker
{
}


#pragma mark - Properties

@property (nonatomic, strong) id<ActionSheetCustomPickerDelegate> delegate;



#pragma mark - Init Methods


/** 
 Designated init
 @param title The title string
 @param delegate The ActionSheetCustomPickerDelegate
 @param showCancelButton Decides wether to show the cancel button or not
 @param origin The object which called this method
 */
- (id)initWithTitle:(NSString *)title delegate:(id<ActionSheetCustomPickerDelegate>)delegate showCancelButton:(BOOL)showCancelButton origin:(id)origin;

/** 
 Convenience class method for creating an launched
 @param title The title string
 @param delegate The ActionSheetCustomPickerDelegate
 @param showCancelButton Decides wether to show the cancel button or not
 @param origin The object which called this method
 */
+ (id)showPickerWithTitle:(NSString *)title delegate:(id<ActionSheetCustomPickerDelegate>)delegate showCancelButton:(BOOL)showCancelButton origin:(id)origin;


@end
