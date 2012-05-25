//
//  Configuration.m
//  Eyecon
//
//  Created by PhongLe on 9/6/10.
//  Copyright 2010 Appo CO., LTD. All rights reserved.
//

#import "Configuration.h"
#import "Constants.h"
#import "Utility.h"
#import "Logger.h"

@interface Configuration()

+ (NSDictionary *)getConfigurationInBundle;
+ (NSString *)makeCleanValue:(NSString *)dirtyValue in:(NSMutableDictionary *)dict;

@end


@implementation Configuration

static NSMutableDictionary *configurationDict = nil;

+ (void)saveData:(id)value forKey:(NSString *)key
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	NSString *error = nil;
	NSPropertyListFormat format;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *configFolder = [rootPath stringByAppendingPathComponent:CONFIGURATION_FOLDER_NAME];
    NSString *plistPath = [configFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", CONFIGURATION_FILE_NAME, CONFIGURATION_FILE_EXTENTION]];

	//assume that configuration.plist is existent
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSMutableDictionary *plistDict = (NSMutableDictionary *)[NSPropertyListSerialization
															 propertyListFromData:plistXML
															 mutabilityOption:NSPropertyListMutableContainersAndLeaves
															 format:&format errorDescription:&error];
	
	//get list of configuration files
	int i = 0;
	NSArray *configFiles = (NSArray *)[plistDict objectForKey:CLOUD_SUPPORT_CONFIGURATIONS];
	for (i = [configFiles count] - 1; i >= 0; i--)
	{
		error = nil;
		NSString *configFile = [configFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [configFiles objectAtIndex:i], CONFIGURATION_FILE_EXTENTION]];
		NSData *configData = [[NSFileManager defaultManager] contentsAtPath:configFile];
		NSMutableDictionary *configDict = (NSMutableDictionary *)[NSPropertyListSerialization
																 propertyListFromData:configData
																 mutabilityOption:NSPropertyListMutableContainersAndLeaves
																 format:&format errorDescription:&error];
		if ([configDict objectForKey:key] != nil)
		{
			error = nil;
			[configDict setObject:value forKey:key];
			configData = [NSPropertyListSerialization dataFromPropertyList:configDict
																		   format:NSPropertyListXMLFormat_v1_0
																 errorDescription:&error];
			if(configData) {
				[configData writeToFile:configFile atomically:YES];
				
				//update the configuration dict
				if (configurationDict != nil)
				{
					[configurationDict setObject:value forKey:key];
				}
			}
			break;
		}
	}
	if (i < 0)
	{
		error = nil;
		NSString *configFile = [configFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", CONFIGURATION_FILE_NAME, CONFIGURATION_FILE_EXTENTION]];
		NSData *configData = [[NSFileManager defaultManager] contentsAtPath:configFile];
		NSMutableDictionary *configDict = (NSMutableDictionary *)[NSPropertyListSerialization
																  propertyListFromData:configData
																  mutabilityOption:NSPropertyListMutableContainersAndLeaves
																  format:&format errorDescription:&error];
		if ([configDict objectForKey:key] != nil)
		{
			error = nil;
			[configDict setObject:value forKey:key];
			configData = [NSPropertyListSerialization dataFromPropertyList:configDict
																	format:NSPropertyListXMLFormat_v1_0
														  errorDescription:&error];
			if(configData) {
				[configData writeToFile:configFile atomically:YES];
				
				//update the configuration dict
				if (configurationDict != nil)
				{
					[configurationDict setObject:value forKey:key];
				}
			}
		}
	}
	//NSString *error = nil;
//	NSPropertyListFormat format;
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@\%@.%@", CONFIGURATION_FOLDER_NAME, CONFIGURATION_FILE_NAME, CONFIGURATION_FILE_EXTENTION]];
//	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
//	NSMutableDictionary *plistDict = (NSMutableDictionary *)[NSPropertyListSerialization
//															 propertyListFromData:plistXML
//															 mutabilityOption:NSPropertyListMutableContainersAndLeaves
//															 format:&format errorDescription:&error];
//	error = nil;
//	[plistDict setObject:value forKey:key];
//    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
//																   format:NSPropertyListXMLFormat_v1_0
//														 errorDescription:&error];
//    if(plistData) {
//        [plistData writeToFile:plistPath atomically:YES];
//		
//		//update the configuration dict
//		if (configurationDict != nil)
//		{
//			[configurationDict setObject:value forKey:key];
//		}
//    }
//	
//    else {
//        //[error release];
//    }
}

