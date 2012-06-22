//
//  PermImageCell.m
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermImageCell.h"
#import "Utils.h"

@interface PermImageCell()
@property (nonatomic, retain) NSString *permUrl;
@end

@implementation PermImageCell
@synthesize delegate;
@synthesize permImageView, permUrl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *myContentView = self.contentView;
        permImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        permImageView.backgroundColor = [UIColor clearColor];
        [myContentView addSubview:permImageView];
        
        openPermUrlButton = [[UIButton alloc] initWithFrame:CGRectZero];
        openPermUrlButton.hidden = YES;
        openPermUrlButton.backgroundColor = [UIColor clearColor];
        [openPermUrlButton addTarget:self action:@selector(openPermUrlButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        [myContentView addSubview:openPermUrlButton];
    }
    return self;
}

- (void)dealloc {
    self.permUrl = nil;
    [openPermUrlButton release];
    [permImageView release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    permImageView.frame = self.bounds;
    if (permImageView.image) {
//        CGFloat width = permImageView.image.size.width;
//        if (width < 300) {
//            permImageView.frame = CGRectInset(self.bounds, 10 + (300-width)/2, 0);
//        } else {
//            permImageView.frame = CGRectInset(self.bounds, 10, 0);
//        }
        
        CGSize desiredSize = [Utils sizeWithImage:permImageView.image constrainedToSize:CGSizeMake(304, 304)];
        CGFloat width = desiredSize.width;//permImageView.image.size.width;
        if (width < 304) {
            permImageView.frame = CGRectInset(self.bounds, 8 + (304-width)/2, 0);
        } else {
            permImageView.frame = CGRectInset(self.bounds, 8, 0);
        }
        
        if (self.permUrl.length>0) {
            openPermUrlButton.hidden = NO;
            openPermUrlButton.frame = permImageView.frame;
        }
    } else {
        UIView *activity = [permImageView viewWithTag:TAG_ACTIVITY_INDICATOR];
        if (activity) {
            activity.center = permImageView.center;
        }
    }
}

- (void)setCellPermUrl:(NSString *)in_permUrl {
    self.permUrl = in_permUrl;
    if (permImageView.image && in_permUrl.length>0) {
        openPermUrlButton.hidden = NO;
    } else {
        openPermUrlButton.hidden = YES;
    }
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    permImageView.image = nil;
    [self setPermUrl:nil];
}

- (void)openPermUrlButtonDidTouch:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(openPermUrl:)]) {
        [delegate openPermUrl:permUrl];
    }
}

@end
