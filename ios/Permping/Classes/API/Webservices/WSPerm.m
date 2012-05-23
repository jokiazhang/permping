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

@implementation WSPerm
@synthesize owner, permId, permOwnerComment, permDesc, permCategory, permImage, permComments, permRepinCount, permLikeCount, permCommentCount, permStatus;

- (void)dealloc {
    [owner release];
    [permId release];
    [permOwnerComment release];
    [permDesc release];
    [permCategory release];
    [permImage release];
    [permRepinCount release];
    [permLikeCount release];
    [permCommentCount release];
    [permStatus release];
    [permComments release];
    [super dealloc];
}

- (id)initWithXmlElement:(TBXMLElement *)in_xmlElement {
    if (self = [super initWithXmlElement:in_xmlElement]) {
        TBXMLElement *userElement = [TBXML childElementNamed:@"user" parentElement:in_xmlElement];
        if (userElement) {
            self.owner = [[[WSUser alloc] initWithXmlElement:[TBXML childElementNamed:@"user" parentElement:in_xmlElement]] autorelease];
        }
        self.permId = [TBXML textForElement:[TBXML childElementNamed:@"permId" parentElement:in_xmlElement]];
        self.permOwnerComment = [TBXML textForElement:[TBXML childElementNamed:@"permOwnerComment" parentElement:in_xmlElement]];
        self.permDesc = [TBXML textForElement:[TBXML childElementNamed:@"permDesc" parentElement:in_xmlElement]];
        /*self.permLikeCount = [TBXML textForElement:[TBXML childElementNamed:@"permLikeCount" parentElement:in_xmlElement]];
        self.permCommentCount = [TBXML textForElement:[TBXML childElementNamed:@"permCommentCount" parentElement:in_xmlElement]];
        self.permRepinCount = [TBXML textForElement:[TBXML childElementNamed:@"permRepinCount" parentElement:in_xmlElement]];*/
        self.permCategory = [TBXML textForElement:[TBXML childElementNamed:@"permCategory" parentElement:in_xmlElement]];
        self.permImage = [TBXML textForElement:[TBXML childElementNamed:@"permImage" parentElement:in_xmlElement]];
		NSMutableArray *comments = [[NSMutableArray alloc] init];
        TBXMLElement *child = [TBXML childElementNamed:@"permComments" parentElement:in_xmlElement]->firstChild;
        while (child) {
            WSComment *comment = [[WSComment alloc] initWithXmlElement:child];
            if (comment) {
                [comments addObject:comment];
                [comment release];
            }
            child = child->nextSibling;
        }
        self.permComments = comments;
        [comments release];
	}
	return self;

}

/*- (NSString*)permStatus {
    return [NSString stringWithFormat:@"%@ Likes %@ Comments %@ Repins", self.permLikeCount, self.permCommentCount, self.permRepinCount];
}*/

@end
