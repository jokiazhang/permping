//
//  Taglist_CloudResponse.m
//  Eyecon
//
//  Created by PhongLe on 8/26/10.
//  Copyright 2010 Appo CO., LTD. All rights reserved.
//

#import "Taglist_CloudResponse.h"
#import "Constants.h"

@implementation Taglist_CloudResponse
 
@synthesize httpCode;
@synthesize responseHeaders;
@synthesize parsingError;
@synthesize keepPureData; 
@synthesize pureResponseData;
- (void)dealloc
{
    self.responseHeaders = nil;
    self.pureResponseData = nil;
    self.parsingError = nil;
	[super dealloc];
}

- (id) init
{
    self = [super init];
	if(self)
	{ 
		self.parsingError = nil; 
		responseHeaders = [[NSMutableDictionary alloc] init];
	}
	return self;
}
 
- (BOOL)isHTTPSuccess
{
    return ((httpCode >= 200 && httpCode < 300)) ? YES : NO;
}
 
- (NSString *)getHTTPErrorMessage
{
    return [NSHTTPURLResponse localizedStringForStatusCode:self.httpCode];
}

#pragma mark - JSON Parsing methods
- (void) parserWithJson:(NSString *)jsonData
{
//	//jsonString is your downloaded string JSON Feed
//    NSDictionary *deserializedData = [jsonString objectFromJSONString];
//    
//    //Helpful snippet to log all the deserialized objects and their keys
//    //NSLog(@"%@", [deserializedData description]);
//    return deserializedData;
    return;
}



#pragma mark - XML Parsing methods
- (void) onStartElement:(NSString *)path name:(NSString *)name
{
	return;
}
- (void) onEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text
{
 	return;
}
- (void) onAttribute:(NSString *)path name:(NSString *)name value:(NSString *)value
{ 
    return;	   	
}
- (void)onParsingError:(NSError *)error
{
    self.parsingError = error;    
}
@end
