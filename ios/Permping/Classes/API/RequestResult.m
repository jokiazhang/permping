//
//  RequestResult.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestResult.h"
#import "WSError.h"

@implementation RequestResult

@synthesize object, error;

+(id)resultWithObject:(id)in_object{
	return [[[RequestResult alloc] initWithObject:in_object] autorelease];
}

+(id)resultWithError:(id)in_error{
	return [[[RequestResult alloc] initWithError:in_error] autorelease];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.object = nil;
		self.error = nil;
	}
	return self;
}

-(id)initWithObject:(id)in_object{
	self = [self init];
	if (self != nil) {
		self.object = in_object;
	}
	return self;
}

-(id)initWithError:(id)in_error{
	self = [self init];
	if (self != nil) {
		self.error = in_error;
		
		// TODO
	}
	return self;
}

- (void) dealloc
{
	[object release];
	[error release];
	[super dealloc];
}

-(BOOL)hasError{
	return error != nil;
}




@end
