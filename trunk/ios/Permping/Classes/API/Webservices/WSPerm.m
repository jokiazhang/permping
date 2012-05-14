//
//  WSPerm.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSPerm.h"
#import "WSComment.h"

@implementation WSPerm
@synthesize permId, permName, permDesc, permImage, permComments;

- (void)dealloc {
    [permId release];
    [permName release];
    [permDesc release];
    [permImage release];
    [permComments release];
    [super dealloc];
}

- (id)initWithXmlElement:(TBXMLElement *)in_xmlElement {
    if (self = [super initWithXmlElement:in_xmlElement]) {
        
        self.permId = [TBXML textForElement:[TBXML childElementNamed:@"permId" parentElement:in_xmlElement]];
        self.permName = [TBXML textForElement:[TBXML childElementNamed:@"permName" parentElement:in_xmlElement]];
        self.permDesc = [TBXML textForElement:[TBXML childElementNamed:@"permDesc" parentElement:in_xmlElement]];
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
