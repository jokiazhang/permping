//
//  Utility.m
//  Eyecon
//
//  Created by PhongLe on 7/7/10.
//  Copyright 2010 Appo CO., LTD. All rights reserved.
//

#import "Utility.h"
#import "CheckNetworkStatus.h"
#import "EyeConstant.h"
#import "IdentityModel.h"
#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <zlib.h>
#import "MBProgressHUD.h"
#include <netdb.h>
#include <net/if.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#import "DateTimeUtil.h"
#import "Logger.h"

static NSString *regexHtmlUnicodeInXmlInString = @"^.*&#....;";//^.*Str.*$"

@interface Utility()
//+ (id) dataWithCompressedBytes: (const void*) bytes length: (unsigned) length;
//+ (id) compressedDataWithBytes: (const void*) bytes length: (unsigned) length;
@end


@implementation Utility

+ (NSString *)generateItemID:(NSString *)seedString
{
	return [NSString stringWithFormat:@"%qu", [seedString hash] ];
} 

+ (NSString *)getCurrentDateInYYYYMMDDFormat
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"YYYY-MM-dd"];
	return [dateFormatter stringFromDate:[NSDate date]];
}

/**
 * check network status
 */
+ (BOOL)isNetworkAvailable
{
	BOOL ret = NO;
	CheckNetworkStatus *engine = [[CheckNetworkStatus alloc] init];
	while ( !engine.done )
	{
	}
	ret = engine.isNetworkAvailable;
	[engine release];
	return ret;
}

+ (BOOL)isPoint:(CGPoint)point inRect:(CGRect)rect
{
    CGPoint pOrigin = rect.origin;
    CGSize pSize = rect.size;
    
    if (point.x >= pOrigin.x && point.x <= pOrigin.x + pSize.width
        && point.y >= pOrigin.y && point.y <= pOrigin.y + pSize.height) 
    {
        return TRUE;
    }
	
    return FALSE;    
}

/**
 *	check the existence of a string in source
 */
+ (BOOL)isString:(NSString *)des isExistInString:(NSString *)src
{
	if (src == nil || des == nil) return FALSE;
	NSRange pos = [src rangeOfString:des];
	if ( pos.location != NSNotFound && pos.length > 0 )
		return TRUE;
	return FALSE;
}

/**
 *	check media item can play on renderer or not
 */
+ (BOOL)isProtocol:(NSString *)protocol supportItem:(MediaItem *)item
{
	NSArray *allRes = [item resources];
	NSString *resPro = nil;
	for ( MediaResource *res in allRes )
	{
		resPro = [NSString stringWithFormat:@"%@:%@:%@:", [res protocol], [res network], [res mimeType]];
		if ( [Utility isString:resPro isExistInString:protocol] )
			return TRUE;
	}
	return FALSE;
}


/**
 *	check a point is in frame or not
 */
+ (BOOL)isPoint:(CGPoint)point inFrame:(CGRect)frame
{
	if ( (frame.origin.x < point.x) &&
        (frame.origin.x + frame.size.width > point.x) &&
        (frame.origin.y < point.y) &&
        (frame.origin.y + frame.size.height > point.y)
		)
		return TRUE;
	return FALSE;
}

+ (BOOL)isHigherIPhone32
{
	BOOL ret = NO;
	NSString *version = [[UIDevice currentDevice] systemVersion];
	if ( [version floatValue] >= 3.2 )
		ret = YES;
	return ret;
}

+ (BOOL)isHigheriOS43
{
	BOOL ret = NO;
	NSString *version = [[UIDevice currentDevice] systemVersion];
	if ([version floatValue] >= 4.3)
		ret = YES;
	return ret;
}

+ (BOOL)isiOS5
{
    NSString *version = [[UIDevice currentDevice] systemVersion];
	if ( [version floatValue] >= 5.0 )
		return YES;
    
	return NO;
}

+ (BOOL)isOS4Device
{
	BOOL ret = NO;
	NSString *version = [[UIDevice currentDevice] systemVersion];
	if ( [version floatValue] >= 4.0 )
		ret = YES;
	return ret;
}

+ (float)convertDurationFromStringToFloat:(NSString *)duration
{
	float total = 0.0f;
	if ( duration )
	{
		NSArray *split = [duration componentsSeparatedByString:@":"];
        if (split != nil && [split count] > 0) {
            int max = [split count] - 1;
            for (int i = max; i >= 0; i--) {
                total += [[split objectAtIndex:i] floatValue] * powf(60.0, (max - i));
            }
		}
	}
	return total;
}

+ (NSString *)convertElapsedTimeFromFloatToString:(float)elapse
{
	int hour = elapse / 3600;
	int mins = (elapse - hour * 3600) / 60;
	float secs = (elapse - hour * 3600 - mins * 60);
	return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, mins, (int)secs];
}

+ (NSString *)convertTimeFromFloatToString:(float)time
{
	int hour = time / 3600;
	int mins = (time - hour * 3600) / 60;
	float secs = (time - hour * 3600 - mins * 60);
    if (hour > 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, mins, (int)secs];
    }
    else if (mins > 0) {
        return [NSString stringWithFormat:@"%02d:%02d", mins, (int)secs];
    }
	return [NSString stringWithFormat:@"0:%02d", (int)secs];
}

