//
//  BoardListRequest.h
//  Permping
//
//  Created by Andrew Duck on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerRequest.h"

@interface BoardListRequest : ServerRequest {
    NSString    *categoryId;
}

@property (nonatomic, retain)NSString *categoryId;

- (id)initWithCategoryId:(NSString*)in_categoryId;

@end
