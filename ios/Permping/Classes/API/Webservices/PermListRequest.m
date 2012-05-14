//
//  PermListRequest.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermListRequest.h"

@implementation PermListRequest

- (void)dealloc {
    [accessToken release];
    [super dealloc];
}

- (id)initWithToken:(NSString*)in_token {
    self = [super init];
    if (self) {
        accessToken = [in_token retain];
    }
    return self;
}

- (id)handleXMLResponse:(TBXMLElement *)in_xmlElement error:(NSError **)out_error {
    //TODO
    NSString *file = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/permList.xml"];
    NSError *error;
    TBXML *tbxml = [TBXML newTBXMLWithXMLFile:file error:&error];
    NSLog(@"tbxml %@, %@", tbxml, error);
    return nil;
}

@end
