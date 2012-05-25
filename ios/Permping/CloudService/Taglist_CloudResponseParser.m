//
//  Taglist_CloudResponseParser.m
//  Eyecon
//
//  Created by PhongLe on 8/27/10.
//  Copyright 2010. All rights reserved.
//

#import "Taglist_CloudResponseParser.h"
#import "Constants.h"
#import "Logger.h"

@interface Taglist_CloudResponseParser()
- (NSString *)getCurentPath;

@end


@implementation Taglist_CloudResponseParser

- (void)dealloc
{
	[parseStack release];
	[builder release];
	[super dealloc];
}

- (id) init
{
    self = [super init];
	if(self)
	{
		parseStack = [[NSMutableArray alloc] init];
		builder = [[NSMutableString alloc] init];
 
	}
	return self;
}

- (void)parseCloudResponse:(NSData *)response withDelegate:(id<Taglist_CloudResponseProtocol>)delegate
{
	responseDelegate = delegate;
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData: response];
	[parser setDelegate:self];
	[parser parse];  
	[parser release];	

}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict 
{		 
    if (elementName == nil) {
        return;
    }
    
	[parseStack	insertObject:elementName atIndex:0];
	
	[responseDelegate onStartElement:[self getCurentPath] name:elementName];
	
	NSArray *allAttrib = [attributeDict allKeys];
	for(NSString *name in allAttrib)
	{
		NSString *val = [attributeDict valueForKey: name];
		[responseDelegate onAttribute:[[self getCurentPath] stringByAppendingFormat:@"/@%@", name] name:name value:val];
	}
	[builder setString: @""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)chars 
{ 
	if(builder)
		[builder appendString:chars];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{	
	[responseDelegate onEndElement:[self getCurentPath] name:elementName text:builder];
	[parseStack	removeObjectAtIndex: 0];
	[builder setString: @""];	
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    if ([responseDelegate respondsToSelector:@selector(foundCDATA:onPath:)]) {
        [responseDelegate foundCDATA:CDATABlock onPath:[self getCurentPath]];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
	[Logger logInfo:@"CloudResponseParser - parseErrorOccurred with status code %d", [parseError code]];
    if ([parseError code] != NSXMLParserNAMERequiredError) {
	[responseDelegate onParsingError:parseError];
	[Logger logError:@"%@ - Error while parsing cloud response:%@ reason:%@", NSStringFromClass([self class]), [parseError localizedDescription], [parseError localizedFailureReason]];
}
}

- (NSString *)getCurentPath
{
	NSMutableString *path = [NSMutableString stringWithCapacity: 128];
	NSInteger startCount = [parseStack count];
	for(NSInteger index = startCount - 1; index >= 0; index --)
	{
		NSString *stackEle = [parseStack objectAtIndex: index];
		[path appendString: @"/"];
		[path appendString: stackEle];
	}
	return path;
}
@end
