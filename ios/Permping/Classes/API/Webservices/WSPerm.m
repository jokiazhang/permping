//
//  WSPerm.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSPerm.h"
#import "WSUser.h"
#import "WSComment.h"

#define kPermElements @"permId;permDesc;permCategory;permImage;permComments;permRepinCount;permLikeCount;permCommentCount;user"

typedef enum {
	kPermElementPermId = 0,
	kPermElementDesc,
	kPermElementCategory,
	kPermElementImage,
    kPermElementComments,
    kPermElementRepinCount,
    kPermElementLikeCount,
    kPermElementCommentCount,
    kPermElementUser
} kPermElement;

@implementation WSPerm

@synthesize permUser, permId, permDesc, permCategory, permImage, permRepinCount, permLikeCount, permCommentCount, permComments;

- (void)dealloc {
    [permUser release];
    [permId release];
    [permDesc release];
    [permCategory release];
    [permImage release];
    [permRepinCount release];
    [permLikeCount release];
    [permCommentCount release];
    [permComments release];
    [super dealloc];
}

- (id)initWithXmlElement:(CXMLElement *)in_xmlElement {
    if (self = [super initWithXmlElement:in_xmlElement]) {
        NSArray *lc_elements = [kPermElements componentsSeparatedByString:@";"];
        CXMLNode  *lc_child = [in_xmlElement childAtIndex:0];
        while (lc_child) {
            if ([lc_child isKindOfClass:[CXMLElement class]]) {
                int lc_index = [lc_elements indexOfObject:[lc_child name]];
                switch (lc_index) {
                    case kPermElementPermId:
                        self.permId = [lc_child stringValue];
                        break;
                    case kPermElementDesc:
                        self.permDesc = [lc_child stringValue];
                        break;
                    case kPermElementCategory:
                        self.permCategory = [lc_child stringValue];
                        break;
                    case kPermElementImage:
                        self.permImage = [lc_child stringValue];
                        break;
                    case kPermElementComments:
                    {
                        NSArray *lc_commentsXML = [(CXMLElement*)lc_child elementsForName:@"comment"];
                        NSMutableArray *lc_comments = [[NSMutableArray alloc] init];
                        for(CXMLElement *lc_commentXML in lc_commentsXML){
							WSComment *lc_comment = [[WSComment alloc] initWithXmlElement:lc_commentXML];
							[lc_comments addObject:lc_comment];
							[lc_comment release];
						}
						self.permComments = lc_comments;
						[lc_comments release];
                    }
                        break;
                    case kPermElementRepinCount:
                        self.permRepinCount = [lc_child stringValue];
                        break;
                    case kPermElementLikeCount:
                        self.permLikeCount = [lc_child stringValue];
                        break;
                    case kPermElementCommentCount:
                        self.permCommentCount = [lc_child stringValue];
                        break;
                    case kPermElementUser:
                        
                        break;
                        
                    default:
                        break;
                }
                
            }
            lc_child = [lc_child nextSibling];
        }
	}
    //NSLog(@"perm: %@", self);
	return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"permId: %@,\npermDesc: %@,\npermCategory: %@,\npermImage: %@,\npermComments: %@,\npermRepinCount: %@,\npermLikeCount: %@,\npermCommentCount: %@,\nuser: %@", permId, permDesc, permCategory, permImage, permComments, permRepinCount, permLikeCount, permCommentCount, permUser];
}

@end
