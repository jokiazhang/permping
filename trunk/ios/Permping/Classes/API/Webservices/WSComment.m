//
//  WSComment.m
//  Permping
//
//  Created by MAC on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSComment.h"
#import "WSUser.h"

@implementation WSComment
@synthesize user, content;

- (void)dealloc {
    [user release];
    [content release];
    [super dealloc];
}

- (id)initWithXmlElement:(TBXMLElement *)in_xmlElement {
    if (self = [super initWithXmlElement:in_xmlElement]) {
        self.user = [[[WSUser alloc] initWithXmlElement:[TBXML childElementNamed:@"user" parentElement:in_xmlElement]] autorelease];
        self.content = [TBXML textForElement:[TBXML childElementNamed:@"content" parentElement:in_xmlElement]];
    }
    return self;
}
@end
