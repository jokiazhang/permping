//
//  ServerRequest.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerRequest.h"
#import "Constants.h"
#import "RequestError.h"
#import "WSError.h"

#ifdef USE_FAKE_CONNECTION
#import "NSURLConnectionFake.h"
#endif

NSString * const ServerRequestErrorDomain = @"ServerRequestErrorDomain";

@implementation ServerRequest
@synthesize result;
@synthesize isUsingMethodPOST;
@synthesize target;
@synthesize action;

-(id)init{
	self = [super init];
	if (self != nil) {
		self.isUsingMethodPOST = NO;
		connection = nil;
		data = [[NSMutableData alloc] init];
	}
	return self;
}

- (void) dealloc{
	[data release];
	[super dealloc];
}


#pragma mark Response

-(id)handleXMLResponse:(CXMLDocument *)in_document error:(NSError **)out_error{
	return @"Must be overided in subclasses";
}

- (void)checkXmlForError:(CXMLDocument *)in_document error:(NSError **)out_error {
}

-(void)handleDataResponse:(NSData *)in_data {
    NSError *lc_error = nil;
    
#if TARGET_IPHONE_SIMULATOR
    // Just for debug only
	NSString *xml = [[NSString alloc] initWithData:in_data encoding:NSUTF8StringEncoding];
    //NSLog(@"xml %@", xml);
	[xml release];
#endif
    
    CXMLDocument *lc_document = [[CXMLDocument alloc] initWithData:in_data options:0 error:&lc_error];
    
    RequestResult *lc_result = nil;
    if (!lc_error) {
		id lc_obj = [self handleXMLResponse:lc_document error:&lc_error];
		
		if (!lc_error) {
			if (!lc_obj) {
				RequestError *lc_requestError = [[[RequestError alloc] init] autorelease];
				id lc_errorFromXml = [lc_requestError handleXMLResponse:lc_document error:&lc_error];
				if (lc_errorFromXml) {
					lc_error = [(WSError*)lc_errorFromXml error];
				}
			}
			
			if (!lc_error) {
				lc_result = [RequestResult resultWithObject:lc_obj];
			}
		}
	}
	
	if (lc_error) {
		lc_result = [RequestResult resultWithError:lc_error];
	}
    
	self.result = lc_result;

	if (lc_result) {
		[lc_result release];
	}
	
	[lc_document release];
}

#pragma mark URL
- (NSString *)urlString {
    return @"to be overrided and must not be called";
}

- (NSString *)urlSpecificPart {
    return @"to be overrided and must not be called";
}

- (NSString *)urlComplete {
    if(!self.isUsingMethodPOST){
		NSString *lc_str;
        lc_str = [NSString stringWithFormat:@"%@%@", [self urlString], [self urlSpecificPart]];
#if TARGET_IPHONE_SIMULATOR
		NSLog(@"lc_str : %@", lc_str);
#endif
		return lc_str;
	} else {
#if TARGET_IPHONE_SIMULATOR
		NSLog(@"lc_str : %@", [self urlString]);
#endif
		return [self urlString];
	}
}


#pragma mark Request

-(NSURLRequest *)urlRequest{
    NSURL *url = [NSURL URLWithString:[self urlComplete]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:SERVER_REQUEST_TIMEOUT_DEFAULT];
	if(isUsingMethodPOST){
		[request setHTTPMethod:@"POST"];
		[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		NSString *lc_body = [self urlSpecificPart];
		[request addValue:[NSString stringWithFormat:@"%d", [lc_body length]] forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:[lc_body dataUsingEncoding:NSUTF8StringEncoding]];
	}
    
	return [request autorelease];
}

#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)in_connection didReceiveData:(NSData *)in_data{
	[data appendData:in_data];
}

- (void)connection:(NSURLConnection *)in_connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;
    NSLog(@"response code : %d", httpRes.statusCode);
    NSLog(@"allHeaderFields: %@", httpRes.allHeaderFields);
    [data setLength:0];
}

- (void)connection:(NSURLConnection *)in_connection didFailWithError:(NSError *)in_error {
	RequestResult *lc_result = [RequestResult resultWithError:in_error];
	self.result = lc_result;
	[self.target performSelector:self.action withObject:self];
	[connection release];
	connection = nil;	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)in_connection{
	[self handleDataResponse:data];
	[self.target performSelector:self.action withObject:self];
	[connection release];
	connection = nil;
}

#pragma mark Connection

-(void)startWithTarget:(id)in_target action:(SEL)in_action{
	if(!connection){
		self.target = in_target;
		self.action = in_action;
#ifdef USE_FAKE_CONNECTION
        connection = [[[NSURLConnectionFake alloc] initWithRequest:[self urlRequest] delegate:self] retain];
#else
        connection = [[NSURLConnection alloc] initWithRequest:[self urlRequest] delegate:self];
#endif
		if(!connection){
			[self connection:nil didFailWithError:[NSError errorWithDomain:ServerRequestErrorDomain code:ServerRequestErrorConnectionNotEstablished userInfo:nil]];
		}
	}
}

@end