+ (void)savePartnerId:(NSString *)partnerId
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *configFolder = [rootPath stringByAppendingPathComponent:CONFIGURATION_FOLDER_NAME];
	NSString *error = nil;
	NSPropertyListFormat format;
	NSString *configFile = [configFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", CONFIGURATION_FILE_NAME, CONFIGURATION_FILE_EXTENTION]];
	NSData *configData = [[NSFileManager defaultManager] contentsAtPath:configFile];
	NSMutableDictionary *configDict = (NSMutableDictionary *)[NSPropertyListSerialization
															  propertyListFromData:configData
															  mutabilityOption:NSPropertyListMutableContainersAndLeaves
															  format:&format errorDescription:&error];
	if ([configDict objectForKey:PARTNER_ID_KEY] != nil)
	{
		error = nil;
		[configDict setObject:partnerId forKey:PARTNER_ID_KEY];
		configData = [NSPropertyListSerialization dataFromPropertyList:configDict
																format:NSPropertyListXMLFormat_v1_0
													  errorDescription:&error];
		if(configData) {
			[configData writeToFile:configFile atomically:YES];
			
			//update the configuration dict
			if (configurationDict != nil)
			{
				[configurationDict setObject:partnerId forKey:PARTNER_ID_KEY];
			}
		}
		if (![partnerId isEqualToString:PARTNER_DEFAULT_NAME])
		{
			NSString *configurationPartner = [NSString stringWithFormat:@"%@_%@", CONFIGURATION_FILE_NAME, partnerId];
			[Configuration parseConfigurationFiles:[NSArray arrayWithObject:configurationPartner] result:configurationDict];
		}
	}
}

+ (void)saveTempData:(id)value forKey:(NSString *)key
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	[configurationDict setObject:value forKey:key];
}

+ (NSDictionary *)getConfigurationInBundle
{
	NSString *errorDesc = nil;
	NSError *error = nil;
	NSPropertyListFormat format;
	NSString *plistPath;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *configFolder = [rootPath stringByAppendingPathComponent:CONFIGURATION_FOLDER_NAME];
	if ([fileManager fileExistsAtPath:configFolder] == NO)
	{
		//create Configuration folder
		[fileManager createDirectoryAtPath:configFolder withIntermediateDirectories:YES attributes:nil error:&error];
	}
	plistPath = [configFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", CONFIGURATION_FILE_NAME, CONFIGURATION_FILE_EXTENTION]];
	
	error = nil;
	NSString *defaultPlistPath = [[NSBundle mainBundle] pathForResource:CONFIGURATION_FILE_NAME ofType:CONFIGURATION_FILE_EXTENTION inDirectory:CONFIGURATION_FOLDER_NAME];
	if ([fileManager fileExistsAtPath:plistPath] == NO)
	{
		[fileManager copyItemAtPath:defaultPlistPath toPath:plistPath error:&error];
	}
	
	//check last date of this file
	NSData *plistDefaultXML = [fileManager contentsAtPath:defaultPlistPath];
	NSDictionary *plistDefaultDict = (NSDictionary *)[NSPropertyListSerialization 
													  propertyListFromData:plistDefaultXML
													  mutabilityOption:NSPropertyListMutableContainersAndLeaves
													  format:&format
													  errorDescription:&errorDesc];
	errorDesc = nil;
	NSData *plistDocXML = [fileManager contentsAtPath:plistPath];
	NSDictionary *plistDocDict = (NSDictionary *)[NSPropertyListSerialization 
												  propertyListFromData:plistDocXML
												  mutabilityOption:NSPropertyListMutableContainersAndLeaves
												  format:&format
												  errorDescription:&errorDesc];
	//get last change
	if (![[plistDefaultDict objectForKey:CONFIGURATION_FILE_LASTCHANGED] isEqualToString:[plistDocDict objectForKey:CONFIGURATION_FILE_LASTCHANGED]])
	{
		//backup app version
//		NSString *appVersion = [plistDocDict objectForKey:APP_VERSION_KEY];
//		if (appVersion == nil)
//			appVersion = [plistDefaultDict objectForKey:APP_VERSION_KEY];
//		//back up partner_id
//		NSString *partnerId = [plistDocDict objectForKey:PARTNER_ID_KEY];
//		if (partnerId == nil)
//			partnerId = [plistDefaultDict objectForKey:PARTNER_ID_KEY];
		//the configuration changed
		error = nil;
		//remove Configuration folder
		[fileManager removeItemAtPath:configFolder error:&error];
		//create Configuration folder
		[fileManager createDirectoryAtPath:configFolder withIntermediateDirectories:YES attributes:nil error:&error];
		[fileManager copyItemAtPath:defaultPlistPath toPath:plistPath error:&error];
		
		plistDocXML = [fileManager contentsAtPath:plistPath];
		plistDocDict = (NSDictionary *)[NSPropertyListSerialization 
													  propertyListFromData:plistDocXML
													  mutabilityOption:NSPropertyListMutableContainersAndLeaves
													  format:&format
													  errorDescription:&errorDesc];
//		//save app version
//		[plistDocDict setValue:appVersion forKey:APP_VERSION_KEY];
//		//save partner id
//		[plistDocDict setValue:partnerId forKey:PARTNER_ID_KEY];
//		NSString *sError = nil;
//		plistDocXML = [NSPropertyListSerialization dataFromPropertyList:plistDocDict
//																	format:NSPropertyListXMLFormat_v1_0
//														  errorDescription:&sError];
//		if(plistDocXML != nil) {
//			[plistDocXML writeToFile:plistPath atomically:YES];
//		}
	}
	if (plistDocDict == nil)
	{
		[Logger logError:@"Configuration - Error reading plist: %@, format: %d", errorDesc, format];
	}
	return plistDocDict;
}

+ (NSString *)makeCleanValue:(NSString *)dirtyValue in:(NSMutableDictionary *)dict
{
	NSRange begin;
	NSRange end;
	NSRange body;
	NSString *newKey = nil;
	NSString *cleanValue = dirtyValue;
	do {
		begin = [cleanValue rangeOfString:@"${"];
		end = [cleanValue rangeOfString:@"}"];
		body = NSMakeRange(begin.location + begin.length, end.location - begin.location - begin.length);
		if(body.location == NSNotFound || body.length + body.location >= [cleanValue length])
		{
			[Logger logWarning:@"Configuration - makeCleanValue function can't edit value for key '%@'", newKey];
		}
		else {
			newKey = [cleanValue substringWithRange:body];
			cleanValue = [cleanValue stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"${%@}", newKey] withString:[dict objectForKey:newKey]];
		}
	} while ([Utility isString:@"${" isExistInString:cleanValue]);
	return cleanValue;
}

