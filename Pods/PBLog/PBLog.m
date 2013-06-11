/*
 Copyright © 2012 P. Brauer. All Rights Reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "PBLog.h"
#import "PBFileLogger.h"

//#error Place Your IP Adress here
NSString *kURLString = @"<your_ip_here>";
NSString *kContentType = @"application/x-www-form-urlencoded";
NSString *kHTTPMethod = @"POST";

@implementation PBLog

+ (void)logFile:(char*)file
 withLineNumber:(int)lineNumber
      andFormat:(NSString*)format, ...{
    
    va_list      listOfArguments;
    NSString    *formattedString;
    NSString    *sourceFile;
    NSString    *logString;
    
    va_start(listOfArguments, format);
    formattedString = [[NSString alloc] initWithFormat:format
                                             arguments:listOfArguments];
    va_end(listOfArguments);
    
    sourceFile = [[NSString alloc] initWithBytes:file
                                          length:strlen(file)
                                        encoding:NSUTF8StringEncoding];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd hh:mm:ss"];
    
    logString = [NSString stringWithFormat:@"[%@] %s[%d]: %@",
                 [formatter stringFromDate:[NSDate date]],
                 [[sourceFile lastPathComponent] UTF8String],
                 lineNumber,
                 formattedString];
#ifdef DEBUG
    printf("%s\n", [logString UTF8String]);
#endif
    if (SEND_OVER_HTTP) {
        [self sendLog:logString];
    }
    
    if (LOG_TO_FILE) {
        PBFileLog(@"%@", logString);
    }
    
    
    [formatter release];
    [formattedString release];
    [sourceFile release];
}

+(void)sendLog:(NSString *)logMessage{
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kURLString]] autorelease];
    [request setHTTPMethod:kHTTPMethod];
    
    [request setValue:kContentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:logMessage forHTTPHeaderField:@"log"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:0 completionHandler:nil];
}



@end
