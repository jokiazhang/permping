//
//  BoardViewController.h
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PermsViewController.h"
#import "BoardModel.h"

@interface BoardViewController : PermsViewController {
    BoardModel          *board;
}
@property (nonatomic, retain) BoardModel *board;
@end
