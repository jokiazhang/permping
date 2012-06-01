//
//  Logger.m
//  Eyecon
//
//  Created by PhongLe on 3/17/11.
//  Copyright 2011 Appo CO., LTD. All rights reserved.
//

#import "Logger.h"
#import "Configuration.h"
#import "Constants.h"
#import "Configuration.h"
#import "CustomizedEnumType.h"

static LEVEL_LOG	staticLogLevel		= LEVEL_INFO;
static BOOL			IS_OPEN				= NO;


@interface Logger(private)
+ (void)openLoggedFileWithMode:(BOOL)appended;
+ (BOOL)shouldContinueGetLog;
@end


@implementation Logger

//+ (void)shouldWriteLogToFile:(NSString *)fileName appended:(BOOL)appended
+ (void)writeLogFileWithModeAppended:(BOOL)appended
{
	if (![Configuration isSupportedFeature:IPHONE_SUPPORT_TROUBLESHOOTING_LOG_KEY])
		return;
	//[self openLoggedFile:fileName appended:appended];
	[Logger openLoggedFileWithMode:appended];
}

//+ (void)openLoggedFile:(NSString *)fileName appended:(BOOL)appended
+ (void)openLoggedFileWithMode:(BOOL)appended
{
	//open to write log file
	// Get the path to the documents directory and append the databaseName
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // tuan : remove warning while compiling
	/*NSString *documentsDir = [ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filename = [documentsDir stringByAppendingPathComponent:EYECON_WRITELOG_FILENAME];*/
	
	//close old log file if any
	//[[EyeControlPoint getInstance] closeLoggedFile];
	
	//set log level
	[Logger setLogOutputLevel:[Configuration getValueForKey:IPHONE_SUPPORT_TROUBLESHOOTING_SELECTEDLEVEL_KEY]];
	//open it new log file
	//[[EyeControlPoint getInstance] openLoggedFile:filename appended:appended logLevel:staticLogLevel];
	IS_OPEN = YES;
	[pool drain];
}

+ (void)closeLoggedFile
{
	IS_OPEN = NO;
	//[[EyeControlPoint getInstance] closeLoggedFile];
}

+ (BOOL)isDebugEnabled
{
//#ifdef DEBUG_MODE
//	return YES;
//#endif
	return IS_OPEN;
}

+ (BOOL)isDebugMode
{
	return (LEVEL_DEBUG == staticLogLevel) ? YES : NO;
}

+ (void)setLogOutputLevel:(NSString *)level
{
	if (level != nil)
	{
		if ([level compare:@"0" options:NSCaseInsensitiveSearch] == NSOrderedSame)
			staticLogLevel = LEVEL_DEBUG;
		else if ([level compare:@"1" options:NSCaseInsensitiveSearch] == NSOrderedSame)
			staticLogLevel = LEVEL_INFO;
		else if ([level compare:@"2" options:NSCaseInsensitiveSearch] == NSOrderedSame)
			staticLogLevel = LEVEL_WARNING;
		else if ([level compare:@"3" options:NSCaseInsensitiveSearch] == NSOrderedSame)
			staticLogLevel = LEVEL_ERROR;
	}
	//[[EyeControlPoint getInstance] setLogLevel:staticLogLevel];
}

+ (NSString *)getCurrentLogLevel
{
	switch (staticLogLevel) {
		case LEVEL_DEBUG:
			return @"DEBUG";
			break;
		case LEVEL_INFO:
			return @"INFO";
			break;
		case LEVEL_WARNING:
			return @"WARNING";
			break;
		case LEVEL_ERROR:
			return @"ERROR";
			break;
		default:
			break;
	}
	return @"";
}

+ (void)logError:(NSString *)format,...
{
	va_list args;
	va_start(args, format);
	//write log
	[Logger doLog:LEVEL_ERROR format:[NSString stringWithFormat:@"ERROR: %@", format] arguments:args];
	//console
	[Logger printConsole:LEVEL_ERROR format:[NSString stringWithFormat:@"ERROR: %@", format] arguments:args];
	va_end(args);
}

+ (void)logWarning:(NSString *)format,...
{
	va_list args;
	va_start(args, format);
	[Logger doLog:LEVEL_WARNING format:[NSString stringWithFormat:@"WARNING: %@", format] arguments:args];
	//console
	[Logger printConsole:LEVEL_WARNING format:[NSString stringWithFormat:@"WARNING: %@", format] arguments:args];
	va_end(args);
}

+ (void)logInfo:(NSString *)format,...
{
	va_list args;
	va_start(args, format);
	[Logger doLog:LEVEL_INFO format:[NSString stringWithFormat:@"INFO: %@", format] arguments:args];
	//console
	[Logger printConsole:LEVEL_INFO format:[NSString stringWithFormat:@"INFO: %@", format] arguments:args];
	va_end(args);
}

+ (void)logDebug:(NSString *)format,...
{
	va_list args;
	va_start(args, format);
	[Logger doLog:LEVEL_DEBUG format:[NSString stringWithFormat:@"DEBUG: %@", format] arguments:args];
	//console
	[Logger printConsole:LEVEL_DEBUG format:[NSString stringWithFormat:@"DEBUG: %@", format] arguments:args];
	va_end(args);
}

+ (void)doLog:(NSInteger)level format:(NSString *)format arguments:(va_list)args
{
	if (IS_OPEN && level >= staticLogLevel) {
		if ([Logger shouldContinueGetLog])
		{
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
			
			NSString *logString = [[NSString alloc] initWithFormat:format arguments:args];
			//[[EyeControlPoint getInstance] writeLoggedData:logString];
			[logString release];
			[pool drain];
		}
		else {
			[Logger closeLoggedFile];
			//notify to UI
			NSNotification *noti = [NSNotification notificationWithName:EYECON_TROUBLESHOOTING_MESSAGE_NOTIFICATION object:nil];
			[[NSNotificationQueue defaultQueue] enqueueNotification:noti postingStyle:NSPostNow coalesceMask:NSNotificationCoalescingOnName forModes:nil];
		}
	}
}

+ (void)printConsole:(NSString *)format,...
{
	va_list args;
	va_start(args, format);
	//console
	[Logger printConsole:LEVEL_DEBUG format:format arguments:args];
	va_end(args);
}

+ (void)printConsole:(NSInteger)level format:(NSString *)format arguments:(va_list)args
{
	if ([Logger isPrintConsole])
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
		
		NSString *logString = [[NSString alloc] initWithFormat:format arguments:args];
		EYELOG(@"%@", logString);
 		[logString release];
		[pool drain];
	}
}

+ (BOOL)isPrintConsole
{
#ifdef DEBUG_MODE
	return YES;
#endif
	return NO;
}

+ (BOOL)shouldContinueGetLog
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:EYECON_WRITELOG_FILENAME];
	
	if ([fileManager fileExistsAtPath:filePath])
	{
		NSError *error = nil;
		NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:&error];
		if ([attributes objectForKey:NSFileSize] != nil)
		{
			NSNumber *fileSize = (NSNumber *)[attributes objectForKey:NSFileSize];
			float size = [fileSize floatValue];
			//get fixed size from configuration
			NSString *fixedSize = [Configuration getValueForKey:IPHONE_SUPPORT_TROUBLESHOOTING_FILESIZE_KEY];
			if (fixedSize == nil)
				return YES;
			return ([fixedSize floatValue] * 1024 * 1024 > size) ? YES : NO;
		}
	}
	return NO;
}

@end