+ (void)parseConfigurationFiles:(NSArray *)configFiles result:(NSMutableDictionary *)retDict
{
	NSError *error = nil;
	NSPropertyListFormat format;
	NSString *plistPath;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *configFolder = [rootPath stringByAppendingPathComponent:CONFIGURATION_FOLDER_NAME];
	if ([fileManager fileExistsAtPath:configFolder] == NO)
	{
		//create Configuration folder
		[fileManager createDirectoryAtPath:configFolder withIntermediateDirectories:YES attributes:nil error:&error];
	}
	for (NSString *pfile in configFiles)
	{
		NSString *errorDesc = nil;
		plistPath = [configFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", pfile, CONFIGURATION_FILE_EXTENTION]];
		if ([fileManager fileExistsAtPath:plistPath] == NO)
		{
			//copy it to Document/Configuration folder
			NSString *defaultPlistPath = [[NSBundle mainBundle] pathForResource:pfile ofType:CONFIGURATION_FILE_EXTENTION inDirectory:CONFIGURATION_FOLDER_NAME];
			if (![fileManager fileExistsAtPath:defaultPlistPath])
				return;
			[fileManager copyItemAtPath:defaultPlistPath toPath:plistPath error:&error];
		}
		error = nil;
		NSData *plistDocXML = [fileManager contentsAtPath:plistPath];
		NSDictionary *plistDocDict = (NSDictionary *)[NSPropertyListSerialization 
													  propertyListFromData:plistDocXML
													  mutabilityOption:NSPropertyListMutableContainersAndLeaves
													  format:&format
													  errorDescription:&errorDesc];
		[retDict addEntriesFromDictionary:plistDocDict];
	}
}

+ (void)readConfigurationFile
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	@synchronized(self) {
        if (configurationDict != nil) return;
        NSMutableDictionary *dictTemp = [[NSMutableDictionary dictionary] retain];
	NSDictionary *temp = [Configuration getConfigurationInBundle];
	if (temp != nil)
	{
            [dictTemp addEntriesFromDictionary:temp];
		NSArray *configFiles = (NSArray *)[temp objectForKey:CLOUD_SUPPORT_CONFIGURATIONS];
            NSMutableArray *parseConfigFiles = [NSMutableArray arrayWithArray:configFiles];
#ifdef APPLY_CONFIG_FILE 
            NSString *additionalFiles = [NSString stringWithCString:APPLY_CONFIG_FILE encoding:NSUTF8StringEncoding];
            NSArray *additionalConfigFiles = [additionalFiles componentsSeparatedByString:@","];
            [parseConfigFiles addObjectsFromArray:additionalConfigFiles];        
#endif
            //[dictTemp addEntriesFromDictionary:temp];
            [Configuration parseConfigurationFiles:parseConfigFiles result:dictTemp];
		//change service name
            NSArray *allKeys = [[dictTemp allKeys] retain];
		for (NSString *key in allKeys)
		{
                id dirtyValue = [[dictTemp objectForKey:key] retain];
 
			if ([dirtyValue isKindOfClass:[NSString class]] && [Utility isString:@"${" isExistInString:(NSString *)dirtyValue])
			{
                    [dictTemp setValue:[Configuration makeCleanValue:dirtyValue in:dictTemp] forKey:key];
			}
			[dirtyValue release];
		}
		[allKeys release];
		
		//parse configuration of partner
            NSString *partnerId = [dictTemp objectForKey:PARTNER_ID_KEY];
		if (![partnerId isEqualToString:PARTNER_DEFAULT_NAME])
		{
			NSString *configurationPartner = [NSString stringWithFormat:@"%@_%@", CONFIGURATION_FILE_NAME, partnerId];
                [Configuration parseConfigurationFiles:[NSArray arrayWithObject:configurationPartner] result:dictTemp];
            }
		}
        configurationDict = dictTemp;
	}
    [pool drain];
}

