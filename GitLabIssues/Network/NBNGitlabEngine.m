//
//  NBNGitlabEngine.m
//  GitLabIssues
//
//  Created by Piet Brauer on 10.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNGitlabEngine.h"

@interface NBNGitlabEngine ()

@property (nonatomic, retain) MKNetworkOperation *op;

@end

@implementation NBNGitlabEngine
@synthesize op;

-(void) requestWithURL:(NSString *)urlString completionHandler:(GitlabResponseBlock)responseBlock errorHandler:(MKNKErrorBlock) errorBlock{
        
    self.op = [self operationWithURLString:urlString];
    
    [self.op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        responseBlock(completedOperation);
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:self.op];
}

-(void)cancel{
    [self.op cancel];
    self.op = nil;
}


@end
