//
//  RequestError.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestError.h"
#import "WSError.h"

@implementation RequestError
-(id)handleXMLResponse:(CXMLDocument *)in_document error:(NSError **)out_error{
    /*TBXMLElement *firstChild = in_document->firstChild;
    if (firstChild) {
        WSError *error = [[WSError alloc] initWithXmlElement:in_document];
        return [error autorelease];
    }*/
	return nil;
}
@end
