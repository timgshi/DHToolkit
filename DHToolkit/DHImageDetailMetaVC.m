//
//  DHImageDetailMetaVC.m
//  DHToolkit
//
//  Created by Tim Shi on 2/3/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHImageDetailMetaVC.h"
#import "DHImageDetailMetaHeaderVC.h"
#import "DHImageDetailCommentTVC.h"
#import "HPGrowingTextView.h"
#import "ParsePoster.h"

@interface DHImageDetailMetaVC() <HPGrowingTextViewDelegate>
@property (nonatomic, strong) DHImageDetailMetaHeaderVC *headerVC;
@property (nonatomic, strong) DHImageDetailCommentTVC *commentTVC;
@property (nonatomic, strong) UIView *textViewContainerView, *containerView;
@property (nonatomic, strong) HPGrowingTextView *growingTextView;

- (void)setupGrowingTextView;
@end

@implementation DHImageDetailMetaVC

@synthesize photoObject;
@synthesize managedPhoto;
@synthesize headerVC;
@synthesize commentTVC;
@synthesize textViewContainerView, containerView;
@synthesize growingTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (UIView *)containerView
{
    if (!containerView) {
        CGRect frame = self.view.frame;
//        frame.size.height -= 64;
//        frame.origin.y -= 40;
        containerView = [[UIView alloc] initWithFrame:frame];
//        containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    }
    return containerView;
}



#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *backgroundImage = [[UIImage imageNamed:@"BackgroundGradient.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.containerView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.headerVC = [[DHImageDetailMetaHeaderVC alloc] init];
    self.headerVC.photoObject = self.photoObject;
    
    [self.containerView addSubview:self.headerVC.view];
    NSLog(@"container: %@",NSStringFromCGRect(self.containerView.frame));
    NSLog(@"header: %@", NSStringFromCGRect(self.headerVC.view.frame));
    self.commentTVC = [[DHImageDetailCommentTVC alloc] initWithStyle:UITableViewStylePlain photoObject:self.photoObject];
    self.commentTVC.tableView.frame = CGRectMake(0, self.headerVC.view.frame.size.height, 320, self.containerView.bounds.size.height - self.headerVC.view.frame.size.height - 80);
    [self.containerView addSubview:self.commentTVC.tableView];
    [self.view addSubview:self.containerView];
    [self setupGrowingTextView];
    [self.view addSubview:textViewContainerView];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];	
    UITapGestureRecognizer *tapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:growingTextView action:@selector(resignFirstResponder)];
    UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:growingTextView action:@selector(resignFirstResponder)];
    [self.headerVC.view addGestureRecognizer:tapGR1];
    [self.commentTVC.tableView addGestureRecognizer:tapGR2];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setGrowingTextView:nil];
    [self setTextViewContainerView:nil];
    [self setContainerView:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Growing Text View

- (void)setupGrowingTextView
{
    textViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.containerView.frame.size.height - 80, 320, 40)];
    
	growingTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
    growingTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	growingTextView.minNumberOfLines = 1;
	growingTextView.maxNumberOfLines = 3;
    growingTextView.internalTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
	growingTextView.returnKeyType = UIReturnKeySend; //just as an example
	growingTextView.font = [UIFont systemFontOfSize:14.0f];
	growingTextView.delegate = self;
    growingTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    growingTextView.backgroundColor = [UIColor whiteColor];
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    //    [self.view addSubview:textViewContainerView];
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, textViewContainerView.frame.size.width, textViewContainerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    
    // view hierachy
    [textViewContainerView addSubview:imageView];
    [textViewContainerView addSubview:growingTextView];
    [textViewContainerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"sendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"sendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(textViewContainerView.frame.size.width - 69, 2, 63, 35);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	[doneBtn setTitle:@"Send" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn addTarget:self action:@selector(sendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[textViewContainerView addSubview:doneBtn];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
	
	// get the height since this is the main value that we need.
	NSInteger kbSizeH = keyboardBounds.size.height;
    
	// get a rect for the textView frame
	CGRect containerFrame = textViewContainerView.frame;
	containerFrame.origin.y -= kbSizeH;
	containerFrame.origin.y += self.tabBarController.tabBar.frame.size.height;
    CGRect tableContainerFrame = containerView.frame;
    tableContainerFrame.origin.y -= kbSizeH;
    tableContainerFrame.origin.y += self.tabBarController.tabBar.frame.size.height;
    //	// animations settings
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationBeginsFromCurrentState:YES];
    //    [UIView setAnimationDuration:0.25f];
    //	
    //	// set views with new info
    //	textViewContainerView.frame = containerFrame;
    //	
    //	// commit animations
    //	[UIView commitAnimations];
    [UIView animateWithDuration:0.25f animations:^() {
        textViewContainerView.frame = containerFrame;
        containerView.frame = tableContainerFrame;
    } completion:^(BOOL finished) {
        //        [self.detailTVC.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.detailTVC numberOfComments] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        [self. scrollToBottom];
        [self.commentTVC scrollToBottom];
    }];
}

-(void) keyboardWillHide:(NSNotification *)note{
    // get keyboard size and location
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
	
	// get the height since this is the main value that we need.
	NSInteger kbSizeH = keyboardBounds.size.height;
	
	// get a rect for the textView frame
	CGRect containerFrame = textViewContainerView.frame;
	containerFrame.origin.y += kbSizeH;
	containerFrame.origin.y -= self.tabBarController.tabBar.frame.size.height;
    CGRect tableContainerFrame = containerView.frame;
    tableContainerFrame.origin.y += kbSizeH;
    tableContainerFrame.origin.y -= self.tabBarController.tabBar.frame.size.height;
    //	// animations settings
    //	[UIView beginAnimations:nil context:NULL];
    //	[UIView setAnimationBeginsFromCurrentState:YES];
    //    [UIView setAnimationDuration:0.25f];
    //	
    //	// set views with new info
    //	textViewContainerView.frame = containerFrame;
    //	
    //	// commit animations
    //	[UIView commitAnimations];
    [UIView animateWithDuration:0.25f animations:^() {
        textViewContainerView.frame = containerFrame;
        containerView.frame = tableContainerFrame;
    }];
}

- (void)growingTextView:(HPGrowingTextView *)aGrowingTextView willChangeHeight:(float)height
{
    float diff = (aGrowingTextView.frame.size.height - height);
    
	CGRect r = textViewContainerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	textViewContainerView.frame = r;
}

-(void)resignTextView
{
//    if ([PFUser currentUser]) {
//        [ParsePoster postCommentWithMessage:growingTextView.text photoID:selectedPhoto.unique completionBlock:^(BOOL success) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"comment" message:@"message sent " delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
//            [alert show];
//        }];
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
//                                                        message:@"You must be logged in to comment!" 
//                                                       delegate:nil 
//                                              cancelButtonTitle:@"OK" 
//                                              otherButtonTitles: nil];
//        [alert show];
//    }
	[growingTextView resignFirstResponder];
//    growingTextView.text = @"";
    
}

- (void)sendButtonPressed
{
    if ([PFUser currentUser]) {
        [ParsePoster postCommentForPhoto:self.photoObject withMessage:self.growingTextView.text];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentSucceeded) name:DH_COMMENT_UPLOAD_SUCCESS_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentFailed) name:DH_COMMENT_UPLOAD_FAILURE_NOTIFICATION object:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"You must be logged in to comment!" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
    }

}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self sendButtonPressed];
    [self resignTextView];
    return YES;
}

- (void)commentSucceeded
{
    self.growingTextView.text = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DH_COMMENT_UPLOAD_SUCCESS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DH_COMMENT_UPLOAD_FAILURE_NOTIFICATION object:nil];
    [self.commentTVC loadObjects];
}

- (void)commentFailed
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DH_COMMENT_UPLOAD_SUCCESS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DH_COMMENT_UPLOAD_FAILURE_NOTIFICATION object:nil];
}


@end
