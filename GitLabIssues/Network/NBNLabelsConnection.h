//
//  NBNLabelsConnection.h
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBNLabelsConnection : NSObject

+(void)loadAllLabelsForProjectID:(NSUInteger)projectID onSuccess:(void (^)(void))block;

@end