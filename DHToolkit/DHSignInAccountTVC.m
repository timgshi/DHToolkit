//
//  SignInAccountTVC.m
//  Designing Happiness
//
//  Created by Tim Shi on 9/7/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "SignInAccountTVC.h"
#import "EditingTableViewCell.h"
#import "Parse/PFUser.h"

@interface SignInAccountTVC()
@property (nonatomic, strong) NSString *dhUsername, *dhPassword;
@property (nonatomic, strong) UITextField *dhUsernameField, *dhPasswordField; 
@property (nonatomic, strong) NSArray *textFieldsArray;
@end

@implementation SignInAccountTVC

@synthesize editingTableViewCell;
@synthesize dhUsername, dhPassword;
@synthesize dhUsernameField, dhPasswordField;
@synthesize textFieldsArray;
@synthesize delegate;

- (NSArray *)textFieldsArray
{
    if (!textFieldsArray) {
        textFieldsArray = [[NSArray alloc] initWithObjects:dhUsernameField, dhPasswordField, nil];
    }
    return textFieldsArray;
}

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

- (UIBarButtonItem *)spinnerButton
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    return [[UIBarButtonItem alloc] initWithCustomView:spinner];
}

- (UIBarButtonItem *)signinButton
{
    return [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStyleDone target:self action:@selector(signinButtonPressed)];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationItem.rightBarButtonItem = [self signinButton];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    cell.textField.clearsOnBeginEditing = YES;
    if (indexPath.row == 0) {
        cell.label.text = @"Username";
        dhUsernameField = cell.textField;
        cell.textField.returnKeyType = UIReturnKeyNext;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        if (self.dhUsername) {
            cell.textField.text = self.dhUsername;
        } else {
            cell.textField.placeholder = @"use your DH username";
        }
    } else if (indexPath.row == 1) {
        cell.label.text = @"Password";
        dhPasswordField = cell.textField;
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.secureTextEntry = YES;
        cell.textField.placeholder = @"your DH password";
    } 
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    } 
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (dhUsernameField.text && dhPasswordField.text) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } 
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (dhUsernameField.text && dhPasswordField.text) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } 
    if ([textField isEqual:dhUsernameField]) {
        self.dhUsername = textField.text;
    } else {
        self.dhPassword = textField.text;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (dhUsernameField.text && dhPasswordField.text) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    if ([textField isEqual:dhUsernameField]) {
        self.dhUsername = textField.text;
    } else {
        self.dhPassword = textField.text;
    }
}

#define kEmailDefaultKey @"ParseDefaultEmailKey"
#define kUsernameDefaultKey @"ParseDefaultUsernameKey"

- (void)signinButtonPressed
{
    self.navigationItem.rightBarButtonItem = [self spinnerButton];
    self.dhUsername = self.dhUsernameField.text;
    self.dhPassword = self.dhPasswordField.text;
    [PFUser logInWithUsernameInBackground:self.dhUsername password:self.dhPassword block:^(PFUser *user, NSError *error) {
        if (user != nil) {
            NSString *username = user.username;
            NSString *email = user.email;
            dispatch_async(dispatch_get_main_queue(), ^() {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:username forKey:kUsernameDefaultKey];
                [defaults setObject:email forKey:kEmailDefaultKey];
                [defaults synchronize];
                [self.delegate signinAccountDidSucceed];
            });
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Account Failed" message:@"There was an error in signing in. Please try again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alert show];
            dispatch_async(dispatch_get_main_queue(), ^() {
                self.navigationItem.rightBarButtonItem = [self signinButton];
                NSLog(@"Signin error %@", error);
            });
        }
    }];
}

- (void)cancelButtonPressed
{
    [self.delegate signinAccountDidCancel];
}


@end
