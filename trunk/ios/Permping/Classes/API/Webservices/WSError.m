//
//  WSError.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSError.h"

@implementation WSError

#define kErrorElements @"code;message"

typedef enum {
	kErrorElementCode = 0,
	kErrorElementMessage
} kErrorElement;

- (void)dealloc {
    [code release];
	[message release];
	[super dealloc];
}

-(id)initWithXmlElement:(CXMLElement*)in_xmlElement{
	if (self = [super initWithXmlElement:in_xmlElement]) {
		NSArray *lc_elements = [kErrorElements componentsSeparatedByString:@";"];
		CXMLNode  *lc_child = [in_xmlElement childAtIndex:0];
		while (lc_child) {
			if ([lc_child isKindOfClass:[CXMLElement class]]) {
				int lc_index = [lc_elements indexOfObject:[lc_child name]];
				if ([lc_child stringValue]!=nil)
					switch (lc_index) {
						case kErrorElementCode:
							self.code=[lc_child stringValue];
							break;
						case kErrorElementMessage:
							self.message=[lc_child stringValue];
							break;
						default:
							break;
					}
				
			}
			lc_child = [lc_child nextSibling];
		}
	}
	return self;
}

- (NSError*)error {
	NSString *lc_domain = self.message;
	if (!lc_domain) lc_domain = @"Unknown";
	NSDictionary *lc_userInfo = [NSDictionary dictionaryWithObject:self forKey:@"wserror"];
	return [NSError errorWithDomain:lc_domain code:[self.code intValue] userInfo:lc_userInfo];
}

@end
