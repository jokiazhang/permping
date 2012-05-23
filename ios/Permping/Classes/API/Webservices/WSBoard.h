//
//  WSBoard.h
//  Permping
//
//  Created by Andrew Duck on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteObject.h"

@interface WSBoard : RemoteObject {
    NSString    *boardId;
    NSString    *userId;
    NSString    *title;
    NSString    *categoryId;
    NSString    *desc;
    NSDate      *dateAdded;
    NSDate      *dateUpdated;
    NSString    *type;
    NSString    *friendId;
}

@property (nonatomic, retain) NSString    *boardId;
@property (nonatomic, retain) NSString    *userId;
@property (nonatomic, retain) NSString    *title;
@property (nonatomic, retain) NSString    *categoryId;
@property (nonatomic, retain) NSString    *desc;
@property (nonatomic, retain) NSDate      *dateAdded;
@property (nonatomic, retain) NSDate      *dateUpdated;
@property (nonatomic, retain) NSString    *type;
@property (nonatomic, retain) NSString    *friendId;

@end
