//
//  Logger.h
//  Eyecon
//
//  Created by PhongLe on 3/17/11.
//  Copyright 2011 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomizedEnumType.h"

@interface Logger : NSObject {
 
}

//+ (void)shouldWriteLogToFile:(NSString *)fileName appended:(BOOL)appended;
+ (void)writeLogFileWithModeAppended:(BOOL)appended;
//+ (void)openLoggedFile:(NSString *)fileName appended:(BOOL)appended;
+ (void)openLoggedFileWithMode:(BOOL)appended;
+ (void)closeLoggedFile;
+ (void)setLogOutputLevel:(NSString *)level;
+ (void)doLog:(NSInteger)level format:(NSString *)format arguments:(va_list)args;
+ (void)logError:(NSString *)format,...;
+ (void)logWarning:(NSString *)format,...;
+ (void)logInfo:(NSString *)format,...;
+ (void)logDebug:(NSString *)format,...;
+ (void)printConsole:(NSString *)format,...;
+ (void)printConsole:(NSInteger)level format:(NSString *)format arguments:(va_list)args;
+ (BOOL)isDebugEnabled;
+ (BOOL)isDebugMode;
+ (BOOL)isPrintConsole;
+ (NSString *)getCurrentLogLevel;

@end
