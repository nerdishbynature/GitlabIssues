//
//  PBFileLogger.m
//  meinKlub
//
//  Created by Piet Brauer on 04.12.12.
//
//

#import "PBFileLogger.h"
#import "PBLog.h"

@implementation PBFileLogger

- (void)dealloc {

    [logFile release];
    logFile = nil;
    [super dealloc];
}

- (id) init {
    if (self == [super init]) {

        NSString *fileName = @"application.log";
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];

        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        if (![fileManager fileExistsAtPath:filePath]){
            
            [fileManager createFileAtPath:filePath
                                 contents:nil
                               attributes:nil];
            
            NSError *error;
            NSString *resourceDBFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
            [fileManager copyItemAtPath:resourceDBFolderPath toPath:filePath error:&error];
            if (error) {
                PBLog(@"Error: %@", error);
            }
        }
        
        logFile = [[NSFileHandle fileHandleForWritingAtPath:filePath] retain];
        [logFile truncateFileAtOffset: 0];
        [logFile seekToFileOffset:0];
    }
    
    return self;
}

- (void)log:(NSString *)format, ... {
    va_list ap;
    va_start(ap, format);
    
    NSString *message = [[NSString alloc] initWithFormat:format arguments:ap];
    [logFile writeData:[[message stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [logFile synchronizeFile];
    
    [message release];
}

+ (PBFileLogger *)sharedInstance {
    static PBFileLogger *instance = nil;
    if (instance == nil) instance = [[PBFileLogger alloc] init];
    return instance;
}

@end
