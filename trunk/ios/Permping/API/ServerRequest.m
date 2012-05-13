//
//  ServerRequest.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerRequest.h"
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

-(id)handleXMLResponse:(TBXMLElement *)in_xmlElement error:(NSError **)out_error{
	return @"Must be overided in subclasses";
}

- (void)checkXmlForError:(TBXMLElement *)in_xmlElement error:(NSError **)out_error {
}

-(void)handleDataResponse:(NSData *)in_data {
	NSString *xml = [[NSString alloc] initWithData:in_data encoding:NSUTF8StringEncoding];
	NSLog(@"%@", xml);
	[xml release];
	
    // TODO
}

#pragma mark URL

-(NSString *)urlComplete{
    // TODO
    return nil;
}

#pragma mark Request

-(NSURLRequest *)urlRequest{
    // TODO
    return nil;
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
		connection = [[NSURLConnection alloc] initWithRequest:[self urlRequest] delegate:self];
		if(!connection){
			[self connection:nil didFailWithError:[NSError errorWithDomain:ServerRequestErrorDomain code:ServerRequestErrorConnectionNotEstablished userInfo:nil]];
		}
	}
}


@end
