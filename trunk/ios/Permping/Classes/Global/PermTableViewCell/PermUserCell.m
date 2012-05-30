//
//  PermUserCell.m
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermUserCell.h"

@implementation PermUserCell
@synthesize avatarView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *myContentView = self.contentView;
        avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 34)];
        [myContentView addSubview:avatarView];
        
        self.detailTextLabel.textColor = [UIColor grayColor];
    }
    return self;
}

- (void)setCellWithAvartarURLString:(NSString *)urlString userName:(NSString *)userName category:(NSString *)category {
    [avatarView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"user-img.png"]];
    self.textLabel.text = userName;
    self.detailTextLabel.text = category;
}

- (void)dealloc {
    [avatarView release];
    [super dealloc];
}

@end
