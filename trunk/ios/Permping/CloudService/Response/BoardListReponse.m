//
//  BoardListReponse.m
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardListReponse.h"

@interface BoardListReponse()
@property (nonatomic, retain) NSMutableArray     *boardList;
@property (nonatomic, retain) BoardModel         *currentBoard;
@end

@implementation BoardListReponse
@synthesize boardList;
@synthesize currentBoard;

- (void)dealloc {
    self.currentBoard = nil;
    self.boardList = nil;
    [super dealloc];
}

- (NSArray *)getResponseBoardList
{
    if (self.boardList) {
        return [NSArray arrayWithArray:self.boardList];
    }
    return nil;
}

- (void) onStartElement:(NSString *)path name:(NSString *)name
{
    [super onStartElement:path name:name];
    
    if ([@"/response/boards/item" isEqualToString:path]) 
	{
		BoardModel *model = [[BoardModel alloc] init];
        self.currentBoard = model;
        [model release];
	}
	return;
}

- (void)foundCDATA:(NSData *)CDATABlock onPath:(NSString *)path
{
    if ([@"/response/boards/item/title" isEqualToString:path]) 
	{
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        if (self.currentBoard) {
            self.currentBoard.title = [[text copy] autorelease];
        }
        [text release];
	} else if ([@"/response/boards/item/desc" isEqualToString:path]) {
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        if (self.currentBoard) {
            self.currentBoard.desc = [[text copy] autorelease];
        }
        [text release];
    }
    return;
}


/*<response>
 <boards>
 <item>
 <id>530</id>
 <user_id>160</user_id>
 <title><![CDATA[내가  원하는 것들]]></title>
 <category_id>22</category_id>
 <desc><![CDATA[]]></desc>
 <added_date>0000-00-00 00:00:00</added_date>
 <updated_date>2012-05-07 11:38:17</updated_date>
 <type>me</type>
 <friend_id>0</friend_id>
 </item> */


- (void) onEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text
{
    [super onEndElement:path name:name text:text];        
    //NSLog(@"onEndElement:%@ name:%@ text:\"%@\"", path, name, text);
	if ([@"/response/boards/item/id" isEqualToString:path]) 
	{
        if (self.currentBoard)
            self.currentBoard.boardId = [[text copy] autorelease];
	} else if ([@"/response/boards/item/user_id" isEqualToString:path]) {
        if (self.currentBoard)
            self.currentBoard.userId = [[text copy] autorelease];
	} else if ([@"/response/boards/item/category_id" isEqualToString:path]) {
        if (self.currentBoard)
            self.currentBoard.categoryId = [[text copy] autorelease];
	} else if ([@"/response/boards/item/added_date" isEqualToString:path]) {
        if (self.currentBoard)
            self.currentBoard.dateAdded = [[text copy] autorelease];
	} else if ([@"/response/boards/item/updated_date" isEqualToString:path]) {
        if (self.currentBoard)
            self.currentBoard.dateUpdated = [[text copy] autorelease];
	} else if ([@"/response/boards/item/type" isEqualToString:path]) {
        if (self.currentBoard)
            self.currentBoard.type = [[text copy] autorelease];
	} else if ([@"/response/boards/item/friend_id" isEqualToString:path]) {
        if (self.currentBoard)
            self.currentBoard.friendId = [[text copy] autorelease];
	} else if ([@"/response/boards/item" isEqualToString:path]) {
        if (self.currentBoard) {
            if (!self.boardList) {
                NSMutableArray *array= [[NSMutableArray alloc] init];
                self.boardList = array;
                [array release];
            }
            [self.boardList addObject:self.currentBoard];
        }
    }
   	return;
}
- (void) onAttribute:(NSString *)path name:(NSString *)name value:(NSString *)value
{ 
    [super onAttribute:path name:name value:value];
    
    return;	   	
} 

- (void) onParsingError:(NSError *)error
{
    [super onParsingError:error];
    NSLog(@"ERRRRRO = %@",error.description);
}


@end
