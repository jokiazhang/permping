//
//  WSError.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSError.h"

@implementation WSError
@synthesize code, message;

- (void)dealloc {
	[code release];
	[message release];
	[super dealloc];
}

-(id)initWithXmlElement:(TBXMLElement*)in_xmlElement{
	if (self = [super initWithXmlElement:in_xmlElement]) {
		// TODO
	}
	return self;
}

- (NSError*)error {
	NSString *domain = self.message;
	if (!domain) domain = @"Unknown";
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self forKey:@"wserror"];
	return [NSError errorWithDomain:domain code:[self.code intValue] userInfo:userInfo];
}

@end
