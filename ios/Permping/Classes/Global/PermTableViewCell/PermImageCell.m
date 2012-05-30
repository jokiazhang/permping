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

- (void)layoutSubviews {
    [super layoutSubviews];
    if (permImageView.image) {
        permImageView.frame = CGRectInset(self.bounds, 10, 0);
    } else {
        permImageView.frame = CGRectZero;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    permImageView.image = nil;
}

@end
