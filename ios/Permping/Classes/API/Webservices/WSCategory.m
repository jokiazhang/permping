//
//  WSCategory.m
//  Permping
//
//  Created by Andrew Duck on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSCategory.h"

#define kCategoryElements @"id;title"

typedef enum {
    kCategoryElementId = 0,
    kCategoryElementTitle
} kCategoryElement;

@implementation WSCategory
@synthesize categoryId, title;

- (id)initWithXmlElement:(CXMLElement *)in_xmlElement {
    if ((self = [super initWithXmlElement:in_xmlElement])) {
        NSArray *lc_elements = [kCategoryElements componentsSeparatedByString:@";"];
		CXMLNode  *lc_child = [in_xmlElement childAtIndex:0];
		while (lc_child) {
			if ([lc_child isKindOfClass:[CXMLElement class]]) {
				int lc_index = [lc_elements indexOfObject:[lc_child name]];
                switch (lc_index) {
                    case kCategoryElementId:
                        self.categoryId = [lc_child stringValue];
                        break;
                    case kCategoryElementTitle:
                        self.title = [lc_child stringValue];
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

- (void)dealloc {
    [categoryId release];
    [title release];
    [super dealloc];
}

@end
