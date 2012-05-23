//
//  PermImageCell.m
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermImageCell.h"

@implementation PermImageCell
@synthesize permImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *myContentView = self.contentView;
        permImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [myContentView addSubview:permImageView];
    }
    return self;
}

- (void)dealloc {
    [permImageView release];
    [super dealloc];
}


@end
