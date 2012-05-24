//
//  untitled.h
//  Eyecon
//
//  Created by PhongLe on 8/26/10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@protocol Taglist_CloudResponseProtocol <NSObject>
 
- (void) onStartElement:(NSString *)path name:(NSString *)name;
- (void) onEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text;
- (void) onAttribute:(NSString *)path name:(NSString *)name value:(NSString *)value;
- (void) onParsingError:(NSError *)error;

@optional
- (void)foundCDATA:(NSData *)CDATABlock onPath:(NSString *)path;

#pragma mark - JSON Parsing methods
- (void) parserWithJson:(NSString *)jsonData;
@end
