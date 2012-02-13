//
//  DHCommentCell.m
//  DHToolkit
//
//  Created by Tim Shi on 2/13/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHCommentCell.h"

@interface DHCommentCell()
@property (nonatomic, strong) UILabel *photographerNameLabel, *messageLabel;
@end

@implementation DHCommentCell

@synthesize commentObject;
@synthesize photographerNameLabel, messageLabel;

- (UILabel *)photographerNameLabel
{
    if (!photographerNameLabel) {
        photographerNameLabel = [[UILabel alloc] init];
        photographerNameLabel.frame = CGRectMake(5, 0, 320, 20);
        [photographerNameLabel setBackgroundColor:[UIColor clearColor]];
        [photographerNameLabel setTextColor:UIColorFromRGB(DH_YELLOW_HEX_COLOR)];
        [photographerNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    }
    return photographerNameLabel;
}

- (UILabel *)messageLabel
{
    if (!messageLabel) {
        messageLabel = [[UILabel alloc] init];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [messageLabel setTextColor:[UIColor whiteColor]];
        [messageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
        [messageLabel setLineBreakMode:UILineBreakModeWordWrap];
    }
    return messageLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        UIImage *backgroundImage = [[UIImage imageNamed:@"BackgroundGradient.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        self.contentView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
//        self.contentView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.5];
        self.contentView.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0];
        [self.contentView addSubview:self.photographerNameLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)setCommentObject:(PFObject *)aCommentObject
{
    commentObject = aCommentObject;
    self.photographerNameLabel.text = [commentObject objectForKey:@"PFUsername"];
    self.messageLabel.text = [commentObject objectForKey:@"message"];
    CGSize nameSize = [self.photographerNameLabel.text sizeWithFont:[self.photographerNameLabel font]];
    self.photographerNameLabel.frame = CGRectMake(5, 5, nameSize.width, nameSize.height);
    if ([self.messageLabel.text sizeWithFont:[self.messageLabel font]].width > 320 - nameSize.width) {
        self.messageLabel.frame = CGRectMake(self.photographerNameLabel.frame.origin.x + nameSize.width + 5, self.photographerNameLabel.frame.origin.y, 320 - nameSize.width, nameSize.height * 2);
        [self.messageLabel setNumberOfLines:2];
    } else {
        self.messageLabel.frame = CGRectMake(self.photographerNameLabel.frame.origin.x + nameSize.width + 5, self.photographerNameLabel.frame.origin.y, 320 - nameSize.width, nameSize.height);
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
