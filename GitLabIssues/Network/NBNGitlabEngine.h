//
//  NBNGitlabEngine.h
//  GitLabIssues
//
//  Created by Piet Brauer on 10.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface NBNGitlabEngine : MKNetworkEngine

typedef void (^GitlabResponseBlock)(MKNetworkOperation *request);
-(void) requestWithURL:(NSString *)urlString completionHandler:(GitlabResponseBlock)responseBlock errorHandler:(MKNKErrorBlock) errorBlock;

-(void)cancel;

@end
