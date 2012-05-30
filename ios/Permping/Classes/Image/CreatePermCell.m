//
//  CreatePermCell.m
//  Permping
//
//  Created by Andrew Duck on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreatePermCell.h"

@implementation CreatePermCell

@synthesize valueTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        valueTextField = [[UITextField alloc] init];
        valueTextField.placeholder = @"Description of Image";
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
    valueTextField.frame = tr;
}

- (void)dealloc {
    [valueTextField release];
    [super dealloc];
}

@end
