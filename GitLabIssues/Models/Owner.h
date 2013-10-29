//
//  Owner.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Owner : NSManagedObject

@property (nonatomic, strong) NSNumber * blocked;
@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSNumber * identifier;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet *projects;
@end

@interface Owner (CoreDataGeneratedAccessors)

- (void)addProjectsObject:(Project *)value;
- (void)removeProjectsObject:(Project *)value;
- (void)addProjects:(NSSet *)values;
- (void)removeProjects:(NSSet *)values;

@end
