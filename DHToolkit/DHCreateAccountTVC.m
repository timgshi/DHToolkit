//
//  CreateAccountTVC.m
//  Designing Happiness
//
//  Created by Tim Shi on 8/3/11.
//  Copyright 2011 www.timshi.com. All rights reserved.
//

#import "DHCreateAccountTVC.h"
#import "EditingTableViewCell.h"
#import "Parse/PFUser.h"
#import "UIBarButtonItem+CustomImage.h"


@interface DHCreateAccountTVC()
@property (weak, readonly) NSArray *permissions;
@property (nonatomic, copy) NSString *dhUsername, *dhEmail, *fbID, *dhPassword;
@property (nonatomic, strong) UITextField *dhUsernameField, *dhPasswordField, *dhEmailField;
@property (nonatomic, strong) NSArray *textFieldsArray;
//@property (nonatomic, retain) NSMutableArray *dataArray;
@end

@implementation DHCreateAccountTVC

@synthesize facebook;
@synthesize editingTableViewCell;
@synthesize permissions;
@synthesize dhUsername, dhEmail, fbID, dhPassword;
@synthesize dhUsernameField, dhEmailField, dhPasswordField;
@synthesize textFieldsArray;
@synthesize delegate;

- (NSArray *)permissions
{
    if (!permissions)
        permissions = [NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access", @"user_about_me", @"email", nil];
    return permissions;
}

- (NSArray *)textFieldsArray
{
    if (!textFieldsArray) {
        textFieldsArray = [[NSArray alloc] initWithObjects:dhUsernameField, dhPasswordField, dhEmailField, nil];
    }
    return textFieldsArray;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
//        facebook = [[PF_Facebook alloc] initWithAppId:kFBID];
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        if ([defaults objectForKey:@"FBAccessTokenKey"] 
//            && [defaults objectForKey:@"FBExpirationDateKey"]) {
//            self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
//            self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
//        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFacebookURLNotification:) name:@"ReceivedFacebookOpenURL" object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"plus.png"] target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"cancel.png"] target:self action:@selector(cancelButtonPressed)];  
}

- (void)viewDidUnload
{
    [self setEditingTableViewCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EditingCell";
    EditingTableViewCell *cell = (EditingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"EditingTableViewCell" owner:self options:nil];
        cell = editingTableViewCell;
        editingTableViewCell = nil;
    }
    cell.textField.delegate = self;
    cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    if (indexPath.row == 0) {
        cell.label.text = @"Username";
        dhUsernameField = cell.textField;
        cell.textField.returnKeyType = UIReturnKeyNext;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        if (self.dhUsername) {
            cell.textField.text = self.dhUsername;
        } else {
            cell.textField.placeholder = @"pick a username";
        }
    } else if (indexPath.row == 1) {
        cell.label.text = @"Password";
        dhPasswordField = cell.textField;
        cell.textField.returnKeyType = UIReturnKeyNext;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.secureTextEntry = YES;
        cell.textField.placeholder = @"password";
    } else {
        cell.label.text = @"Email";
        dhEmailField = cell.textField;
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        if (self.dhEmail) {
            cell.textField.text = self.dhEmail;
        } else {
            cell.textField.placeholder = @"for DH updates";
        }
    }
    return cell;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self.facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    NSString *messageString = @"Sorry, but in order to create an account for you at this time, you must sign in with Facebook. There will be more options in the future!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Required" message:messageString delegate:nil cancelButtonTitle:@"Alright" otherButtonTitles: nil];
    [alert show];
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    if ([result objectForKey:@"id"]) self.fbID = [result objectForKey:@"id"];
   if ([result objectForKey:@"username"]) self.dhUsername = [result objectForKey:@"username"];
    if ([result objectForKey:@"email"]) self.dhEmail = [result objectForKey:@"email"];
    if ([result objectForKey:@"username"] && [result objectForKey:@"email"]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    [self.tableView reloadData];
}

- (void)dealloc {
    self.facebook;
}

#pragma mark - Button Response

// Keys to access objects in standardUserDefaults
#define kEmailDefaultKey @"ParseDefaultEmailKey"
#define kUsernameDefaultKey @"ParseDefaultUsernameKey"
#define kFBDefaultKey @"DefaultFDID"

- (void)saveButtonPressed
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReceivedFacebookOpenURL" object:nil];
    self.dhUsername = dhUsernameField.text;
    self.dhEmail = dhEmailField.text;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.dhUsername forKey:kUsernameDefaultKey];
    [defaults setObject:self.dhEmail forKey:kEmailDefaultKey];
    [defaults setObject:self.fbID forKey:kFBDefaultKey];
    [defaults synchronize];
    PFUser *user = [[PFUser alloc] init];
    user.username = self.dhUsername;
    user.password = self.dhPassword;
    user.email = self.dhEmail;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^() {
            if (succeeded) {
                [self.delegate createAccountDidSave];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Account Failed" message:@"There was an error in creating your account. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alert show];
            }
            
        });
    }];
    //[AWSPoster createDHAccountWithUsername:self.dhUsername Email:self.dhEmail serviceID:self.fbID serviceType:kDHAccountServiceTypeFacebook];
    
}

- (void)cancelButtonPressed
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReceivedFacebookOpenURL" object:nil];
    [self.facebook logout:self];
    [self.delegate createAccountDidCancel];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:dhUsernameField]) {
        [dhPasswordField becomeFirstResponder];
    } else if ([textField isEqual:dhPasswordField]) {
        [dhEmailField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (dhUsernameField.text && dhEmailField.text && dhPasswordField.text) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } 
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (dhUsernameField.text && dhEmailField.text && dhPasswordField.text) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } 
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (dhUsernameField.text && dhEmailField.text && dhPasswordField.text) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    if ([textField isEqual:dhUsernameField]) {
        self.dhUsername = textField.text;
    } else if ([textField isEqual:dhPasswordField]) {
        self.dhPassword = textField.text;
    } else {
        self.dhEmail = textField.text;
    }
}

- (void)handleFacebookURLNotification:(NSNotification *)notification
{
    NSURL *fbURL = [notification.userInfo objectForKey:@"facebookURL"];
    NSLog(@"Create Account Received URL %@", fbURL);
    [self.facebook handleOpenURL:fbURL];
}

@end
