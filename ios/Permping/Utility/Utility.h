//
//  Utility.h
//  Eyecon
//
//  Created by PhongLe on 7/7/10.
//  Copyright 2010 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomizedEnumType.h"

@class MediaItem, MediaResource, MediaObject, CloudUser, MediaDeviceModel;

@interface Utility : NSObject {
    
}
+ (NSString *)generateItemID:(NSString *)seedString;
+ (NSString *)getCurrentDateInYYYYMMDDFormat;
+ (BOOL)isNetworkAvailable;
+ (BOOL)isPoint:(CGPoint)point inRect:(CGRect)rect;

+ (BOOL)isString:(NSString *)des isExistInString:(NSString *)src;
+ (BOOL)isProtocol:(NSString *)protocol supportItem:(MediaItem *)item;
+ (BOOL)isPoint:(CGPoint)point inFrame:(CGRect)frame;

+ (BOOL)isHigherIPhone32;
+ (BOOL)isHigheriOS43;
+ (BOOL)isiOS5;
+ (BOOL)isOS4Device;
+ (float)convertDurationFromStringToFloat:(NSString *)duration;
+ (NSString *)convertElapsedTimeFromFloatToString:(float)elapse;
+ (NSString *)convertTimeFromFloatToString:(float)time;
+ (void)saveUsers:(NSString *)userList;
+ (NSData *)getUserList;
+ (NSString *)convertCharToString:(char *)chars;
+ (UIAlertView *)showAlertMessageWithTitle:(NSString *)title content:(NSString *)content delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

+ (NSString *)makeCleanXMLFile:(NSString *)aRoughString;
+ (NSString *)makeCleanXMLString:(NSString *)aRoughString;
+ (NSString *)predefineStringInXML:(NSString *)aRoughString;
+ (NSString *)encodeParameterStringForHTTPRequest:(NSString *)param;
+ (BOOL)isValidMediaURLString:(NSString *)urlString;
+ (NSString *)getAppBundleVersion;
+ (NSString *)getFileSize:(NSString *)fileName;
+ (NSString *)getStringFromDatetime:(NSDate *)date;
+ (NSDate *)getDateFromString:(NSString *)timestamp;
+ (BOOL)isURLWithFileExt:(NSString *)url;
+ (NSString *)trimString:(NSString *)str;
+ (NSString *)resolveUnicodeString:(NSString *)text;
+ (BOOL)isExistentConfigurationFile;

//+ (id) compressedDataWithData: (NSData*) data;
//+ (id) dataWithCompressedData: (NSData*) compressedData;
+ (NSString *)stringWithUTF8String:(char *)str;
//+ (MediaResource *)getMediaResourceForSharedItem:(MediaItem *)mediaItem onSource:(MediaDeviceModel *)sharedSourceModel errorCode:(int*)errorCode;

+ (void)ignoreInteractionEvents;
+ (void)endIgnoreInteractionEvents;

+ (void)startSpinnerWithText:(NSString *)txt parentView:(UIView *)parent;
+ (void)stopSpinner;
+ (UIColor *)colorRefWithString:(NSString *)colorString;
+ (NSString *)changeEyeconTemplateToRealConfig:(NSString *)text;
+ (CGRect)getSuitableRect:(CGRect)originalRect withSize:(CGSize)size;
+ (CGSize)getSuitableSizeFrom:(CGRect)originalRect withSize:(CGSize)size;
+ (NSString *)commaSeparatedListFromArray:(NSArray *)arrayObjs;
+ (NSString *)commaSeparatedListOfMediaType:(NSUInteger)mediaCat;
+ (NSData *)synchronizeDownloadFromUrl:(NSString *)strUrl;

+ (NSString *)buildTweetMessageForText:(NSString *)comment isTag:(BOOL)istag link:(NSString *)strLink;
+ (NSString *)getIPAddressFromSockAddress:(NSData *)sockAddress returnedPort:(int *)port;
+ (void)printRect:(CGRect)rect  extraString:(NSString *)str;
+ (NSString *)encodeURLString:(NSString *)aRoughString;
+ (NSString *)getUniqueDeviceIdentifier;
+ (NSString *)createUUID;
+ (NSString *)createKeyForIntegratedAlert:(NSString *)screen launchedcount:(int)launchedcount numpagevisited:(int)numpagevisited status:(BOOL)online;
+ (NSDictionary *)parseHttpURLQueryString:(NSString *)URL;
+ (NSString *)getIOSClientType;
+ (NSArray *)parseTaglistsInText:(NSString *)text;
+ (NSInteger)getIndexOfName:(NSString *)Id inIdentityList:(NSArray *)idList;
+ (NSString *)reverseString:(NSString *)string;
+ (NSString *)decimalToBase36:(NSString *)numberString;
+ (NSString *)base36ToDecimal:(NSString *)base36String;
+ (NSString *)array:(NSArray *)stringArray toStringWithSeparator:(NSString *)sep;
+ (int)countString:(NSString*)key inString:(NSString*)textToSearch;
+ (void)saveData:(NSString *)str toFileName:(NSString *)fileName;
+ (void)openAppStoreForEyeC;
+ (NSString*)getLastHashTag:(NSString*)text;
+ (NSString*)replaceLastHashTagInString:(NSString*)text byString:(NSString*)newText;
+ (NSString *)getMobileCarrierNetworkName;
+ (void)clearWebviewCache;
+ (BOOL)isNewLoggedInUser:(NSString *)strJoinDate;
+ (BOOL)isPattern:(NSString *)pattern match:(NSString *)str;
+ (NSString *)convertDoubleToDuration:(float) duration;
+ (NSDictionary *)getPlistFileContentAtPath:(NSString *)path;
+ (UIImage *)createStretchImage:(UIImage*)image withCap:(CUSTOMSEGMENT_CAPLOCATION)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth;
+ (UIButton *)createSegmentCtrlWithBgImage:(UIImage *)bgImage highlightImage:(UIImage *)highlightImage text:(NSString*)buttonText stretch:(CUSTOMSEGMENT_CAPLOCATION)location capWidth:(CGFloat)capWidth buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight;
+ (CGFloat)convertNanValue:(CGFloat)value;
+ (UIImage *)downloadImageWithURL:(NSString *)imageURL;
+ (UIImage *)convertImageToGrayScale:(UIImage *)image;
+ (NSString *)getExtImageType:(NSData *)data;

+ (NSArray *)extractSuitableImagesFromRawHTMLEntry:(NSString *)rawHTML;
+ (NSArray *)parseHtmlContent:(NSString *)htmlContent;
@end
