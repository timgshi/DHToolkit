//
//  SignInAccountTVC.m
//  Designing Happiness
//
//  Created by Tim Shi on 9/7/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "DHSignInAccountTVC.h"
#import "EditingTableViewCell.h"
#import "Parse/PFUser.h"
#import "UIBarButtonItem+CustomImage.h"

@interface DHSignInAccountTVC()
@property (nonatomic, strong) NSString *dhUsername, *dhPassword;
@property (nonatomic, strong) UITextField *dhUsernameField, *dhPasswordField; 
@property (nonatomic, strong) NSArray *textFieldsArray;
- (void)signinButtonPressed;
@end

@implementation DHSignInAccountTVC

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
//    return [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStyleDone target:self action:@selector(signinButtonPressed)];
    return [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"signin.png"] target:self action:@selector(signinButtonPressed)];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationItem.rightBarButtonItem = [self signinButton];
    self.navigationItem.rightBarButtonItem.enabled = NO;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"cancel.png"] target:self action:@selector(cancelButtonPressed)];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EditingCell";
    static NSString *nonEditingIdentifier = @"normalCell";
    EditingTableViewCell *cell = (EditingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"EditingTableViewCell" owner:self options:nil];
        cell = editingTableViewCell;
        editingTableViewCell = nil;
    }   
    cell.textField.delegate = self;
    cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cell.textField.clearsOnBeginEditing = YES;
    if (indexPath.section == 0) {
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
    } else {
        UITableViewCell *nonEditingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nonEditingIdentifier];
        nonEditingCell.textLabel.text = @"Forgot Password?";
        nonEditingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return nonEditingCell;
    }
    return cell;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (dhUsernameField.text.length > 0) {
            [PFUser requestPasswordResetForEmailInBackground:dhUsernameField.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Reset" message:@"Password request sent to your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Reset" message:@"Please enter your email above and then click reset" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
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
    } else {
        [self signinButtonPressed];
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
            [self.delegate signinAccountDidSucceed];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Account Failed" 
                                                            message:@"There was an error in signing in. Please try again" 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Okay" 
                                                  otherButtonTitles: nil];
            [alert show];
            self.navigationItem.rightBarButtonItem = [self signinButton];
            NSLog(@"Signin error %@", error);
        }
    }];
}

- (void)cancelButtonPressed
{
    [self.delegate signinAccountDidCancel];
}


@end
