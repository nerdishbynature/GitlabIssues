/**
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

/*
 PBLog is an NSLog() alternative and was created for being able to log events in an non-debug build state (e.g. AdHoc).
 Please consider README to get further setup instructions.
 Feel free to follow me on Twitter @piet_nbn .
 */

//This code was inspired by http://www.borkware.com/rants/agentm/mlog/

#import <Foundation/Foundation.h>
#import "PBFileLogger.h"

#define PBLog(s,...) [PBLog logFile:__FILE__ withLineNumber:__LINE__ andFormat:(s), ##__VA_ARGS__]
#define SEND_OVER_HTTP NO
#define LOG_TO_FILE NO


extern NSString *kURLString;
extern NSString *kContentType;
extern NSString *kHTTPMethod;

@interface PBLog : NSObject


/**
 Method used for logging
 @param file The class from which the log comes
 @param lineNumber The line number where the log was sent from
 @param format, ... The formatted string, which should be logged
 */
+ (void)logFile:(char*)file
   withLineNumber:(int)lineNumber
       andFormat:(NSString*)format, ...;
@end
