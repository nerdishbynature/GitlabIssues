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

@property (nonatomic, strong) NSNumber * access_granted;
@property (nonatomic, strong) NSString * domain;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * protocol;
@property (nonatomic, strong) NSNumber * remember_me;

/**
  Only used for FormKit
 */
-(void)save;

@end
