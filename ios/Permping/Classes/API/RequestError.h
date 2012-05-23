//
//  RequestError.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteObject.h"
#import "TouchXML.h"

@interface RequestError : RemoteObject

-(id)handleXMLResponse:(CXMLDocument *)in_document error:(NSError **)out_error;

@end
