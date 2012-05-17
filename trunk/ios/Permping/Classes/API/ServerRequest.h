//
//  ServerRequest.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestResult.h"
#import "TBXML.h"

extern NSString * const ServerRequestErrorDomain;

enum ServerRequestErrors {
	ServerRequestErrorConnectionNotEstablished      = 1,
};
typedef enum ServerRequestErrors ServerRequestErrors;

@interface ServerRequest : NSObject {
	RequestResult *result;
	BOOL isUsingMethodPOST;
	
	id target;
	SEL action;
	NSURLConnection *connection;
	NSMutableData *data;
}

@property(nonatomic, retain) RequestResult *result;
@property(nonatomic, assign) BOOL isUsingMethodPOST;
@property(nonatomic, assign) id target;
@property(nonatomic, assign) SEL action;


-(void)handleDataResponse:(NSData *)in_data;
-(NSString *)urlComplete;
-(NSURLRequest *)urlRequest;

-(id)handleXMLResponse:(TBXMLElement *)in_xmlElement error:(NSError **)out_error;

-(void)startWithTarget:(id)in_target action:(SEL)in_action;


@end
