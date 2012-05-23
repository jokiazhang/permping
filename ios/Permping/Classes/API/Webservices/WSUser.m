//
//  WSUser.m
//  Permping
//
//  Created by Andrew Duck on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSUser.h"

#define kUserElements @"userId;userName;status;userAvatar"

typedef enum {
    kUserElementId = 0,
    kUserElementName,
    kUserElementStatus,
    kUserElementAvatar,
} kUserElement;

@implementation WSUser
@synthesize userId, userName, userAvatar, userStatus;

- (void)dealloc {
    [userAvatar release];
    [userName release];
    [userId release];
    [userStatus release];
    [super dealloc];
}

-(id)initWithXmlElement:(CXMLElement*)in_xmlElement {
    if (self = [super initWithXmlElement:in_xmlElement]) {
        NSArray *lc_elements = [kUserElements componentsSeparatedByString:@";"];
        CXMLNode  *lc_child = [in_xmlElement childAtIndex:0];
        while (lc_child) {
            if ([lc_child isKindOfClass:[CXMLElement class]]) {
                int lc_index = [lc_elements indexOfObject:[lc_child name]];
                switch (lc_index) {
                    case kUserElementId:
                        self.userId = [lc_child stringValue];
                        break;
                    case kUserElementName:
                        self.userName = [lc_child stringValue];
                        break;
                    case kUserElementStatus:
                        self.userStatus = [lc_child stringValue];
                        break;
                    case kUserElementAvatar:
                        self.userAvatar = [lc_child stringValue];
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

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self = [self init]) {
        if (dict) {
            self.userId = [dict valueForKey:@"userId"];
            self.userName = [dict valueForKey:@"userName"];
            self.userAvatar = [dict valueForKey:@"userAvatar"];
        }
	}
	return self;
}

- (NSDictionary*)dictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:userId forKey:@"userId"];
    [dict setValue:userName forKey:@"userName"];
    [dict setValue:userAvatar forKey:@"userAvatar"];
    return dict;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"userId: %@,\nuserName: %@,\nstatus:%@,\nuserAvatar:%@",userId, userName, userStatus, userAvatar];
}

@end
