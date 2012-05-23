//
//  RemoteObject.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface RemoteObject : NSObject

- (id)initWithXmlElement: (CXMLElement*)in_xmlElement;

- (id)initWithDictionary:(NSDictionary*)dict;

- (NSDictionary*)dictionary;

@end
