//
//  DHSettingsTVC.m
//  DHToolkit
//
//  Created by Tim Shi on 12/24/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "DHSettingsTVC.h"
#import "Parse/PFUser.h"
#import "Parse/PFPush.h"
#import "DHSignInAccountTVC.h"
#import "DHCreateAccountTVC.h"
#import "UIBarButtonItem+CustomImage.h"

@interface DHSettingsTVC() <DHSignInAccountTVCDelegate, DHCreateAccountTVCDelegate, UIAlertViewDelegate, PF_FBRequestDelegate>
- (void)useFacebookSignin;
@end

@implementation DHSettingsTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Account Signin

- (UIBarButtonItem *)signoutButton
{
//    return [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleDone target:self action:@selector(signoutButtonPressed)];
    return [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"signout.png"] target:self action:@selector(signoutButtonPressed)];
}

- (UIBarButtonItem *)signinButton
{
//    return [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStyleDone target:self action:@selector(signinButtonPressed)];
    return [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"signin.png"] target:self action:@selector(signinButtonPressed)];
}

- (void)signinButtonPressed
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sign in with..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Existing Account", @"Create Account", nil];
    [actionSheet showInView:self.view];
}

- (void)signoutButtonPressed
{
    NSString *userChannel = [NSString stringWithFormat:@"user-%@", ((PFUser *)[PFUser currentUser]).username];
    [PFPush unsubscribeFromChannelInBackground:userChannel];
    [PFUser logOut];
    self.navigationItem.rightBarButtonItem = [self signinButton];
    [self.tableView reloadData];
}

- (void)signinSuccess
{
    NSString *userChannel = [NSString stringWithFormat:@"user-%@", ((PFUser *)[PFUser currentUser]).username];
    [PFPush subscribeToChannelInBackground:userChannel];
    self.navigationItem.rightBarButtonItem = [self signoutButton];
    [self.tableView reloadData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kDHIncrementNetworkActivityNotification object:nil]];
        [self useFacebookSignin];
        
    } else if (buttonIndex == 1) {
        DHSignInAccountTVC *signinTVC = [[DHSignInAccountTVC alloc] initWithStyle:UITableViewStyleGrouped];
        signinTVC.delegate = self;
        UINavigationController *signinNav = [[UINavigationController alloc] initWithRootViewController:signinTVC];
        [self presentModalViewController:signinNav animated:YES];
    } else if (buttonIndex == 2) {
        DHCreateAccountTVC *createTVC = [[DHCreateAccountTVC alloc] initWithStyle:UITableViewStyleGrouped];
        createTVC.delegate = self;
        UINavigationController *createNav = [[UINavigationController alloc] initWithRootViewController:createTVC];
        [self presentModalViewController:createNav animated:YES];
    }
}

#pragma mark - CreateAccountTVCDelegate Methods

- (void)createAccountDidSave
{
    self.navigationItem.rightBarButtonItem = [self signoutButton];
    [self.tableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
    NSString *userChannel = [NSString stringWithFormat:@"user-%@", ((PFUser *)[PFUser currentUser]).username];
    [PFPush subscribeToChannelInBackground:userChannel];
    
}

- (void)createAccountDidCancel
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - SignInAccountTVCDelegate Methods

- (void)signinAccountDidSucceed
{
    [self dismissModalViewControllerAnimated:YES];
    [self.tableView reloadData];
    NSString *userChannel = [NSString stringWithFormat:@"user-%@", ((PFUser *)[PFUser currentUser]).username];
    [PFPush subscribeToChannelInBackground:userChannel];
}

- (void)signinAccountDidCancel
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Settings";
//    self.tableView.allowsSelection = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"backarrow.png"] target:self action:@selector(backArrowPressed)];
}