+ (NSString *)getValueForKey:(NSString *)akey
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	return [configurationDict objectForKey:akey];
}

+ (NSArray *)getArrayForKey:(NSString *)akey
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	return (NSArray *)[configurationDict objectForKey:akey];
}

+ (void)setObject:(id)value forKey:(NSString *)key
{
	if (configurationDict != nil)
	{
		[configurationDict setObject:value forKey:key];
	}
	[Configuration saveData:value forKey:key];
}

+ (BOOL)isSupportedPersonalization
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
//	if ([[UserManager getInstance].currentUser isGuest])
//	{
//		NSNumber *supportIcon  = [configurationDict objectForKey:CLOUD_SUPPORT_ICONPERSONALIZATION_GUEST_KEY];
//		return [supportIcon boolValue];
//	}
	return TRUE;
}

+ (NSString *)getResouceDLNAForContentFormat:(NSString *)contentFormat
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	NSDictionary *supportDLNA  = [configurationDict objectForKey:CLOUD_RESOURCE_DLNA_SUPPORT_SPECIALDEVICE_KEY];
	if (supportDLNA)
	{
		return [supportDLNA objectForKey:contentFormat];
	}
	return nil;
}

+ (BOOL)applicationSupportAd
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	
	if ([configurationDict objectForKey:@"app.ad.support"] != nil)
	{
		return [[configurationDict objectForKey:@"app.ad.support"] boolValue];
	}
	return NO;
}

+ (BOOL)isSupportedFeature:(NSString *)keyFeature
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	
	if ([configurationDict objectForKey:keyFeature] != nil)
	{
		return [[configurationDict objectForKey:keyFeature] boolValue];
	}
	return NO;
}

+ (NSInteger)getIntegerValueForKey:(NSString *)aKey
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	
	if ([configurationDict objectForKey:aKey] != nil)
	{
		return [[configurationDict objectForKey:aKey] intValue];
	}
	return -1;
}

+ (NSDictionary *)getDictionaryValueFromKey:(NSString *)aKey
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	
	if ([configurationDict objectForKey:aKey] != nil)
	{
		return [configurationDict objectForKey:aKey];
	}
	return nil;
}

+ (NSString *)getAdPublisherID
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}

	return [configurationDict objectForKey:@"app.ad.publisher.id"];
}

+ (BOOL)applyNewUIPlayPlug
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	
	return [[configurationDict objectForKey:@"app.ui.new.playplug"] boolValue];	
}


+ (NSInteger)getAllowedMediaListSize
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	
    return [[configurationDict objectForKey:@"maximum_size_media_list"] intValue];
}

+ (BOOL)isSupportMultiPlayer
{
	if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	
	return [[configurationDict objectForKey:@"eyec.support.multiplay.player"] boolValue];	
}

+ (NSString *)getCloudTopPickSourceId
{
    if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
    
	return [configurationDict objectForKey:@"cloud.source.toppick.id"];
}

+ (NSInteger)getLastLoginTimeout
{
    if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
	return [[configurationDict objectForKey:@"silentlogin_timeout"] intValue];
}

+ (BOOL)applicationSupportGZIPCommunication
{
    if (configurationDict == nil) {
        [Configuration readConfigurationFile];
    }
    return [[configurationDict objectForKey:@"cloud.support.protocol.gzip"] boolValue];
}

+ (BOOL)applicationSupportContainerThumbnail
{
    if (configurationDict == nil) {
        [Configuration readConfigurationFile];
    }
    return [[configurationDict objectForKey:@"app.support.containerthumbnail"] boolValue];
}

+ (BOOL)shouldApplyUserAgentForLogin
{
    if (configurationDict == nil) {
        [Configuration readConfigurationFile];
    }
    return [[configurationDict objectForKey:@"app.login.apply.useragent"] boolValue];
}
+ (NSString *)getUserAgentStringForLogin
{
    if (configurationDict == nil)
	{
		[Configuration readConfigurationFile];
	}
    
	return [configurationDict objectForKey:@"app.login.useragent"];
}
@end
