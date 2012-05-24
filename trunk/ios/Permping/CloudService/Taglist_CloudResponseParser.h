//
//  Taglist_CloudResponseParser.h
//  Eyecon
//
//  Created by PhongLe on 8/27/10.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudResponseProtocol.h"

@interface Taglist_CloudResponseParser : NSObject <NSXMLParserDelegate>{
	NSMutableArray				*parseStack;
	NSMutableString				*builder;
	id<Taglist_CloudResponseProtocol>	responseDelegate;
}
 
- (void)parseCloudResponse:(NSData *)response withDelegate:(id<Taglist_CloudResponseProtocol>)delegate;

@end
