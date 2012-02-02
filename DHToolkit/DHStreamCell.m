//
//  DHStreamCell.m
//  DHToolkit
//
//  Created by Tim Shi on 1/23/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHStreamCell.h"
#import "DHPhoto.h"

@interface DHStreamCell()
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *photographerNameLabel, *photoDescriptionLabel, *levelLabel, *weatherLabel, *locationLabel;
@property (nonatomic, strong) UIView *infoBarContainerView, *infoBarColoredContainer, *levelBarView, *contentContainerView;
@end

@implementation DHStreamCell
@synthesize cellImageView;
@synthesize contentContainerView;
@synthesize photographerNameLabel, photoDescriptionLabel, levelLabel, weatherLabel, locationLabel;
@synthesize infoBarContainerView, infoBarColoredContainer, levelBarView;
@synthesize spinner;
@synthesize PFObjectID;
@synthesize photoObject;
@synthesize cellPhoto;

- (UIImageView *)cellImageView
{
    if (!cellImageView) {
        cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, DH_CELL_HEIGHT)];
    }
    return cellImageView;
}

- (UILabel *)photographerNameLabel
{
    if (!photographerNameLabel) {
        photographerNameLabel = [[UILabel alloc] init];
        photographerNameLabel.frame = CGRectMake(5, 5, 320, 20);
        [photographerNameLabel setBackgroundColor:[UIColor clearColor]];
        [photographerNameLabel setTextColor:UIColorFromRGB(DH_YELLOW_HEX_COLOR)];
        [photographerNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [photographerNameLabel setShadowOffset:CGSizeMake(-1, 1)];
        [photographerNameLabel setShadowColor:[UIColor blackColor]];
    }
    return photographerNameLabel;
}

- (UILabel *)photoDescriptionLabel
{
    if (!photoDescriptionLabel) {
        photoDescriptionLabel = [[UILabel alloc] init];
        [photoDescriptionLabel setBackgroundColor:[UIColor clearColor]];
        [photoDescriptionLabel setTextColor:[UIColor whiteColor]];
        [photoDescriptionLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [photoDescriptionLabel setShadowOffset:CGSizeMake(-1, 1)];
        [photoDescriptionLabel setShadowColor:[UIColor blackColor]];
        [photoDescriptionLabel setLineBreakMode:UILineBreakModeWordWrap];
    }
    return photoDescriptionLabel;
}

- (UILabel *)levelLabel
{
    if (!levelLabel) {
        levelLabel = [[UILabel alloc] init];
        [levelLabel setBackgroundColor:[UIColor clearColor]];
        [levelLabel setTextColor:[UIColor whiteColor]];
        [levelLabel setFont:[UIFont boldSystemFontOfSize:34]];
        CGSize labelSize = [@"10" sizeWithFont:levelLabel.font];
        levelLabel.frame = CGRectMake(10, DH_CELL_INFO_BAR_HEIGHT - 22 - labelSize.height, labelSize.width, labelSize.height);
        [levelLabel setShadowOffset:CGSizeMake(-1, 1)];
        [levelLabel setShadowColor:[UIColor blackColor]];
    }
    return levelLabel;
}

- (UILabel *)weatherLabel
{
    if (!weatherLabel) {
        weatherLabel = [[UILabel alloc] init];
        weatherLabel.textAlignment = UITextAlignmentRight;
        [weatherLabel setBackgroundColor:[UIColor clearColor]];
        [weatherLabel setTextColor:[UIColor whiteColor]];
        [weatherLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        [weatherLabel setShadowOffset:CGSizeMake(-1, 1)];
        [weatherLabel setShadowColor:[UIColor blackColor]];
    }
    return weatherLabel;
}

- (UILabel *)locationLabel
{
    if (!locationLabel) {
        locationLabel = [[UILabel alloc] init];
        locationLabel.textAlignment = UITextAlignmentRight;
        [locationLabel setBackgroundColor:[UIColor clearColor]];
        [locationLabel setTextColor:[UIColor whiteColor]];
        [locationLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        [locationLabel setShadowOffset:CGSizeMake(-1, 1)];
        [locationLabel setShadowColor:[UIColor blackColor]];
    }
    return locationLabel;
}

- (UIView *)levelBarView
{
    if (!levelBarView) {
        levelBarView = [[UIView alloc] init];
        levelBarView.frame = CGRectMake(0, DH_CELL_INFO_BAR_HEIGHT - 19, 250, 10);
        [levelBarView setBackgroundColor:UIColorFromRGB(DH_YELLOW_HEX_COLOR)];
    }
    return levelBarView;
}

- (UIView *)infoBarContainerView
{
    if (!infoBarContainerView) {
        infoBarContainerView = [[UIView alloc] init];
        [infoBarContainerView setBackgroundColor:[UIColor clearColor]];
        infoBarContainerView.frame = CGRectMake(0, DH_CELL_HEIGHT - DH_CELL_INFO_BAR_HEIGHT, 320, DH_CELL_INFO_BAR_HEIGHT);
        [infoBarContainerView addSubview:self.levelLabel];
        [infoBarContainerView addSubview:self.weatherLabel];
        [infoBarContainerView addSubview:self.locationLabel];
        [infoBarContainerView addSubview:self.levelBarView];
    }
    return infoBarContainerView;
}

- (UIView *)infoBarColoredContainer
{
    if (!infoBarColoredContainer) {
        infoBarColoredContainer = [[UIView alloc] init];
        infoBarColoredContainer.frame = CGRectMake(0, DH_CELL_HEIGHT - DH_CELL_INFO_BAR_HEIGHT, 320, DH_CELL_INFO_BAR_HEIGHT);
        [infoBarColoredContainer setBackgroundColor:[UIColor blackColor]];
        infoBarColoredContainer.alpha = 0.4;
    }
    return infoBarColoredContainer;
}

- (UIActivityIndicatorView *)spinner
{
    if (!spinner) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setHidesWhenStopped:YES];
        spinner.frame = CGRectMake((320 / 2) - (spinner.frame.size.width / 2), 35, spinner.frame.size.width, spinner.frame.size.height);
    }
    return spinner;
}

- (UIView *)contentContainerView
{
    if (!contentContainerView) {
        contentContainerView = [[UIView alloc] init];
        [contentContainerView setClipsToBounds:YES];
        [contentContainerView setBackgroundColor:[UIColor blackColor]];
        contentContainerView.frame = CGRectMake(0, 0, 320, DH_CELL_HEIGHT);
        [contentContainerView addSubview:self.cellImageView];
        [contentContainerView addSubview:self.photographerNameLabel];
        [contentContainerView addSubview:self.photoDescriptionLabel];
        [contentContainerView addSubview:self.infoBarColoredContainer];
        [contentContainerView addSubview:self.infoBarContainerView];
        [contentContainerView addSubview:self.spinner];
    }
    return contentContainerView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setClipsToBounds:NO];
        [self.contentView addSubview:self.contentContainerView];
        [self.contentView setClipsToBounds:NO];
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, DH_CELL_HEIGHT - 2, self.frame.size.width, 2)];
        [separatorView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:separatorView];
    }
    return self;
}

