//
//  RequestError.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteObject.h"
#import "TBXML.h"

@interface RequestError : RemoteObject

-(id)handleXMLResponse:(TBXMLElement *)in_xmlElement error:(NSError **)out_error;

@end
