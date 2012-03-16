//
//  DHEditingSettingCell.m
//  DHToolkit
//
//  Created by Tim Shi on 3/15/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHEditingSettingCell.h"

@interface DHEditingSettingCell () <UITextFieldDelegate>

@end

@implementation DHEditingSettingCell

@synthesize editingField;

- (UITextField *)editingField
{
    if (!editingField) {
        CGRect frame = self.contentView.frame;
        NSLog(@"%@", NSStringFromCGRect(frame));
        editingField = [[UITextField alloc] initWithFrame:CGRectMake(122, frame.origin.y + 9, 185, frame.size.height)];
        editingField.textAlignment = UITextAlignmentRight;
        editingField.textColor = [UIColor whiteColor];
        editingField.delegate = self;
    }
    return editingField;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
        [self.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
        [self.textLabel setTextColor:[UIColor whiteColor]];
        [self.detailTextLabel setTextColor:[UIColor whiteColor]];   
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self addSubview:self.editingField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView addSubview:self.editingField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return YES;
}

@end