- (void)setImageForCellImageView:(UIImage *)anImage
{
    self.cellImageView.image = anImage;
    [self setNeedsDisplay];
}

- (void)setPhotoObject:(PFObject *)aPhotoObject
{
    photoObject = aPhotoObject;
    self.cellImageView.image = nil;
    self.photographerNameLabel.text = [photoObject objectForKey:@"DHDataWhoTook"];
    self.photoDescriptionLabel.text = [photoObject objectForKey:@"DHDataSixWord"];
    CGSize nameSize = [self.photographerNameLabel.text sizeWithFont:[self.photographerNameLabel font]];
    self.photographerNameLabel.frame = CGRectMake(5, 5, nameSize.width, nameSize.height);
    if ([self.photoDescriptionLabel.text sizeWithFont:[self.photoDescriptionLabel font]].width > 320 - nameSize.width) {
        self.photoDescriptionLabel.frame = CGRectMake(self.photographerNameLabel.frame.origin.x + nameSize.width + 5, self.photographerNameLabel.frame.origin.y, 320 - nameSize.width, nameSize.height * 2);
        [self.photoDescriptionLabel setNumberOfLines:2];
    } else {
        self.photoDescriptionLabel.frame = CGRectMake(self.photographerNameLabel.frame.origin.x + nameSize.width + 5, self.photographerNameLabel.frame.origin.y, 320 - nameSize.width, nameSize.height);
    }
    self.levelLabel.text = [[photoObject objectForKey:@"DHDataHappinessLevel"] stringValue];
    CGRect levelBarRect = self.levelBarView.frame;
    levelBarRect.size.width = (CGFloat) 250 * ([[photoObject objectForKey:@"DHDataHappinessLevel"] floatValue] / 10);
    self.levelBarView.frame = levelBarRect;
    NSString *weatherCondition = [photoObject objectForKey:@"DHDataWeatherCondition"];
    NSString *weatherTemperature = [photoObject objectForKey:@"DHDataWeatherTemperature"];
    if (weatherCondition && weatherTemperature) {
        NSString *weatherText = [NSString stringWithFormat:@"%@ %@°F", weatherCondition, weatherTemperature];
        CGSize weatherSize = [weatherText sizeWithFont:[self.weatherLabel font]];
        self.weatherLabel.frame = CGRectMake(320 - (weatherSize.width + 10), 3, weatherSize.width, weatherSize.height);
        self.weatherLabel.text = weatherText;
    }
    id locationStringObj = [photoObject objectForKey:@"DHDataLocationString"];
    NSString *locationString = nil;
    if ([locationStringObj isKindOfClass:[NSString class]]) locationString = (NSString *)locationStringObj;
    if (locationString) {
        CGSize locationSize = [locationString sizeWithFont:[self.locationLabel font]];
        self.locationLabel.frame = CGRectMake(320 - (locationSize.width + 10), -3 + self.weatherLabel.frame.origin.y + self.weatherLabel.frame.size.height, locationSize.width, locationSize.height);
        self.locationLabel.text = locationString;
    }
}

@end
