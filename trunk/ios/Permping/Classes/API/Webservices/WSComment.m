//
//  WSComment.m
//  Permping
//
//  Created by MAC on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSComment.h"
#import "WSUser.h"

#define kCommentElements @"user;content"

typedef enum {
    kCommentElementUser = 0,
    kCommentElementContent
} kCommentElement;

@implementation WSComment
@synthesize user, content;

- (void)dealloc {
    [user release];
    [content release];
    [super dealloc];
}

-(id)initWithXmlElement:(CXMLElement*)in_xmlElement {
    if (self = [super initWithXmlElement:in_xmlElement]) {
        NSArray *lc_elements = [kCommentElements componentsSeparatedByString:@";"];
        CXMLNode  *lc_child = [in_xmlElement childAtIndex:0];
        while (lc_child) {
            //NSLog(@"lc_child class : %@", [lc_child class]);
            if ([lc_child isKindOfClass:[CXMLElement class]]) {
                int lc_index = [lc_elements indexOfObject:[lc_child name]];
                switch (lc_index) {
                    case kCommentElementUser:
                    {
                        WSUser *lc_user = [[WSUser alloc] initWithXmlElement:(CXMLElement*)lc_child];
                        self.user = lc_user;
                        [lc_user release];
                    }
                        break;
                    case kCommentElementContent:
                        self.content = [lc_child stringValue];
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

- (NSString*)description {
    return [NSString stringWithFormat:@"user: %@,\ncontent: %@", user, content];
}

@end