+ (void)saveUsers:(NSString *)userList
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:USERLIST_FILENAME];
	
	NSData *data = [userList dataUsingEncoding:NSUnicodeStringEncoding];
    BOOL exist = [fileManager fileExistsAtPath:filePath];
	if (!exist)
	{
		//BOOL result = 
		[fileManager createFileAtPath:filePath contents:data attributes:nil];
	}
	else
	{
		[data writeToFile:filePath atomically:YES];
	}
}

+ (NSData *)getUserList
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:USERLIST_FILENAME];
	NSError *error = nil;
	BOOL success = [fileManager fileExistsAtPath:filePath];
	if ( !success )
	{
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:USERLIST_FILENAME];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:filePath error:&error];
	}
	if (!success) return nil;
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
	NSData *data = [fileHandle readDataToEndOfFile];
	[fileHandle closeFile];
	return data;
}

+ (NSString *)convertCharToString:(char *)chars
{
	if ( !chars || strlen(chars) == 0 ) return nil;
	return [NSString stringWithUTF8String:chars];
}

/**
 *	show an alert view
 */
+ (UIAlertView *)showAlertMessageWithTitle:(NSString *)title content:(NSString *)content delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alert show];
    [alert release];
    return alert;
}

+ (NSString *)makeCleanXMLFile:(NSString *)aRoughString
{
	NSString *retVal = aRoughString;
	if (retVal)
	{
		retVal = [retVal stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
		retVal = [retVal stringByReplacingOccurrencesOfString:@"&amp;amp;" withString:@"&amp;"];
		retVal = [retVal stringByReplacingOccurrencesOfString:@"&amp;quot;" withString:@"&quot;"];
		retVal = [retVal stringByReplacingOccurrencesOfString:@"&amp;apos;" withString:@"&apos;"];
		retVal = [retVal stringByReplacingOccurrencesOfString:@"&amp;lt;" withString:@"&lt;"];
		retVal = [retVal stringByReplacingOccurrencesOfString:@"&amp;gt;" withString:@"&gt;"];
	}
	return retVal;
}

+ (NSString *)makeCleanXMLString:(NSString *)aRoughString
{
	NSString *retVal = aRoughString;
	if (retVal)
	{
		retVal = [retVal stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
		retVal = [retVal stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
		retVal = [retVal stringByReplacingOccurrencesOfString:@"&apos;" withString:@"\'"];
		retVal = [retVal stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
		retVal = [retVal stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
	}
	return retVal;
}

+ (NSString *)predefineStringInXML:(NSString *)aRoughString
{
	if (!aRoughString) {
		return @"";
	}
	
	NSString *retVal = aRoughString;
	if (retVal)
	{
		retVal = [retVal stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
		retVal = [retVal stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
		retVal = [retVal stringByReplacingOccurrencesOfString:@"\'" withString:@"&apos;"];
		retVal = [retVal stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
		retVal = [retVal stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
        
	}
	return retVal;
}

+ (NSString *)encodeParameterStringForHTTPRequest:(NSString *)param
{
    if (!param) {
		return @"";
	}
	
	NSString *retVal = param;
	if (retVal)
	{ 
        retVal = [retVal stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
        
        
		retVal = [retVal stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
	}
	return retVal;
}

+ (NSString *)encodeURLString:(NSString *)aRoughString
{
	if (!aRoughString) {
		return @"";
	}
	
	NSString *retVal = aRoughString;
	if (retVal)
	{ 
        retVal = [retVal stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
        
        
		retVal = [retVal stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
        retVal = [retVal stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
	}
	return retVal;
}

+ (BOOL)isValidMediaURLString:(NSString *)urlString
{
	if (urlString == nil || [urlString hasPrefix:@"null"]) {
		return NO;
	}
	return YES;
}

+ (NSString *)getAppBundleVersion
{
    static NSString *appVersion = nil;
    if (appVersion != nil) return appVersion;
    
    @synchronized(self) {
        if (appVersion == nil) {
            //get app verion
            NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"Info.plist"];
            NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:infoPath];
            appVersion = (IPADOS ? [settingsDict objectForKey:@"CFBundleVersioniPad"] : [settingsDict objectForKey:@"CFBundleVersion"]);
            if (appVersion == nil) {
                appVersion = [settingsDict objectForKey:@"CFBundleVersion"];
            }
            [appVersion retain];
        }
    }
	return appVersion;
}

+ (NSString *)getFileSize:(NSString *)fileName
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	if ([fileManager fileExistsAtPath:filePath])
	{
		NSError *error = nil;
		NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:&error];
		if ([attributes objectForKey:NSFileSize] != nil)
		{
			NSNumber *fileSize = (NSNumber *)[attributes objectForKey:NSFileSize];
			float size = [fileSize floatValue];
			NSString *text = nil;
			if (size < 1024)
				text = [NSString stringWithFormat:@"%d bytes", (int)size];
			else if (size / 1024 < 1024)
				text = [NSString stringWithFormat:@"%d KB", (int)(size / 1024)];
			else {
				text = [NSString stringWithFormat:@"%0.2f MB", (float)(size / (1024 * 1024))];
			}
			
			return text;
		}
	}
	return nil;
}

+ (NSString *)getStringFromDatetime:(NSDate *)date
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss-00:00"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	return [dateFormatter stringFromDate:date];
}

+ (NSDate *)getDateFromString:(NSString *)timestamp {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss-00:00"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	return [dateFormatter dateFromString:timestamp];
}

+ (BOOL)isURLWithFileExt:(NSString *)url
{
	int i = 0;
	NSRange splashRange = [url rangeOfString:@"/" options:NSBackwardsSearch];
	NSRange equalRange = [url rangeOfString:@"=" options:NSBackwardsSearch];
	NSRange dotRange = [url rangeOfString:@"." options:NSBackwardsSearch];
	if (splashRange.location == NSNotFound || equalRange.location == NSNotFound)
	{
		if (splashRange.location != NSNotFound)
			i = splashRange.location;
		else if (equalRange.location != NSNotFound)
			i = equalRange.location;
	}
	else
	{
		i = MAX(splashRange.location, equalRange.location);
	}
	
	if (dotRange.location != NSNotFound && dotRange.location > i)
	{
		NSString *extMT = [url substringFromIndex:(dotRange.location + 1)];
		NSDictionary *extMimeTypeList = [Configuration getDictionaryValueFromKey:APP_SUPPORT_EXTENSION_MIMETYPE_KEY];
		return  ([extMimeTypeList objectForKey:extMT] != nil ? TRUE : FALSE);
	}
	return FALSE;
}

+ (NSString *)trimString:(NSString *)str
{
	NSMutableCharacterSet *characterSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
	[characterSet addCharactersInString:@"\r"];
	return [str stringByTrimmingCharactersInSet:characterSet];
}

+ (NSString *)resolveUnicodeString:(NSString *)text
{
    static NSRegularExpression *regexHtmlUnicodeInXml = nil;
	if (regexHtmlUnicodeInXml == nil) {
        regexHtmlUnicodeInXml = [[NSRegularExpression alloc] initWithPattern:regexHtmlUnicodeInXmlInString options:0 error:nil];
	}
	@try {
		while (text != nil) {
            NSTextCheckingResult *matcher = [regexHtmlUnicodeInXml firstMatchInString:text options:NSMatchingCompleted range:NSMakeRange(0, [text length])];
            if (!matcher) {
                break;
            }
			//Get range of &#
			NSString *orinalHtmlcode;
			NSString *unicodeStr;
			NSRange firstrange = [text rangeOfString:@"&#"];//Ch&#7901;
			firstrange.length = [text length] - firstrange.location;
			NSRange secondrange = [text rangeOfString:@";" options:NSCaseInsensitiveSearch range:firstrange];
			firstrange.length = secondrange.location + 1 - firstrange.location;
			
			//get original unicode str
			orinalHtmlcode = [text substringWithRange:firstrange];
			//remove &# and ;
			firstrange.location = 2;
			firstrange.length = firstrange.length - 3;
			
			//get unicode token
			unicodeStr = [orinalHtmlcode substringWithRange:firstrange];
			unicodeStr = [NSString stringWithFormat:@"%X", [unicodeStr intValue]];
			unichar codeValue = (unichar) strtol([unicodeStr UTF8String], NULL, 16);
			unicodeStr = [NSString stringWithFormat:@"%C", codeValue];
			text = [text stringByReplacingOccurrencesOfString:orinalHtmlcode withString:unicodeStr];
		}
	}
	@catch (NSException *exception) {
		[Logger logError:@"Utility - resolveUnicodeString throw exception: %@  %@", [exception name], [exception reason]];
	}
	@finally {
		return text;
	}
}

+ (BOOL)isExistentConfigurationFile
{
	NSString *path1 = nil;
	NSString *path2 = nil;
	NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	path1 = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", CONFIGURATION_FILE_NAME, CONFIGURATION_FILE_EXTENTION]];
	
	path2 = [documentPath stringByAppendingPathComponent:CONFIGURATION_FOLDER_NAME];
	path2 = [path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", CONFIGURATION_FILE_NAME, CONFIGURATION_FILE_EXTENTION]];
	if (([fileManager fileExistsAtPath:path1] == YES) || ([fileManager fileExistsAtPath:path2] == YES))
	{
		return YES;
	}
	return NO;
}

//+ (id) compressedDataWithBytes: (const void*) bytes length: (unsigned) length
//{
//	unsigned long compressedLength = compressBound(length);
//	unsigned char* compressedBytes = (unsigned char*) malloc(compressedLength);
//	
//	if (compressedBytes != NULL && compress(compressedBytes, &compressedLength, bytes, length) == Z_OK) {
//		char* resizedCompressedBytes = realloc(compressedBytes, compressedLength);
//		if (resizedCompressedBytes != NULL) {
//			return [NSData dataWithBytesNoCopy: resizedCompressedBytes length: compressedLength freeWhenDone: YES];
//		} else {
//			return [NSData dataWithBytesNoCopy: compressedBytes length: compressedLength freeWhenDone: YES];
//		}
//	} else {
//		free(compressedBytes);
//		return nil;
//	}
//}

//+ (id) compressedDataWithData: (NSData*) data
//{
//	return [self compressedDataWithBytes: [data bytes] length: [data length]];
//}

//+ (id) dataWithCompressedBytes: (const void*) bytes length: (unsigned) length
//{
//	z_stream strm;
//	int ret;
//	unsigned char out[128 * 1024];
//	unsigned char* uncompressedData = NULL;
//	unsigned int uncompressedLength = 0;
//	
//	strm.zalloc = Z_NULL;
//	strm.zfree = Z_NULL;
//	strm.opaque = Z_NULL;
//	strm.avail_in = 0;
//	strm.next_in = Z_NULL;
//	
//	ret = inflateInit(&strm);
//	
//	if (ret == Z_OK) {
//		strm.avail_in = length;
//		strm.next_in = (void*) bytes;
//		
//		do {
//			strm.avail_out = sizeof(out);
//			strm.next_out = out;
//			
//			ret = inflate(&strm, Z_NO_FLUSH);
//			if (ret != Z_OK && ret != Z_STREAM_END) {
//				NSLog(@"inflat: ret != Z_OK %d", ret);
//				inflateEnd(&strm);
//				return nil;
//			}
//			
//			unsigned int have = sizeof(out) - strm.avail_out;
//			
//			if (uncompressedData == NULL) {
//				uncompressedData = malloc(have);
//				memcpy(uncompressedData, out, have);
//				uncompressedLength = have;
//			} else {
//				unsigned char* resizedUncompressedData = realloc(uncompressedData, uncompressedLength + have);
//				if (resizedUncompressedData == NULL) {
//					free(uncompressedData);
//					inflateEnd(&strm);
//					return nil;
//				} else {
//					uncompressedData = resizedUncompressedData;
//					memcpy(uncompressedData + uncompressedLength, out, have);
//					uncompressedLength += have;
//				}
//			}
//		} while (strm.avail_out == 0);
//	} else {
//		NSLog(@"ret != Z_OK");
//	}
//	
//	if (uncompressedData != NULL) {
//		return [NSData dataWithBytesNoCopy: uncompressedData length: uncompressedLength freeWhenDone: YES];
//	} else {
//		return nil;
//	}
//}
//
//+ (id) dataWithCompressedData: (NSData*) compressedData
//{
//	return [self dataWithCompressedBytes: [compressedData bytes] length: [compressedData length]];
//}

+ (NSString *)stringWithUTF8String:(char *)str
{
	if (str == NULL)
		return @"";
	return [NSString stringWithUTF8String:str];
}

+ (void)ignoreInteractionEvents
{	
	if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
		[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	}
}
+ (void)endIgnoreInteractionEvents
{
	if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}
}


static MBProgressHUD *mbProgress = nil;
+ (void)startSpinnerWithText:(NSString *)txt parentView:(UIView *)parent 
{
	mbProgress = [[MBProgressHUD alloc] initWithView:parent];
	
    // Set determinate mode
    mbProgress.mode = MBProgressHUDModeIndeterminate;
	
    // Add HUD to screen
    [parent addSubview:mbProgress];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right tim
	
    [mbProgress setMBLabelText:txt];
	[mbProgress show:YES];
}

+ (void)stopSpinner
{
	if (mbProgress)
        [mbProgress removeFromSuperview];
    [mbProgress release];
	mbProgress = nil;
}

+ (UIColor *)colorRefWithString:(NSString *)colorString
{
	if (colorString == nil || ![colorString hasPrefix:@"#"])
	{
		return nil;
	}
	
    NSScanner *scanner = [[NSScanner alloc] initWithString:colorString];
    unsigned color = 0;
	[scanner scanString:@"#" intoString:NULL];
    [scanner scanHexInt:&color];
    
    unsigned a = ([colorString length] < 9) ? 255.0f : ((color >> 24) & 0x000000FF);
    unsigned r = (color >> 16) & 0x0000FF;
    unsigned g = (color >> 8) & 0x0000FF;
    unsigned b = color & 0x0000FF;
    
    CGFloat rf = (CGFloat)r / 255.f;
    CGFloat gf = (CGFloat)g / 255.f;
    CGFloat bf = (CGFloat)b / 255.f;
    CGFloat af = (CGFloat)a / 255.f;
    
    [scanner release];
    
    return [UIColor colorWithRed:rf green:gf blue:bf alpha:af];
}

+ (NSString *)changeEyeconTemplateToRealConfig:(NSString *)text
{
    NSString *str = [text stringByReplacingOccurrencesOfString:EYECON_HTTP_TEMPLATE withString:[NSString stringWithFormat:@"%@/", [Configuration getValueForKey:CLOUD_SERVICE_BASE_URL_KEY]]];
    return [str stringByReplacingOccurrencesOfString:EYECON_HTTPS_TEMPLATE withString:[NSString stringWithFormat:@"%@/", [Configuration getValueForKey:CLOUD_SERVICE_BASE_HTTPS_URL_KEY]]];
}

+ (CGRect)getSuitableRect:(CGRect)originalRect withSize:(CGSize)size
{
    CGFloat scaleRatio = 1.0;
    if (size.width <= originalRect.size.width) {
        //check height of size
        if (size.height > originalRect.size.height) {
            //scale to height
            scaleRatio = originalRect.size.height / size.height;
        }
    }
    else {
        scaleRatio = MIN(originalRect.size.width / size.width, originalRect.size.height / size.height);
    }
    //calculate width, height and padding
    CGFloat width = scaleRatio * size.width;
    CGFloat height = scaleRatio *size.height;
    CGFloat paddingX = (originalRect.size.width - width) / 2;
    CGFloat paddingY = (originalRect.size.height - height) / 2;
    return CGRectMake(originalRect.origin.x + paddingX, originalRect.origin.y + paddingY, width, height);
}

+ (CGSize)getSuitableSizeFrom:(CGRect)originalRect withSize:(CGSize)size
{
    CGFloat scaleRatio = 1.0;
    if (size.width <= originalRect.size.width) {
        //check height of size
        if (size.height > originalRect.size.height) {
            //scale to height
            scaleRatio = originalRect.size.height / size.height;
        }
    }
    else {
        scaleRatio = MIN(originalRect.size.width / size.width, originalRect.size.height / size.height);
    }
    //calculate width, height and padding
    CGFloat width = scaleRatio * size.width;
    CGFloat height = scaleRatio *size.height;
    return CGSizeMake(width, height);
}

+ (NSString *)commaSeparatedListFromArray:(NSArray *)arrayObjs
{
    NSMutableString *result = [[NSMutableString alloc] init];
    for (NSString *obj in arrayObjs) {
        [result appendFormat:@",%@", obj];
    }
    NSString *listString = @"";
    if ([result length] > 0)
    {
        listString = [[result substringFromIndex:1] copy];
    }
    [result release];
    return [listString autorelease];
}

+ (NSString *)commaSeparatedListOfMediaType:(NSUInteger)mediaCat
{
    NSString *derivedString = [NSString stringWithString:@""];
    
    
    if (mediaCat & MEDIAITEM_MIMETYPE_AUDIO) {
        derivedString = [derivedString stringByAppendingString:@",audio"]; 
    }
    if (mediaCat & MEDIAITEM_MIMETYPE_IMAGE) {      
        derivedString = [derivedString stringByAppendingString:@",photo"]; 
    }
    if (mediaCat & MEDIAITEM_MIMETYPE_VIDEO) { 
        derivedString =[derivedString stringByAppendingString:@",video"];         
    }
    if (mediaCat & CAT_HASHTAG) {
        derivedString = [derivedString stringByAppendingString:@",Taglists"];
    }
    if ([derivedString length] > 1) {
        return [derivedString substringFromIndex:1];
    }
    
    return @"";
}

+ (NSData *)synchronizeDownloadFromUrl:(NSString *)strUrl
{
    if (strUrl == nil || [strUrl isEqualToString:@""] ) return nil;
    NSURL *URL = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 10];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    return (err == nil) ? data : nil;
}

+ (NSString *)buildTweetMessageForText:(NSString *)comment isTag:(BOOL)istag link:(NSString *)strLink
{
    //NSString *userName = [[UserManager getInstance].currentUser displayName];
    return [NSString stringWithFormat:@"%@ on %@: %@ @eyecapp. http://eye-c.com/t", istag?@"tagged":@"commented", strLink, comment]; 
}


+ (NSString *)getIPAddressFromSockAddress:(NSData *)sockAddress returnedPort:(int *)port
{
    char addressBuffer[100];
    
    struct sockaddr_in* socketAddress = (struct sockaddr_in*) [sockAddress bytes];
    int sockFamily = socketAddress->sin_family;
    
    if (sockFamily == AF_INET || sockFamily == AF_INET6) {
        
        const char* addressStr = inet_ntop(sockFamily,
                                           &(socketAddress->sin_addr), addressBuffer,
                                           sizeof(addressBuffer));
        
        *port = ntohs(socketAddress->sin_port);
        
        if (addressStr && *port > 0)
            return [NSString stringWithUTF8String:addressStr];
    }
	return nil;
}

+ (void)printRect:(CGRect)rect  extraString:(NSString *)str
{
    NSLog(@"%@--> %f  %f   %f   %f", str, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

+ (NSString *)getUniqueDeviceIdentifier
{
    static NSString *deviceUUid = nil;
    if (deviceUUid == nil) {
        @synchronized(self) {
            if (deviceUUid == nil) {
                deviceUUid = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"UNIQUE_DEVICE_UUID"];
                if (deviceUUid == nil) {
                    //create uuid
                    CFUUIDRef theUUID = CFUUIDCreate(NULL);
                    CFStringRef stringUUID = CFUUIDCreateString(NULL, theUUID);
                    CFRelease(theUUID);
                    deviceUUid = (NSString *)stringUUID;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:deviceUUid forKey:@"UNIQUE_DEVICE_UUID"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else {
                    [deviceUUid retain];
                }
            }
        }
    }
    return deviceUUid;
}

+ (NSString *)createUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef stringUUID = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return [(NSString *)stringUUID autorelease];
}

+ (NSString *)createKeyForIntegratedAlert:(NSString *)screen launchedcount:(int)launchedcount numpagevisited:(int)numpagevisited status:(BOOL)online
{
    NSString *sLaunchedCount = (launchedcount == - 1) ? @"na" : [NSString stringWithFormat:@"%d", launchedcount];
    NSString *sNumPageVisited = (numpagevisited == - 1) ? @"na" : [NSString stringWithFormat:@"%d", numpagevisited];
    return [NSString stringWithFormat:@"%@_%@_%@_%@", sLaunchedCount, (online) ? @"in" : @"out", screen, sNumPageVisited];
}

+ (NSDictionary *)parseHttpURLQueryString:(NSString *)URL
{
    NSMutableDictionary *results = [NSMutableDictionary dictionaryWithCapacity:5];
    NSArray *components = [URL componentsSeparatedByString:@"?"];
    NSString *queryString = [components lastObject];
    NSArray *queryElements = [queryString componentsSeparatedByString:@"&"];
    for (NSString *element in queryElements) {
        NSArray *keyVals = [element componentsSeparatedByString:@"="];
        NSString *key = [keyVals objectAtIndex:0];
        NSString *value = [keyVals lastObject];
        [results setObject:value forKey:key];
    }
    
    return [NSDictionary dictionaryWithDictionary:results];
}

+ (NSString *)getIOSClientType
{//iOS4_iPhone, iOS5_iPhone, iOS4_iPad, iOS5_iPad 
    NSString *iOSVersion = nil;
    NSString *iDeviceType = nil;
    if ([Utility isiOS5]) {
        iOSVersion = @"iOS5";
    } 
    else    
    {
        iOSVersion = @"iOS4";
    }
    NSString *deviceModel = [[UIDevice currentDevice] model];
    if ([deviceModel hasPrefix:@"iPad"] ) {
        iDeviceType = @"iPad";
    }
    else
    {
        iDeviceType = @"iPhone";
    }
    
    return [NSString stringWithFormat:@"%@_%@", iOSVersion, iDeviceType];    
}

+ (NSArray *)parseTaglistsInText:(NSString *)text
{ 
    NSMutableArray *detectedTags = [[NSMutableArray alloc] init];
    BOOL shouldSkipFirstTag = YES;
    if ([text hasPrefix:@"#"]) {
        shouldSkipFirstTag =NO;
    }
    NSArray *tagComponents = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    for (NSString *component in tagComponents) { 
        
        if (shouldSkipFirstTag) {
            shouldSkipFirstTag = NO;
            continue;
        }
        
        NSScanner *tagScanner = [NSScanner scannerWithString:component];
        NSString *scannedString = nil;
        [tagScanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&scannedString];
        if (scannedString) {
            [detectedTags addObject:[NSString stringWithFormat:@"#%@",scannedString]];
        }
    }
    return [detectedTags autorelease];
}

+ (NSInteger)getIndexOfName:(NSString *)name inIdentityList:(NSArray *)idList
{
    NSUInteger  index = 0;
    for (index = 0; index < [idList count]; index++) {
        IdentityModel *identity = [idList objectAtIndex:index];
        if ([name isEqualToString:identity.name])
            return index;
    }
    return -1;
}

+ (NSString *)decimalToBase36:(NSString *)numberString
{    
    if (!numberString || [numberString isEqualToString:@""]) {
        return @"";
    }
    
    NSString *base64 = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSMutableString *base36Number = [[NSMutableString alloc] init];
    NSUInteger number = [numberString intValue];
    
    while (number > 0) {
        NSUInteger  remainder = number % 36;
        [base36Number appendFormat:@"%C", [base64 characterAtIndex:remainder]];
        number = number / 36;
    }
    NSString *result = [Utility reverseString:base36Number];
    [base36Number release];
    return result;
}

+ (NSString *)base36ToDecimal:(NSString *)base36String
{    
    NSString *base64 = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSInteger decimal = 0;    
    int length = [base36String length];
    NSRange ran;
    NSString *ch;
    
    NSString *upperCase = [base36String uppercaseString];
    for (int i = 0; i < length; i++) {
        ch = [NSString stringWithFormat:@"%C", [upperCase characterAtIndex:i]];
        ran = [base64 rangeOfString:ch];
        if (ran.location != NSNotFound) {
            decimal += ran.location * (powf(36, length - 1 - i));
        }
    }
    return [NSString stringWithFormat:@"%d", decimal];
}

+ (NSString *)reverseString:(NSString *)string 
{
    NSMutableString *reversedString = [[NSMutableString alloc] init];
    NSRange fullRange = [string rangeOfString:string];
    NSStringEnumerationOptions enumerationOptions = (NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences);
    [string enumerateSubstringsInRange:fullRange options:enumerationOptions usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reversedString appendString:substring];
    }];
    return [reversedString autorelease];
}

+ (NSString *)array:(NSArray *)stringArray toStringWithSeparator:(NSString *)sep
{
    NSMutableString *arrayFlatten = [[NSMutableString alloc] init];
    for (NSString *com in stringArray) {
        [arrayFlatten appendFormat:@"%@%@", sep, com];
    }
    NSString *result = [arrayFlatten substringFromIndex:1];
    [arrayFlatten release];
    return result;
}

+ (int)countString:(NSString*)key inString:(NSString*)textToSearch
{
    NSScanner *mainScanner = [NSScanner scannerWithString:textToSearch];
    NSString *temp;
    NSInteger count = 0;
    while(![mainScanner isAtEnd])
    {
        [mainScanner scanUpToString:key intoString:&temp];
        if(![mainScanner isAtEnd])
        {
            count++;
            [mainScanner scanString:key intoString:nil];
        }
    }
    return count;
}

+ (void)saveData:(NSString *)str toFileName:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	NSData *data = [str dataUsingEncoding:NSUnicodeStringEncoding];
    BOOL exist = [fileManager fileExistsAtPath:filePath];
	if (!exist)
	{
		[fileManager createFileAtPath:filePath contents:data attributes:nil];
	}
	else
	{
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [fileHandle truncateFileAtOffset:[fileHandle seekToEndOfFile]];
        [fileHandle writeData:data];
        [fileHandle synchronizeFile];
        [fileHandle closeFile];
	}
}

+ (void)openAppStoreForEyeC
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/vn/app/taglists-by-eye-c-mix-share/id470605598?mt=8"]];
}

+ (NSString*)getLastHashTag:(NSString*)text
{
    NSRange range = [text rangeOfString:@"#" options:NSBackwardsSearch];
    if (NSNotFound == range.location)
    {
        return @"";
    }
    return [text substringFromIndex:range.location];
}

+ (NSString*)replaceLastHashTagInString:(NSString*)text byString:(NSString*)newText
{
    NSRange range = [text rangeOfString:@"#" options:NSBackwardsSearch];
    if (NSNotFound == range.location)
    {
        return text;
    }
    range.length = [text length] - range.location;
    return [text stringByReplacingCharactersInRange:range withString:newText];
}

+ (NSString *)getMobileCarrierNetworkName
{ 
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    NSString *carrierName = [[carrier carrierName] retain]; 
    [netinfo release];
    return [carrierName autorelease];
}

+ (void)clearWebviewCache
{
    //clear cached cookie
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookie *cookie;
    for (cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie]; 
    }
}

+ (BOOL)isNewLoggedInUser:(NSString *)strJoinDate
{
    NSDate *joinDate = [DateTimeUtil parseISO8601:strJoinDate];
    double diff = [joinDate timeIntervalSinceDate:[NSDate date]];
    diff = (diff < 0) ? (-1 * diff) : diff;
    if (diff < 60 * 10) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPattern:(NSString *)pattern match:(NSString *)str
{
    if (pattern == nil || [pattern length] == 0) return YES;
    if (str == nil || [str length] == 0) return YES;
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSTextCheckingResult *match = [regular firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    return (match && [match range].location != NSNotFound) ? YES : NO;
}

+ (NSString *)convertDoubleToDuration:(float) duration
{
	int hours = duration / 3600;
	int minutes = (duration - hours * 3600)/60;
	int seconds = (duration - hours * 3600 - minutes * 60);
	
	return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

+ (NSDictionary *)getPlistFileContentAtPath:(NSString *)path
{
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath:path] == NO)
	{
		return nil;
	}
	
	//check last date of this file
	NSData *plistDefaultXML = [fileManager contentsAtPath:path];
	NSDictionary *plistDefaultDict = (NSDictionary *)[NSPropertyListSerialization 
													  propertyListFromData:plistDefaultXML
													  mutabilityOption:NSPropertyListMutableContainersAndLeaves
													  format:&format
													  errorDescription:&errorDesc];
	if (plistDefaultDict == nil)
	{
		[Logger logError:@"Configuration - Error reading plist: %@, format: %d", errorDesc, format];
	}
	return plistDefaultDict;
}

+ (UIImage*)createStretchImage:(UIImage*)image withCap:(CUSTOMSEGMENT_CAPLOCATION)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);
    
    if (location == CUSTOMSEGMENT_CAPLEFT)
        // To draw the left cap and not the right, we start at 0, and increase the width of the image by the cap width to push the right cap out of view
        [image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CUSTOMSEGMENT_CAPRIGHT)
        // To draw the right cap and not the left, we start at negative the cap width and increase the width of the image by the cap width to push the left cap out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CUSTOMSEGMENT_CAPMIDDLE)
        // To draw neither cap, we start at negative the cap width and increase the width of the image by both cap widths to push out both caps out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+ (UIButton *)createSegmentCtrlWithBgImage:(UIImage *)bgImage highlightImage:(UIImage *)highlightImage text:(NSString*)buttonText stretch:(CUSTOMSEGMENT_CAPLOCATION)location capWidth:(CGFloat)capWidth buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight
{
    UIImage *buttonImage = nil;
    UIImage* buttonPressedImage = nil;
    if (location == CUSTOMSEGMENT_CAPLEFTANDRIGHT) {
        buttonImage = [bgImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
        buttonPressedImage = [highlightImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    }
    else
    {
        buttonImage = [Utility createStretchImage:[bgImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:location capWidth:capWidth buttonWidth:buttonWidth];
        buttonPressedImage = [Utility createStretchImage:[highlightImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:location capWidth:capWidth buttonWidth:buttonWidth];
    }
    
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonHeight);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

+ (CGFloat)convertNanValue:(CGFloat)value
{
    if (isnan(value) || value < 0) {
        value = 0.0;
    }
    return value;
}

+ (UIImage *)downloadImageWithURL:(NSString *)imageURL
{
    NSURL *URL = [NSURL URLWithString:imageURL];            
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy: NSURLRequestReloadIgnoringCacheData timeoutInterval: 10];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    return [UIImage imageWithData:data];
}

+ (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object  
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

+ (NSString *)getExtImageType:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
    }
    return nil;
}

+ (NSArray *)extractSuitableImagesFromRawHTMLEntry:(NSString *)rawHTML 
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    if(rawHTML!=nil&&[rawHTML length] != 0) 
    {
        NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"<\\s*?img\\s+[^>]*?\\s*src\\s*=\\s*([\"\'])((\\\\?+.)*?)\\1[^>]*?>" options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *imagesHTML = [regex matchesInString:rawHTML options:0 range:NSMakeRange(0, [rawHTML length])];
        [regex release];
        
        for (NSTextCheckingResult *image in imagesHTML) 
        {
            NSString *imageHTML = [rawHTML substringWithRange:image.range];
            
            NSRegularExpression* regex2 = [[NSRegularExpression alloc] initWithPattern:@"(?i)\\b((?:[a-z][\\w-]+:(?:/{1,3}|[a-z0-9%])|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’]))" options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray *imageSource=[regex2 matchesInString:imageHTML options:0 range:NSMakeRange(0, [imageHTML length])];
            [regex2 release];
            
            NSString *imageSourceURLString=nil;
            for (NSTextCheckingResult *result in imageSource) 
            {
                NSString *str=[imageHTML substringWithRange:result.range];
                
                if([str hasPrefix:@"http"]) 
                { 
                    //find jpg
                    NSRange r1=[str rangeOfString:@".jpg" options:NSBackwardsSearch&&NSCaseInsensitiveSearch];
                    if(r1.location==NSNotFound)
                    {
                        //find jpeg
                        NSRange r2=[str rangeOfString:@".jpeg" options:NSBackwardsSearch&&NSCaseInsensitiveSearch];
                        if(r2.location==NSNotFound) 
                        { 
                            //find png
                            NSRange r3=[str rangeOfString:@".png" options:NSBackwardsSearch&&NSCaseInsensitiveSearch];
                            if(r3.location==NSNotFound) 
                            { 
                                break;
                            } else 
                            {
                                imageSourceURLString=[str substringWithRange:NSMakeRange(0, r3.location+r3.length)];
                            }
                        } 
                        else 
                        {
                            //jpeg was found
                            imageSourceURLString=[str substringWithRange:NSMakeRange(0, r2.location+r2.length)];
                            break;
                        }
                    } 
                    else 
                    {
                        //jpg was found
                        imageSourceURLString=[str substringWithRange:NSMakeRange(0, r1.location+r1.length)];
                        break;
                    }
                }
            }
            
            if(imageSourceURLString != nil) 
            {
                [images addObject:imageSourceURLString];
            }
        }
    }
    return [images autorelease];
}

+ (NSArray *)parseHtmlContent:(NSString *)htmlContent
{
    static NSRegularExpression *classRegular = nil;
    static NSRegularExpression *attrsRegular = nil;
    if (classRegular == nil || attrsRegular == nil) {
        [classRegular release];
        [attrsRegular release];
        NSString *pattern = @"<a ([^>]+)>([^<]*)";
        classRegular = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
        pattern = @"([^ \"]+)=[\"']([^\"]*)[\"']";
        attrsRegular = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    }
    NSMutableArray *result = [NSMutableArray array];
    //get classes
    NSArray *matches = [classRegular matchesInString:htmlContent options:0 range:NSMakeRange(0, [htmlContent length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *attrs = [htmlContent substringWithRange:[match rangeAtIndex:1]];
        NSString *title = [htmlContent substringWithRange:[match rangeAtIndex:2]];
        
        //parse attrs
        NSArray *attrmatches = [attrsRegular matchesInString:attrs options:0 range:NSMakeRange(0, [attrs length])];
        NSMutableDictionary *attrDict = [NSMutableDictionary dictionaryWithCapacity:[matches count]];
        NSString *name;
        NSString *value;
        for (NSTextCheckingResult *attrmatch in attrmatches) {
            name = [attrs substringWithRange:[attrmatch rangeAtIndex:1]];
            value = [attrs substringWithRange:[attrmatch rangeAtIndex:2]];
            [attrDict setObject:value forKey:name];
        }
        [attrDict setObject:title forKey:@"attr_title"];
        [result addObject:[NSDictionary dictionaryWithDictionary:attrDict]];
    }
    return [NSArray arrayWithArray:result];
}
@end
