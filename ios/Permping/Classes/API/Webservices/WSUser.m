//
//  WSUser.m
//  Permping
//
//  Created by Andrew Duck on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSUser.h"

@implementation WSUser
@synthesize userId, userName, userAvatar;

- (void)dealloc {
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
    }
    return self;
}
@end
