//
//  Taglist_CloudResponse.m
//  Eyecon
//
//  Created by PhongLe on 8/26/10.
//  Copyright 2010 Appo CO., LTD. All rights reserved.
//

#import "Taglist_CloudResponse.h"
#import "Constants.h"

@interface Taglist_CloudResponse () 
@property (nonatomic, retain)ErrorModel *errorModel;
@end

@implementation Taglist_CloudResponse
 
@synthesize httpCode;
@synthesize responseHeaders;
@synthesize parsingError;
@synthesize keepPureData; 
@synthesize pureResponseData;
@synthesize responseError;
@synthesize errorModel;

- (void)dealloc
{
    self.responseHeaders = nil;
    self.pureResponseData = nil;
    self.parsingError = nil;
    self.errorModel = nil;
	[super dealloc];
}

- (id) init
{
    self = [super init];
	if(self)
	{ 
		self.parsingError = nil; 
        self.errorModel = nil;
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

- (NSError*)responseError {
    if (self.errorModel) {
        NSLog(@"%@, %@", self.errorModel.code, self.errorModel.message);
        NSString *domain = self.errorModel.message;
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.errorModel.message forKey:NSLocalizedDescriptionKey];
        return [NSError errorWithDomain:domain code:[self.errorModel.code intValue] userInfo:userInfo];
    } else if (self.parsingError) {
        return self.parsingError;
    }
    return nil;
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
    if ([@"/respond/error" isEqualToString:path]) 
	{
        ErrorModel *model = [[ErrorModel alloc] init];
        self.errorModel = model;
        [model release];
	}
	return;
}
- (void)foundCDATA:(NSData *)CDATABlock onPath:(NSString *)path
{
    if ([@"/respond/error/message" isEqualToString:path]) 
	{
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        if (self.errorModel) {
            self.errorModel.message = [[text copy] autorelease];
        }
        [text release];
	} 
    return;
}
- (void) onEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text
{
    if ([@"/respond/error/errorcode" isEqualToString:path]) 
	{
        if (self.errorModel)
            self.errorModel.code = [[text copy] autorelease];
	}
 	return;
}
- (void) onAttribute:(NSString *)path name:(NSString *)name value:(NSString *)value
{ 
    return;	   	
}
- (void)onParsingError:(NSError *)error
{
    self.parsingError = error;
    self.errorModel = nil;
}
@end
