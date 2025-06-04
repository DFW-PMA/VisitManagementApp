//
//  DefinesObjCOverrides.h
//  VisitManagementApp
//
//  Created by JustMacApps.net on 07/29/2024.
//  Copyright © 2023-2025 JustMacApps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JmObjCSwiftEnvBridge-Bridging-Header.h"

@interface DefinesObjCOverrides : NSObject
- (void)initInstance;
- (void)customLoggerTest1:(NSString * _Nullable)message;
// - (BOOL)performBlockCatchingException:(void (^)(void))block error:(NSError **)error;
- (BOOL)performBlockCatchingException:(void (^ _Nonnull)(void))block error:(NSError * _Nonnull)error;
@end

#define NSLog(...) XCGCustomLogger(__VA_ARGS__);

static void XCGCustomLogger(NSString * _Nonnull format, ...)
{
    
    if (!format)
    {
        
        // NO arguments to process...
        
        return;
        
    }
    
    va_list argumentList;
    
    va_start(argumentList, format);
    
    NSMutableString *message = [[NSMutableString alloc] initWithFormat:format arguments:argumentList];
    
    [JmObjCSwiftEnvBridge.sharedEnvBridge jmLogMsg:message];

    //  NSLogv(message, argumentList);

    va_end(argumentList);
    
}

