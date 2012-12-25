//
//  Domain.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Domain : NSManagedObject

@property (nonatomic, retain) NSNumber * access_granted;
@property (nonatomic, retain) NSString * domain;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * protocol;
@property (nonatomic, retain) NSNumber * remember_me;

/**
 @brief Only used for FormKit
 */
-(void)save;

@end
