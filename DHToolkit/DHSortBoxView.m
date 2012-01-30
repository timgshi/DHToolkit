//
//  DHSortBoxView.m
//  DHToolkit
//
//  Created by Tim Shi on 1/29/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHSortBoxView.h"
#import "Parse/PFUser.h"

@interface DHSortBoxView()
@property (nonatomic, strong) UIButton *timeButton, *levelButton, *personalButton, *publicButton;
@end

@implementation DHSortBoxView

@synthesize timeButton, levelButton, personalButton, publicButton;
@synthesize sortBoxDelegate;

- (UIButton *)timeButton
{
    if (!timeButton) {
        timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [timeButton addTarget:self action:@selector(timeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [timeButton setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal];
        [timeButton setImage:[UIImage imageNamed:@"time-highlighted.png"] forState:UIControlStateHighlighted];
        timeButton.frame = CGRectMake(15, 35, 23, 23);
        timeButton.highlighted = ([[NSUserDefaults standardUserDefaults] boolForKey:DH_SORT_BY_TIME_DEFAULT_KEY]) ? YES : NO;
        timeButton.enabled = !timeButton.highlighted;
    }
    return timeButton;
}

- (UIButton *)levelButton
{
    if (!levelButton) {
        levelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [levelButton setImage:[UIImage imageNamed:@"rating.png"] forState:UIControlStateNormal];
        [levelButton setImage:[UIImage imageNamed:@"rating-highlighted.png"] forState:UIControlStateHighlighted];
        [levelButton addTarget:self action:@selector(levelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        levelButton.frame = CGRectMake(55, 35, 23, 24);
        levelButton.highlighted = ([[NSUserDefaults standardUserDefaults] boolForKey:DH_SORT_BY_TIME_DEFAULT_KEY]) ? NO : YES;
        levelButton.enabled = !levelButton.highlighted;
    }
    return levelButton;
}

- (UIButton *)personalButton
{
    if (!personalButton) {
        personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [personalButton addTarget:self action:@selector(personalButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [personalButton setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
        [personalButton setImage:[UIImage imageNamed:@"user-highlighted.png"] forState:UIControlStateHighlighted];
        personalButton.frame = CGRectMake(15, 90, 27, 23);
        personalButton.highlighted = ([[NSUserDefaults standardUserDefaults] boolForKey:DH_PUBLIC_VIEW_KEY]) ? NO : YES;
        personalButton.enabled = !personalButton.highlighted;
        if (![PFUser currentUser]) personalButton.enabled = NO;
    }
    return personalButton;
}

- (UIButton *)publicButton
{
    if (!publicButton) {
        publicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publicButton addTarget:self action:@selector(publicButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [publicButton setImage:[UIImage imageNamed:@"group.png"] forState:UIControlStateNormal];
        [publicButton setImage:[UIImage imageNamed:@"group-highlighted.png"] forState:UIControlStateHighlighted];
        publicButton.frame = CGRectMake(55, 90, 36, 23);
        publicButton.highlighted = ([[NSUserDefaults standardUserDefaults] boolForKey:DH_PUBLIC_VIEW_KEY]) ? YES : NO;
        publicButton.enabled = !publicButton.highlighted;
    }
    return publicButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupLabels
{
    UILabel *sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 60, 20)];
    [sortLabel setText:@"Sort by:"];
    [sortLabel setBackgroundColor:[UIColor clearColor]];
    [sortLabel setTextColor:[UIColor whiteColor]];
    [sortLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 80, 20)];
    [displayLabel setText:@"Display:"];
    [displayLabel setBackgroundColor:[UIColor clearColor]];
    [displayLabel setTextColor:[UIColor whiteColor]];
    [displayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [self addSubview:sortLabel];
    [self addSubview:displayLabel];
}

- (void)refreshButtonHighlights
{
    self.timeButton.highlighted = ([[NSUserDefaults standardUserDefaults] boolForKey:DH_SORT_BY_TIME_DEFAULT_KEY]) ? YES : NO;
    self.levelButton.highlighted = ([[NSUserDefaults standardUserDefaults] boolForKey:DH_SORT_BY_TIME_DEFAULT_KEY]) ? NO : YES;
    self.personalButton.highlighted = ([[NSUserDefaults standardUserDefaults] boolForKey:DH_PUBLIC_VIEW_KEY]) ? NO : YES;
    self.publicButton.highlighted = ([[NSUserDefaults standardUserDefaults] boolForKey:DH_PUBLIC_VIEW_KEY]) ? YES : NO;
    self.levelButton.enabled = !levelButton.highlighted;
    self.timeButton.enabled = !timeButton.highlighted;
    self.personalButton.enabled = !personalButton.highlighted;
    self.publicButton.enabled = !publicButton.highlighted;
}

- (id)initWithOrigin:(CGPoint)origin
{
    self = [super initWithImage:[UIImage imageNamed:@"sortbox.png"]];
    if (self) {
        self.userInteractionEnabled = YES;
        self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
        [self setupLabels];
        [self addSubview:self.timeButton];
        [self addSubview:self.levelButton];
        [self addSubview:self.personalButton];
        [self addSubview:self.publicButton];
    }
    return self;
}

- (void)timeButtonPressed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [defaults boolForKey:DH_SORT_BY_TIME_DEFAULT_KEY];
    [defaults setBool:!flag forKey:DH_SORT_BY_TIME_DEFAULT_KEY];
    [defaults synchronize];
    [self refreshButtonHighlights];
    if (self.sortBoxDelegate) [self.sortBoxDelegate sortBoxChangedSortType];
}

- (void)levelButtonPressed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [defaults boolForKey:DH_SORT_BY_TIME_DEFAULT_KEY];
    [defaults setBool:!flag forKey:DH_SORT_BY_TIME_DEFAULT_KEY];
    [defaults synchronize];
    [self refreshButtonHighlights];
    if (self.sortBoxDelegate) [self.sortBoxDelegate sortBoxChangedSortType];
}

- (void)personalButtonPressed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [defaults boolForKey:DH_PUBLIC_VIEW_KEY];
    [defaults setBool:!flag forKey:DH_PUBLIC_VIEW_KEY];
    [defaults synchronize];
    [self refreshButtonHighlights];
    if (self.sortBoxDelegate) [self.sortBoxDelegate sortBoxChangedSortType];
}

- (void)publicButtonPressed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [defaults boolForKey:DH_PUBLIC_VIEW_KEY];
    [defaults setBool:!flag forKey:DH_PUBLIC_VIEW_KEY];
    [defaults synchronize];
    [self refreshButtonHighlights];
    if (self.sortBoxDelegate) [self.sortBoxDelegate sortBoxChangedSortType];
}



@end
