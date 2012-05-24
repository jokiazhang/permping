//
//  Configuration.h
//  Eyecon
//
//  Created by PhongLe on 9/6/10.
//  Copyright 2010 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Configuration : NSObject {

}

//+ (Configuration *)getInstance;
+ (NSString *)getValueForKey:(NSString *)akey;
+ (void)saveData:(id)value forKey:(NSString *)key;
+ (void)savePartnerId:(NSString *)partnerId;
+ (void)saveTempData:(id)value forKey:(NSString *)key;
+ (NSArray *)getArrayForKey:(NSString *)akey;
+ (void)setObject:(id)value forKey:(NSString *)key;
+ (BOOL)isSupportedPersonalization;
+ (NSString *)getResouceDLNAForContentFormat:(NSString *)contentFormat;
+ (NSDictionary *)getSupportedDeviceCategory;
+ (BOOL)isSupportedRecommendation;
+ (BOOL)isSupportedLocalLibrary;
+ (BOOL)isSupportedRovi;
+ (BOOL)isSupportedSharing;
+ (BOOL)isSupportedFeature:(NSString *)keyFeature;
 
+ (void)readConfigurationFile;
+ (NSInteger)getIntegerValueForKey:(NSString *)aKey;
+ (NSDictionary *)getDictionaryValueFromKey:(NSString *)aKey;
+ (void)parseConfigurationFiles:(NSArray *)configFiles result:(NSMutableDictionary *)retDict;
+ (BOOL)applicationSupportAd;
+ (NSString *)getAdPublisherID;
+ (BOOL)applyNewUIPlayPlug;
+ (NSInteger)getAllowedMediaListSize;
+ (BOOL)isSupportMultiPlayer;
+ (NSString *)getCloudTopPickSourceId;
+ (NSInteger)getLastLoginTimeout;
+ (BOOL)applicationSupportGZIPCommunication;
+ (BOOL)applicationSupportContainerThumbnail;

+ (BOOL)shouldApplyUserAgentForLogin;
+ (NSString *)getUserAgentStringForLogin;
@end
