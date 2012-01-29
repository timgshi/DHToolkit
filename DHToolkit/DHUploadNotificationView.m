//
//  DHUploadNotificationView.m
//  DHToolkit
//
//  Created by Tim Shi on 1/29/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHUploadNotificationView.h"

@interface DHUploadNotificationView()
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation DHUploadNotificationView

@synthesize messageText;
@synthesize isLoading;
@synthesize messageLabel;
@synthesize spinner;

- (UILabel *)messageLabel
{
    if (!messageLabel) {
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 4, 290, 30)];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.text = messageText;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    }
    return messageLabel;
}

- (UIActivityIndicatorView *)spinner
{
    if (!spinner) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spinner.frame = CGRectMake(5, 10, 20, 20);
        spinner.hidesWhenStopped = YES;
    }
    return spinner;
}

- (void)setMessageText:(NSString *)aMessage
{
    messageText = aMessage;
    self.messageLabel.text = aMessage;
}

- (void)setIsLoading:(BOOL)loading
{
    isLoading = loading;
    if (isLoading) {
        [self.spinner startAnimating];
    } else {
        [self.spinner stopAnimating];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(DH_YELLOW_HEX_COLOR);
        self.alpha = 0.8;
        [self addSubview:self.messageLabel];
        [self addSubview:self.spinner];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