- (void)backArrowPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![PFUser currentUser]) {
        self.navigationItem.rightBarButtonItem = [self signinButton];
    } else {
        self.navigationItem.rightBarButtonItem = [self signoutButton];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([PFUser currentUser] && section == 1) {
        return 2;
    }
    if (section == 1) {
        return 1;
    }
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = (UILabel *)[super tableView:tableView viewForHeaderInSection:section];
    NSString *text;
    switch (section) {
        case 0:
            text = @"  ACCOUNT DETAILS";
            break;
        case 1:
            text = @"  SHARING SETTINGS";
        default:
            break;
    }
    [label setText:text];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    PFUser *currentUser = (PFUser *)[PFUser currentUser];
    switch ([indexPath section]) {
        case 0:
            if ([indexPath row] == 0) {
                cell.textLabel.text = @"Username:";
                NSString *detailText = (currentUser) ? currentUser.username : @"";
                cell.detailTextLabel.text = detailText;
            } else {
                cell.textLabel.text = @"Email:";
                NSString *detailText = (currentUser) ? currentUser.email : @"";
                cell.detailTextLabel.text = detailText;
            }
            break;
        case 1:
            if (indexPath.row == 0) cell.textLabel.text = @"Make everything private:";
            if (indexPath.row == 1) cell.textLabel.text = @"Facebook:";
            break;
        default:
            break;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        UISwitch *onOff = [[UISwitch alloc] init];
        CGRect frame = CGRectMake(231, 6, 10, 10);
        onOff.frame = frame;
        onOff.transform = CGAffineTransformMakeScale(0.70, 0.70);
        onOff.onTintColor = [UIColor colorWithRed:253/255.0 green:193/255.0 blue:49/255.0 alpha:1];
        [onOff addTarget:self action:@selector(privateSwitchAction:) forControlEvents:UIControlEventValueChanged];
        onOff.on = [[NSUserDefaults standardUserDefaults] boolForKey:kPRIVACY_PREF_KEY];
        [cell.contentView addSubview:onOff];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        if ([currentUser hasFacebook]) {
            cell.detailTextLabel.text = @"Unlink from Facebook";
        } else {
            cell.detailTextLabel.text = @"Link to Facebook";
//            UIButton *fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [fbButton setBackgroundImage:[UIImage imageNamed:@"fbicon.png"] forState:UIControlStateNormal];
//            [fbButton addTarget:self action:@selector(fbIconPressed) forControlEvents:UIControlEventTouchUpInside];
//            fbButton.frame = CGRectMake(255, 5, 28, 28);
//            [cell.contentView addSubview:fbButton];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        if (![PFUser currentUser]) [self signinButtonPressed];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [self performSelector:@selector(fbIconPressed)];
    }
}


#pragma mark - Table view delegate



#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Account Create"]) {
        UITextField *usernameField = [alertView textFieldAtIndex:0];
        NSString *username = usernameField.text;
        PFUser *currentUser = [PFUser currentUser];
        currentUser.username = username;
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Username Error" message:[[error userInfo] objectForKey:@"error"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
                [errorAlert show];
            } else {
                [self signinSuccess];
            }
        }];
    } else if ([[alertView title] isEqualToString:@"Username Error"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Create" message:@"Please select a username" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if ([[alertView title] isEqualToString:@"Account Create"] || [[alertView title] isEqualToString:@"Username Error"]) {
        PFUser *currentUser = [PFUser currentUser];
        [currentUser deleteInBackground];
        [self.tableView reloadData];
    }
}

#pragma mark - Facebook Methods

- (void)fbIconPressed
{
    PFUser *currentUser = [PFUser currentUser];
    if ([currentUser hasFacebook]) {
        [currentUser unlinkFromFacebookWithBlock:^(BOOL succeeded, NSError *error) {
            [self.tableView reloadData]; 
        }];
    } else {
        [currentUser linkToFacebook:[NSArray arrayWithObjects:@"email", @"publish_stream", @"offline_access", nil] block:^(BOOL succeeded, NSError *error) {
            [self.tableView reloadData]; 
        }];
    }
}

- (void)useFacebookSignin
{
    [PFUser logInWithFacebook:[NSArray arrayWithObjects:@"email", @"publish_stream", @"offline_access", nil] block:^(PFUser *user, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kDHDecrementNetworkActivityNotification object:nil]];
        if (error) {
            NSLog(@"%@", [error description]);
        }
        if (user) {
            if (user.isNew) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Create" message:@"Please select a username" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert show];
                [[PFUser facebook] requestWithGraphPath:@"me" andDelegate:self];
            } else {
                [self signinSuccess];
            }
        }
    }];
}

#pragma mark - Facebook Delegate Methods

- (void)request:(PF_FBRequest *)request didLoad:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resultDict = (NSDictionary *)result;
        NSString *email = [resultDict objectForKey:@"email"];
        PFUser *currentUser = [PFUser currentUser];
        currentUser.email = email;
        [currentUser saveInBackground];
    }
}

#pragma mark - Private Switch Target Methods



- (void)privateSwitchAction:(id)sender
{
    if ([sender isKindOfClass:[UISwitch class]]) {
        UISwitch *onOff = (UISwitch *)sender;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        id obj = [defaults objectForKey:kPRIVACY_PREF_KEY];
        if (!obj) {
            [defaults registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:kPRIVACY_PREF_KEY]];
            [defaults synchronize];
        }
        [defaults setBool:onOff.on forKey:kPRIVACY_PREF_KEY];
    }
}

@end
