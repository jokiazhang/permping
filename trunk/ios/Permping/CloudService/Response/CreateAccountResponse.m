//
//  CreateAccountResponse.m
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateAccountResponse.h"

@interface CreateAccountResponse()
@property (nonatomic, retain) NSMutableArray     *boardList;
@property (nonatomic, retain) BoardModel         *currentBoard;
@property (nonatomic, retain) UserProfileModel   *currentUser;
@end

@implementation CreateAccountResponse
@synthesize boardList;
@synthesize currentBoard;
@synthesize currentUser;

- (void)dealloc {
    self.boardList = nil;
    self.currentBoard = nil;
    self.currentUser = nil;
    [super dealloc];
}

- (UserProfileModel*)getUserProfile {
    return self.currentUser;
}

- (void) onStartElement:(NSString *)path name:(NSString *)name
{
    [super onStartElement:path name:name];
    
    if ([@"/response/user/boards/item" isEqualToString:path]) 
	{
		BoardModel *model = [[BoardModel alloc] init];
        self.currentBoard = model;
        [model release];
	} else if ([@"/response/user" isEqualToString:path]) {
        UserProfileModel *model = [[UserProfileModel alloc] init];
        self.currentUser = model;
        [model release];
    }
	return;
}

- (void)foundCDATA:(NSData *)CDATABlock onPath:(NSString *)path
{
    [super foundCDATA:CDATABlock onPath:path];
    
    if ([@"/response/user/boards/item/name" isEqualToString:path]) 
	{
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        if (self.currentBoard) {
            self.currentBoard.title = [[text copy] autorelease];
        }
        [text release];
	} else if ([@"/response/user/boards/item/description" isEqualToString:path]) {
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        if (self.currentBoard) {
            self.currentBoard.desc = [[text copy] autorelease];
        }
        [text release];
    } else if ([@"/response/user/userName" isEqualToString:path]) {
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        if (self.currentUser) {
            self.currentUser.userName = [[text copy] autorelease];
        }
        [text release];
    }
    return;
}

- (void) onEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text
{
    [super onEndElement:path name:name text:text];        
    //NSLog(@"onEndElement:%@ name:%@ text:\"%@\"", path, name, text);
	if ([@"/response/user/boards/item/id" isEqualToString:path]) 
	{
        if (self.currentBoard)
            self.currentBoard.boardId = [[text copy] autorelease];
	} else if ([@"/response/user/boards/item/followers" isEqualToString:path]) {
        if (self.currentBoard)
            self.currentBoard.followers = [[text copy] autorelease];
	} else if ([@"/response/user/boards/item/pins" isEqualToString:path]) {
        if (self.currentBoard)
            self.currentBoard.pinCount = [[text copy] autorelease];
	} else if ([@"/response/user/boards/item" isEqualToString:path]) {
        if (self.currentBoard) {
            if (!self.boardList) {
                NSMutableArray *array= [[NSMutableArray alloc] init];
                self.boardList = array;
                [array release];
            }
            [self.boardList addObject:self.currentBoard];
        }
    } else if ([@"/response/user/userId" isEqualToString:path]) {
        if (self.currentUser) {
            self.currentUser.userId = [[text copy] autorelease];
        }
    } else if ([@"/response/user/userAvatar" isEqualToString:path]) {
        if (self.currentUser) {
            self.currentUser.userAvatar = [[text copy] autorelease];
        }
    } else if ([@"/response/user/followingCount" isEqualToString:path]) {
        if (self.currentUser) {
            self.currentUser.followingCount = [[text copy] autorelease];
        }
    } else if ([@"/response/user/followerCount" isEqualToString:path]) {
        if (self.currentUser) {
            self.currentUser.followerCount = [[text copy] autorelease];
        }
    } else if ([@"/response/user/pinCount" isEqualToString:path]) {
        if (self.currentUser) {
            self.currentUser.pinCount = [[text copy] autorelease];
        }
    } else if ([@"/response/user/likeCount" isEqualToString:path]) {
        if (self.currentUser) {
            self.currentUser.likeCount = [[text copy] autorelease];
        }
    } else if ([@"/response/user/boardCount" isEqualToString:path]) {
        if (self.currentUser) {
            self.currentUser.boardCount = [[text copy] autorelease];
        }
    } else if ([@"/response/user/boards" isEqualToString:path]) {        
        if (self.currentUser) {
            if (!self.boardList) {
                NSMutableArray *array= [[NSMutableArray alloc] init];
                self.boardList = array;
                [array release];
            }
            self.currentUser.boards = self.boardList;
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
