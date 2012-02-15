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

#define CELL_TEXT_PADDING 10
#define CELL_DEFAULT_HEIGHT 40

+ (CGFloat)messageLabelFrameHeightForComment:(PFObject *)commentObject
{
    NSString *name = [commentObject objectForKey:@"PFUsername"];
    NSString *message = [commentObject objectForKey:@"message"];
    if (!name || !message) {
        return 0;
    }
    CGSize nameSize = [name sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    CGFloat availableWidthForMessage = 320 - nameSize.width - 15;
    CGSize messageSize = [message sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14] constrainedToSize:CGSizeMake(availableWidthForMessage, 1000) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(messageSize.height, nameSize.height);
    return height;
}

+ (CGFloat)cellHeightForComment:(PFObject *)commentObject
{
    NSString *name = [commentObject objectForKey:@"PFUsername"];
    NSString *message = [commentObject objectForKey:@"message"];
    if (!name || !message) {
        return CELL_DEFAULT_HEIGHT;
    }
    return [DHCommentCell messageLabelFrameHeightForComment:commentObject] + 2 * CELL_TEXT_PADDING;
}



- (UILabel *)photographerNameLabel
{
    if (!photographerNameLabel) {
        photographerNameLabel = [[UILabel alloc] init];
        photographerNameLabel.frame = CGRectMake(5, 2, 320, 20);
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
    self.photographerNameLabel.frame = CGRectMake(5, 8, nameSize.width, nameSize.height);
//    if ([self.messageLabel.text sizeWithFont:[self.messageLabel font]].width > 320 - nameSize.width) {
//        self.messageLabel.frame = CGRectMake(self.photographerNameLabel.frame.origin.x + nameSize.width + 5, self.photographerNameLabel.frame.origin.y, 320 - nameSize.width, nameSize.height * 2);
//        [self.messageLabel setNumberOfLines:0];
//    } else {
//        self.messageLabel.frame = CGRectMake(self.photographerNameLabel.frame.origin.x + nameSize.width + 5, self.photographerNameLabel.frame.origin.y, 320 - nameSize.width, nameSize.height);
//    }
    [self.messageLabel setNumberOfLines:0];
    self.messageLabel.frame = CGRectMake(self.photographerNameLabel.frame.origin.x + nameSize.width + 5, self.photographerNameLabel.frame.origin.y, 320 - nameSize.width - 15, [DHCommentCell messageLabelFrameHeightForComment:commentObject]);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
