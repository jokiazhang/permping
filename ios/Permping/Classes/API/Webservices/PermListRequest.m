//
//  PermListRequest.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermListRequest.h"
#import "WSPerm.h"
#import "Constants.h"

@implementation PermListRequest

- (void)dealloc {
    [userId release];
    [super dealloc];
}

- (id)initWithUserId:(NSString *)in_userId {
    self = [super init];
    if (self) {
        userId = [in_userId retain];
        isUsingMethodPOST = YES;
    }
    return self;
}

- (id)handleXMLResponse:(TBXMLElement *)in_xmlElement error:(NSError **)out_error {
   if (in_xmlElement) {
       NSMutableArray *perms = [NSMutableArray array];
       TBXMLElement *item = in_xmlElement->firstChild;
       do {
           WSPerm *perm = [[WSPerm alloc] initWithXmlElement:item];
           if (perm) {
               [perms addObject:perm];
               [perm release];
           }
       } while ((item = item->nextSibling));
       return perms;
    }
    return nil;
}

- (NSString*)urlString {
    return kPopularPermURLString;
}

- (NSString*)urlSpecificPart {
    if (userId) {
        NSMutableString *lc_str = [[[NSMutableString alloc] initWithString:@"userid="] autorelease];
        [lc_str appendString:userId];
        return lc_str;
    }
    return @"";
}

@end
