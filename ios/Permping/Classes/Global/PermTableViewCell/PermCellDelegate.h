//
//  PermCellDelegate.h
//  Permping
//
//  Created by MAC on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PermInfoCell, PermUserCell;

@protocol PermCellDelegate <NSObject>

@optional
- (void)likePermAtCell:(PermInfoCell*)cell;
- (void)commentPermAtCell:(PermInfoCell*)cell;
- (void)repermPermAtCell:(PermInfoCell*)cell;
- (void)findLocationForPermAtCell:(PermInfoCell*)cell;

- (void)viewUserProfileWithId:(NSString*)userId;
@end
