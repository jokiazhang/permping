//
//  BoardListRequest.m
//  Permping
//
//  Created by Andrew Duck on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardListRequest.h"
#import "Constants.h"
#import "WSBoard.h"

@implementation BoardListRequest

- (void)dealloc {
    [categoryId release];
    [super dealloc];
}

- (id)initWithCategoryId:(NSString*)in_categoryId {
    if ((self = [super init])) {
        self.categoryId = in_categoryId;
    }
    return self;
}

-(id)handleXMLResponse:(CXMLDocument *)in_document error:(NSError **)out_error{
    NSArray *lc_boardsXml = [in_document nodesForXPath:@"/response/board" error:out_error];
    if (!*out_error) {
        if ([lc_boardsXml count] > 0) {
            NSMutableArray *lc_boards = [NSMutableArray array];
            for(CXMLElement *lc_element in lc_boardsXml) {
                WSBoard *lc_board = [[WSBoard alloc] initWithXmlElement:lc_element];
                [lc_boards addObject: lc_board];
                [lc_board release];
            }
            return lc_boards;
        }
    }
    return nil;
}

- (NSString*)urlString {
    return [SERVER_API stringByAppendingString:@"/permservice/getboardswithcategoryid/"];
}

- (NSString*)urlSpecificPart {
    return categoryId;
}

@end
