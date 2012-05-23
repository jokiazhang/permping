//
//  WSBoard.m
//  Permping
//
//  Created by Andrew Duck on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSBoard.h"


#define kBoardElements @"id;user_id;title;category_id;desc;added_date;update_date;type;friend_id"

typedef enum {
	kBoardElementId = 0,
	kBoardElementUserId,
	kBoardElementTitle,
	kBoardElementCategoryId,
    kBoardElementDesc,
    kBoardElementDateAdded,
    kBoardElementDateUpdated,
    kBoardElementType,
    kBoardElementFriendId
} kBoardElement;

@implementation WSBoard
@synthesize boardId, userId, title, categoryId, desc, dateAdded, dateUpdated, type, friendId;

- (id)initWithXmlElement:(CXMLElement *)in_xmlElement {
    if ((self = [super initWithXmlElement:in_xmlElement])) {
        NSArray *lc_elements = [kBoardElements componentsSeparatedByString:@";"];
        CXMLNode  *lc_child = [in_xmlElement childAtIndex:0];
        while (lc_child) {
            if ([lc_child isKindOfClass:[CXMLElement class]]) {
                int lc_index = [lc_elements indexOfObject:[lc_child name]];
                switch (lc_index) {
                    case kBoardElementId:
                        self.boardId = [lc_child stringValue];
                        break;
                    case kBoardElementUserId:
                        self.userId = [lc_child stringValue];
                        break;

                    case kBoardElementTitle:
                        self.title = [lc_child stringValue];
                        break;

                    case kBoardElementCategoryId:
                        self.categoryId = [lc_child stringValue];
                        break;

                    case kBoardElementDateAdded:
                        //self.boardId = [lc_child stringValue];
                        break;

                    case kBoardElementDateUpdated:
                        //self.boardId = [lc_child stringValue];
                        break;

                    case kBoardElementType:
                        self.type = [lc_child stringValue];
                        break;
                    case kBoardElementFriendId:
                        self.friendId = [lc_child stringValue];
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
    [boardId release];
    [userId release];
    [title release];
    [categoryId release];
    [dateAdded release];
    [dateUpdated release];
    [type release];
    [friendId release];
    [super dealloc];
}

@end
