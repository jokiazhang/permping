//
//  UserInfoTableViewCell.m
//  Permping
//
//  Created by MAC on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell
@synthesize valueTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        valueTextField = [[UITextField alloc] init];
        valueTextField.placeholder = NSLocalizedString(@"globals.required", nil);
        valueTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:valueTextField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    [self.textLabel sizeToFit];
    CGRect tr = self.textLabel.frame;
    tr.origin.x = CGRectGetMaxX(tr) + 15;
    tr.size.width = rect.size.width - tr.origin.x - 25;
    tr.size.height = 21;
    valueTextField.frame = tr;
}

- (void)dealloc {
    [valueTextField release];
    [super dealloc];
}

@end
