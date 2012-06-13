//
//  SwitchingTableCell.m
//  Permping
//
//  Created by Andrew Duck on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SwitchingTableCell.h"

@implementation SwitchingTableCell
@synthesize switching;

- (void)dealloc {
    [switching release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        switching = [[UISwitch alloc] initWithFrame:CGRectMake(210, 8, 80, 27)];
        [self.contentView addSubview:switching];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
