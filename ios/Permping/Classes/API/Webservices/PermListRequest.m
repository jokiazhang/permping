//
//  PermListRequest.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermListRequest.h"
#import "WSPerm.h"

@implementation PermListRequest

- (void)dealloc {
    [accessToken release];
    [super dealloc];
}

- (id)initWithToken:(NSString*)in_token {
    self = [super init];
    if (self) {
        accessToken = [in_token retain];
    }
    return self;
}

- (id)handleXMLResponse:(TBXMLElement *)in_xmlElement error:(NSError **)out_error {
   if (in_xmlElement) {
       NSMutableArray *perms = [NSMutableArray array];
       TBXMLElement *child = in_xmlElement->firstChild;
       NSLog(@"[TBXML elementName:child]: %@", [TBXML elementName:child]);
       do {
           if ([[TBXML elementName:child] isEqualToString:@"popularPerms"]) {
                TBXMLElement *item = child->firstChild;
                while (item) {
                    WSPerm *perm = [[WSPerm alloc] initWithXmlElement:item];
                    [perms addObject:perm];
                    [perm release];
                    item = item->nextSibling;
                }
            }
       } while ((child = child->nextSibling));
       return perms;
    }
    return nil;
}

@end
