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
#import "XMLReader.h"

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

-(id)handleXMLResponse:(TBXMLElement *)in_xmlElement error:(NSError **)out_error{
	return @"Must be overided in subclasses";
}

- (void)checkXmlForError:(TBXMLElement *)in_xmlElement error:(NSError **)out_error {
}

-(void)handleDataResponse:(NSData *)in_data {
    NSError *error = nil;
    
#if TARGET_IPHONE_SIMULATOR
    // Just for debug only
	NSString *xml = [[NSString alloc] initWithData:in_data encoding:NSUTF8StringEncoding];
	NSLog(@"xml %@", xml);
	[xml release];
#endif
    
    TBXML *document = [TBXML newTBXMLWithXMLData:data error:&error];
    RequestResult *requestResult = nil;
    if (!error) {
        id obj = [self handleXMLResponse:document.rootXMLElement error:&error];
        if (!error) {
            if (!obj) {
                RequestError *requestError = [[[RequestError alloc] init] autorelease];
                id errorFromXml = [requestError handleXMLResponse:document.rootXMLElement error:&error];
                if (errorFromXml) {
                    error = [(WSError*)errorFromXml error];
                }
            }
            if (!error) {
                requestResult = [RequestResult resultWithObject:obj];
            }
        }
    }
    
    if (error) {
        requestResult = [RequestResult resultWithError:error];
    }
    
    self.result = requestResult;
    
    if (requestResult) {
        [requestResult release];
    }
    
    [document release];
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
		return [self urlString];
	}
}


#pragma mark Request

-(NSURLRequest *)urlRequest{
    NSURL *url = [NSURL URLWithString:[self urlComplete]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	if(isUsingMethodPOST){
		[request setHTTPMethod:@"POST"];
		[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		NSString *lc_body = [self urlSpecificPart];
		[request addValue:[NSString stringWithFormat:@"%d", [lc_body length]] forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:[lc_body dataUsingEncoding:NSUTF8StringEncoding]];
	}
	[request setTimeoutInterval:SERVER_REQUEST_TIMEOUT_DEFAULT];
	return [request autorelease];
}

#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)in_connection didReceiveData:(NSData *)in_data{
	[data appendData:in_data];
}

- (void)connection:(NSURLConnection *)in_connection didReceiveResponse:(NSURLResponse *)response
{
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
        connection = [[NSURLConnectionFake alloc] initWithRequest:[self urlRequest] delegate:self];
#else
        connection = [[NSURLConnection alloc] initWithRequest:[self urlRequest] delegate:self];
#endif
		if(!connection){
			[self connection:nil didFailWithError:[NSError errorWithDomain:ServerRequestErrorDomain code:ServerRequestErrorConnectionNotEstablished userInfo:nil]];
		}
	}
}


@end
