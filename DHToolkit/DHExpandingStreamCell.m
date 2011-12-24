//
//  DHExpandingStreamCell.m
//  Designing-Happiness
//
//  Created by Tim Shi on 11/27/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "DHExpandingStreamCell.h"
#import "DHPhoto+Photo_PF.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DH_YELLOW_HEX_COLOR 0xFFE98D

@interface DHExpandingStreamCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *photographerNameLabel, *photoDescriptionLabel, *levelLabel, *weatherLabel, *locationLabel;
@property (nonatomic, strong) UIView *infoBarContainerView, *infoBarColoredContainer, *levelBarView;

@end

@implementation DHExpandingStreamCell

@synthesize isExpanded;
@synthesize cellImageView;
@synthesize contentContainerView;
@synthesize cellPhoto;
@synthesize photographerNameLabel, photoDescriptionLabel, levelLabel, weatherLabel, locationLabel;
@synthesize infoBarContainerView, infoBarColoredContainer, levelBarView;
@synthesize spinner;
@synthesize PFObjectID;


- (UIImageView *)cellImageView
{
    if (!cellImageView) {
        cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, DH_EXPANDING_CELL_BIG_HEIGHT)];
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
        [photographerNameLabel setFont:[UIFont boldSystemFontOfSize:20]];
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
        [photoDescriptionLabel setFont:[UIFont boldSystemFontOfSize:20]];
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
        levelLabel.frame = CGRectMake(5, 5, 20, 20);
        [levelLabel setBackgroundColor:[UIColor clearColor]];
        [levelLabel setTextColor:[UIColor whiteColor]];
        [levelLabel setFont:[UIFont boldSystemFontOfSize:20]];
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
        [weatherLabel setFont:[UIFont boldSystemFontOfSize:16]];
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
        [locationLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [locationLabel setShadowOffset:CGSizeMake(-1, 1)];
        [locationLabel setShadowColor:[UIColor blackColor]];
    }
    return locationLabel;
}

- (UIView *)levelBarView
{
    if (!levelBarView) {
        levelBarView = [[UIView alloc] init];
        levelBarView.frame = CGRectMake(0, 40, 250, 20);
        [levelBarView setBackgroundColor:UIColorFromRGB(DH_YELLOW_HEX_COLOR)];
    }
    return levelBarView;
}

- (UIView *)infoBarContainerView
{
    if (!infoBarContainerView) {
        infoBarContainerView = [[UIView alloc] init];
        [infoBarContainerView setBackgroundColor:[UIColor clearColor]];
        infoBarContainerView.frame = CGRectMake(0, DH_EXPANDING_CELL_BIG_HEIGHT - DH_EXPANDING_CELL_INFO_BAR_HEIGHT, 320, DH_EXPANDING_CELL_INFO_BAR_HEIGHT);
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
        infoBarColoredContainer.frame = CGRectMake(0, DH_EXPANDING_CELL_BIG_HEIGHT - DH_EXPANDING_CELL_INFO_BAR_HEIGHT, 320, DH_EXPANDING_CELL_INFO_BAR_HEIGHT);
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
        contentContainerView.frame = CGRectMake(0, 0, 320, DH_EXPANDING_CELL_BIG_HEIGHT);
        [contentContainerView addSubview:self.cellImageView];
        [contentContainerView addSubview:self.photographerNameLabel];
        [contentContainerView addSubview:self.photoDescriptionLabel];
        [contentContainerView addSubview:self.infoBarColoredContainer];
        [contentContainerView addSubview:self.infoBarContainerView];
        [contentContainerView addSubview:self.spinner];
    }
    return contentContainerView;
}

- (void)setCellPhoto:(Photo *)aPhoto
{
    cellPhoto = aPhoto;
//    self.photographerNameLabel.text = [NSString stringWithFormat:@"%@: ", aPhoto.photographerUsername];
//    self.photoDescriptionLabel.text = aPhoto.name;
//    CGSize nameSize = [self.photographerNameLabel.text sizeWithFont:[self.photographerNameLabel font]];
//    self.photographerNameLabel.frame = CGRectMake(5, 5, nameSize.width, nameSize.height);
//    if ([aPhoto.name sizeWithFont:[self.photoDescriptionLabel font]].width > 320 - nameSize.width) {
//        self.photoDescriptionLabel.frame = CGRectMake(self.photographerNameLabel.frame.origin.x + nameSize.width - 5, self.photographerNameLabel.frame.origin.y, 320 - nameSize.width, nameSize.height * 2);
//        [self.photoDescriptionLabel setNumberOfLines:2];
//    } else {
//        self.photoDescriptionLabel.frame = CGRectMake(self.photographerNameLabel.frame.origin.x + nameSize.width - 5, self.photographerNameLabel.frame.origin.y, 320 - nameSize.width, nameSize.height);
//    }
//    self.levelLabel.text = [aPhoto.happinessLevel stringValue];
//    if (aPhoto.weatherCondition && aPhoto.weatherTemperature) {
//        NSString *weatherText = [NSString stringWithFormat:@"%@ %@°F", aPhoto.weatherCondition, aPhoto.weatherTemperature];
//        CGSize weatherSize = [weatherText sizeWithFont:[self.weatherLabel font]];
//        self.weatherLabel.frame = CGRectMake(320 - (weatherSize.width + 5), 5, weatherSize.width, weatherSize.height);
//        self.weatherLabel.text = weatherText;
//    }
//    if (aPhoto.subtitle) {
//        CGSize locationSize = [aPhoto.subtitle sizeWithFont:[self.locationLabel font]];
//        self.locationLabel.frame = CGRectMake(320 - (locationSize.width + 5), 10 + self.weatherLabel.frame.origin.y + self.weatherLabel.frame.size.height, locationSize.width, locationSize.height);
//        self.locationLabel.text = aPhoto.subtitle;
//    }
//    CGRect levelBarRect = self.levelBarView.frame;
//    levelBarRect.size.width = (CGFloat) 250 * ([aPhoto.happinessLevel floatValue] / 10);
//    self.levelBarView.frame = levelBarRect;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setClipsToBounds:YES];
        isExpanded = NO;
        [self.contentView addSubview:self.contentContainerView];
        [self.contentView setClipsToBounds:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setImageForCellImageView:(UIImage *)anImage
{
    self.cellImageView.image = anImage;
    [self setNeedsDisplay];
}

@end
