//
// Copyright 2011 Kakao Corp. All rights reserved.
// @author kakaolink@kakao.com
// @version 2.0
//
#import "KakaoLinkCenter.h"
//#import <YAJLiOS/YAJL.h>
#import "JSONKit.h"

static NSString *StringByAddingPercentEscapesForURLArgument(NSString *string) {
	NSString *escapedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																				  (CFStringRef)string,
																				  NULL,
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8);
	return [escapedString autorelease];
}

static NSString *HTTPArgumentsStringForParameters(NSDictionary *parameters) {
	NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:[parameters count]];
	for (NSString *key in parameters) {
		NSString *parameter = [NSString stringWithFormat:@"%@=%@",
							   StringByAddingPercentEscapesForURLArgument(key),
							   StringByAddingPercentEscapesForURLArgument([parameters objectForKey:key])];
		[arguments addObject:parameter];
	}
	
	NSString *argumentsString = [arguments componentsJoinedByString:@"&"];
	return argumentsString;
}

static KakaoLinkCenter *sharedCenter = nil;
static NSString *const KakaoLinkApiVerstion = @"2.0";
static NSString *const KakaoLinkURLBaseString = @"kakaolink://sendurl";


@implementation KakaoLinkCenter

+ (void)initialize {
	@synchronized(self) {
		static BOOL isInitialized = NO;
		if (!isInitialized) {
			sharedCenter = [[KakaoLinkCenter alloc] init];
		}
	}
}

- (void)dealloc {
	[super dealloc];
}

- (id)init {
	if ((self = [super init])) {
	}
	return self;
}

+ (KakaoLinkCenter *)defaultCenter {
	return sharedCenter;
}


#pragma mark -

- (BOOL)canOpenKakaoLink {
	NSURL *kakaoLinkTestURL = [NSURL URLWithString:KakaoLinkURLBaseString];
	return [[UIApplication sharedApplication] canOpenURL:kakaoLinkTestURL];
}

- (NSString *)kakaoLinkURLStringForParameters:(NSDictionary *)parameters {
	NSString *argumentsString = HTTPArgumentsStringForParameters(parameters);
	NSString *URLString = [NSString stringWithFormat:@"%@?%@", KakaoLinkURLBaseString, argumentsString];
	return URLString;
}

- (BOOL)openKakaoLinkWithURL:(NSString *)referenceURLString
				  appVersion:(NSString *)appVersion
				 appBundleID:(NSString *)appBundleID 
					appName:(NSString *)appName 
					 message:(NSString *)message {
	if (!referenceURLString || !message || !appVersion || !appBundleID ||!appName) 
		return NO;
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:4];
	[parameters setObject:referenceURLString forKey:@"url"];
	[parameters setObject:message forKey:@"msg"];
	[parameters setObject:appVersion forKey:@"appver"];
	[parameters setObject:appBundleID forKey:@"appid"];
	[parameters setObject:appName forKey:@"appname"];
	
	[parameters setObject:KakaoLinkApiVerstion forKey:@"apiver"];
	[parameters setObject:@"link" forKey:@"type"];
	return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self kakaoLinkURLStringForParameters:parameters]]];
}


- (BOOL)openKakaoAppLinkWithMessage:(NSString *)message
								URL:(NSString *)referenceURLString
						appBundleID:(NSString *)appBundleID
						 appVersion:(NSString *)appVersion
							appName:(NSString *)appName
					  metaInfoArray:(NSArray *)metaInfoArray {
	
	BOOL avalibleAppLink = !message || !appVersion || !appBundleID || !appName || !metaInfoArray || [metaInfoArray count] > 0;
	if (!avalibleAppLink)
		return NO;

	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:7];
	[parameters setObject:message forKey:@"msg"];	
	[parameters setObject:appVersion forKey:@"appver"];
	[parameters setObject:appBundleID forKey:@"appid"];
	[parameters setObject:appName forKey:@"appname"];
	NSDictionary *appDataDictionary = [NSDictionary dictionaryWithObject:metaInfoArray forKey:@"metainfo"];
	//[parameters setObject:[appDataDictionary yajl_JSONString] forKey:@"metainfo"];
    [parameters setObject:[appDataDictionary JSONString] forKey:@"metainfo"];
	if (referenceURLString) {
		[parameters setObject:referenceURLString forKey:@"url"];
	}
	
	[parameters setObject:@"app" forKey:@"type"];
	[parameters setObject:KakaoLinkApiVerstion forKey:@"apiver"];
	return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self kakaoLinkURLStringForParameters:parameters]]];
}
@end

