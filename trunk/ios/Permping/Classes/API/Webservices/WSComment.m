//
//  WSComment.m
//  Permping
//
//  Created by MAC on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSComment.h"

@implementation WSComment
@synthesize userId, userName, userAvatar, content;

- (void)dealloc {
    [content release];
    [userAvatar release];
    [userName release];
    [userId release];
    [super dealloc];
}

- (id)initWithXmlElement:(TBXMLElement *)in_xmlElement {
    if (self = [super initWithXmlElement:in_xmlElement]) {
        self.userId = [TBXML textForElement:[TBXML childElementNamed:@"userId" parentElement:in_xmlElement]];
        self.userName = [TBXML textForElement:[TBXML childElementNamed:@"userName" parentElement:in_xmlElement]];
        self.userAvatar = [TBXML textForElement:[TBXML childElementNamed:@"userAvatar" parentElement:in_xmlElement]];
        self.content = [TBXML textForElement:[TBXML childElementNamed:@"content" parentElement:in_xmlElement]];
    }
    return self;
}
@end
