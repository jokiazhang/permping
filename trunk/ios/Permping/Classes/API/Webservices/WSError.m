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
	[message release];
	[super dealloc];
}

-(id)initWithXmlElement:(TBXMLElement*)in_xmlElement{
	if (self = [super initWithXmlElement:in_xmlElement]) {
		TBXMLElement *element = in_xmlElement->firstChild;
        do {
            if ([[TBXML elementName:element] isEqualToString:@"errorCode"]) {
                self.code = [[TBXML textForElement:[TBXML childElementNamed:@"errorCode" parentElement:element]] intValue];
            } else if ([[TBXML elementName:element] isEqualToString:@"errorMessage"]){
                self.message = [TBXML textForElement:[TBXML childElementNamed:@"errorMessage" parentElement:element]];
            }
        } while ((element = element->nextSibling));
	}
	return self;
}

- (NSError*)error {
	NSString *domain = self.message;
	if (!domain) domain = @"Unknown";
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self forKey:@"wserror"];
	return [NSError errorWithDomain:domain code:code userInfo:userInfo];
}

@end
