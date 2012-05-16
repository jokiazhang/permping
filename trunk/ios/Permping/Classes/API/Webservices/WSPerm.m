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
@synthesize owner, permId, permOwnerComment, permDesc, permStatus, permCategory, permImage, permComments;

- (void)dealloc {
    [owner release];
    [permId release];
    [permOwnerComment release];
    [permDesc release];
    [permStatus release];
    [permCategory release];
    [permImage release];
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
        self.permStatus = [TBXML textForElement:[TBXML childElementNamed:@"permStatus" parentElement:in_xmlElement]];
        self.permCategory = [TBXML textForElement:[TBXML childElementNamed:@"permCategory" parentElement:in_xmlElement]];
        self.permImage = [TBXML textForElement:[TBXML childElementNamed:@"permImage" parentElement:in_xmlElement]];

		NSMutableArray *comments = [[NSMutableArray alloc] init];
        TBXMLElement *child = [TBXML childElementNamed:@"permComments" parentElement:in_xmlElement]->firstChild;
        while (child) {
            WSComment *comment = [[WSComment alloc] initWithXmlElement:child];
            [comments addObject:comment];
            [comment release];
            
            child = child->nextSibling;
        }
        self.permComments = comments;
        [comments release];
	}
	return self;

}

@end
