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
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    avatarView.frame = CGRectMake(10, 5, 34, 34);
    CGFloat maxW = 250;
    [self.textLabel sizeToFit];
    [self.detailTextLabel sizeToFit];
    CGRect tr = self.textLabel.frame;
    CGRect dr = self.detailTextLabel.frame;
    
    if (tr.size.width + dr.size.width > maxW) {
        dr.size.width = maxW - tr.size.width;
        if (dr.size.width < 50) {
            dr.size.width = 50;
            tr.size.width = maxW - 50;
        }
    }
    tr.origin.x = 50;
    dr.origin.x = 300 - dr.size.width;
    tr.origin.y = dr.origin.y = 10;
    self.textLabel.frame = tr;
    self.detailTextLabel.frame = dr;
}

- (void)setCellWithAvartarURLString:(NSString *)urlString userName:(NSString *)userName category:(NSString *)category {
    [avatarView setImageWithURL:[NSURL URLWithString:urlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.textLabel.text = userName;
    self.detailTextLabel.text = category;
}

- (void)dealloc {
    [avatarView release];
    [super dealloc];
}

@end
