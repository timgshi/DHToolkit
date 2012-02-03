//
//  DH_PFStreamTVC.m
//  DHToolkit
//
//  Created by Tim Shi on 1/10/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DH_PFStreamTVC.h"
#import "Parse/PFQuery.h"
#import "DHExpandingStreamCell.h"
#import "DHImageRatingTVC.h"
#import "DHSettingsTVC.h"
#import "DHPhoto+Photo_PF.h"
#import "ParseFetcher.h"
#import "UIImage+Resize.h"
#import "DHGalleryVC.h"
#import "UIBarButtonItem+CustomImage.h"
#import "DHStreamCell.h"
#import "DHUploadNotificationView.h"
#import "DHSortBoxView.h"
#import "Parse/PFPush.h"

@interface DH_PFStreamTVC() <DHImageRatingDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DHExpandingStreamCellDelegate, DHSortBoxViewDelegate>
@property (nonatomic, strong) NSMutableSet *expandedIndexPaths;
@property (nonatomic, strong) NSCache *photosCache;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) DHGalleryVC *galleryVC;
@property (nonatomic, strong) DHUploadNotificationView *uploadNotificationView;
@property (nonatomic, strong) DHSortBoxView *sortBox;
@property (nonatomic, strong) UIView *opaqueView;

- (PFQuery *)queryBasedOnSortDefaults;
- (NSFetchedResultsController *)fetchedResultsControllerBasedOnSortDefaults;
@end

@implementation DH_PFStreamTVC

@synthesize expandedIndexPaths;
@synthesize photosCache;
@synthesize context;
@synthesize fetchedResultsController;
@synthesize galleryVC;
@synthesize uploadNotificationView;
@synthesize sortBox;
@synthesize opaqueView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.className = @"DHPhoto";
        self.keyToDisplay = @"DHDataSixWord";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- initInManagedObjectContext:(NSManagedObjectContext *)aContext
{
    if (aContext) {
        self = [super initWithStyle:UITableViewStylePlain];
        self.tableView.allowsSelection = NO;    
        self.context = aContext;
        self.className = @"DHPhoto";
        self.keyToDisplay = @"DHDataSixWord";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        NSFetchRequest *fetchRequest = nil;
//        fetchRequest = [[NSFetchRequest alloc] init];
//        fetchRequest.entity = [NSEntityDescription entityForName:@"DHPhoto"
//                                          inManagedObjectContext:context];
//        fetchRequest.sortDescriptors = [NSArray arrayWithObject:
//                                        [NSSortDescriptor sortDescriptorWithKey:@"timestamp"
//                                                                      ascending:NO
//                                                                       selector:@selector(compare:)]];
//        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                                                              managedObjectContext:context
//                                                                                sectionNameKeyPath:nil
//                                                                                         cacheName:nil];
        self.fetchedResultsController = [self fetchedResultsControllerBasedOnSortDefaults];
    } else {
        self = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSMutableSet *)expandedIndexPaths
{
    if (!expandedIndexPaths) {
        expandedIndexPaths = [NSMutableSet set];
    }
    return expandedIndexPaths;
}

- (NSCache *)photosCache
{
    if (!photosCache) {
        photosCache = [[NSCache alloc] init];
        photosCache.countLimit = 25;
    }
    return photosCache;
}

#pragma mark - View lifecycle



- (void)sortButtonPressed
{
    if (sortBox) {
        [UIView animateWithDuration:0.2 animations:^{
            sortBox.alpha = 0;
            opaqueView.alpha = 0;
        } completion:^(BOOL finished) {
            [sortBox removeFromSuperview];
            [opaqueView removeFromSuperview];
            sortBox = nil;
            opaqueView = nil;
        }];
    } else {
        sortBox = [[DHSortBoxView alloc] initWithOrigin:CGPointMake(30, 0)];
        sortBox.sortBoxDelegate = self;
        sortBox.alpha = 0;
        opaqueView = [[UIView alloc] initWithFrame:self.tableView.frame];
        opaqueView.backgroundColor = [UIColor blackColor];
        opaqueView.alpha = 0;
        UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortButtonPressed)];
        [opaqueView addGestureRecognizer:tapgr];
//        [self.tableView.superview addSubview:opaqueView];
        [self.tableView.superview addSubview:sortBox];
        [UIView animateWithDuration:0.2 animations:^{
            sortBox.alpha = 1;
            opaqueView.alpha = 0.3;
        }];
    }
}

- (void)galleryButtonPressed
{
    if (sortBox) {
        [self sortButtonPressed];
    }
    galleryVC = [[DHGalleryVC alloc] initInManagedObjectContext:self.context];
    galleryVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *galleryNav = [[UINavigationController alloc] initWithRootViewController:galleryVC];
    [self presentViewController:galleryNav animated:YES completion:^{
        
    }];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 10)] forBarMetrics:UIBarMetricsDefault];
    self.className = @"DHPhoto";
    self.keyToDisplay = @"DHDataSixWord";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 25;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"DHStream";
    UIBarButtonItem *settingsButton = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"settings.png"] target:self action:@selector(settingsButtonPressed)];
    UIBarButtonItem *cameraButton = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"camera.png"] target:self action:@selector(cameraButtonPressed)];
    UIBarButtonItem *galleryButton = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"gallery.png"] target:self action:@selector(galleryButtonPressed)];
    UIBarButtonItem *sortButton = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"sort.png"] target:self action:@selector(sortButtonPressed)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:cameraButton, settingsButton, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:galleryButton, sortButton, nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadBegin:) name:DH_PHOTO_UPLOAD_BEGIN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadSuccess:) name:DH_PHOTO_UPLOAD_SUCCESS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFailure:) name:DH_PHOTO_UPLOAD_FAILURE_NOTIFICATION object:nil];
    [super viewDidLoad];
    [self.navigationItem setBackBarButtonItem:[UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"backarrow.png"] target:nil action:nil]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 11)] forBarMetrics:UIBarMetricsDefault];
//    [self performSelector:@selector(uploadBegin:) withObject:nil afterDelay:2];
//    self.uploadNotificationView = [[DHUploadNotificationView alloc] initWithFrame:kDH_Upload_Notification_Default_Rect(self.tableView.frame.size.width, self.tableView.frame.size.height)];
//    self.uploadNotificationView.messageText = @"test";
//    self.uploadNotificationView.isLoading = YES;
//    [self.tableView addSubview:self.uploadNotificationView];
    [self.fetchedResultsController performFetch:nil];
    
//    [self performSelector:@selector(uploadBegin:) withObject:nil afterDelay:1];
//    [self performSelector:@selector(uploadSuccess:) withObject:nil afterDelay:5];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navbarblack.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forBarMetrics:UIBarMetricsDefault];
    [super viewDidDisappear:animated];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.uploadNotificationView = nil;
    self.expandedIndexPaths = nil;
    self.photosCache = nil;
    self.fetchedResultsController = nil;
    self.galleryVC = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (PFQuery *)queryForTable
{
//    PFQuery *query = [PFQuery queryWithClassName:self.className];
//    if ([self.objects count] == 0) {
//        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    }
//    [query orderByDescending:@"DHDataTimestamp"];
//    return query;
    return [self queryBasedOnSortDefaults];
}

- (void)DHSetImageFromPhoto:(DHPhoto *)cellPhoto withPhotoObject:(PFObject *)photoObject forStreamCell:(DHStreamCell *)cell
{
    if (cell) {
        __block NSString *cellID = cell.PFObjectID;
        if (cellPhoto.photoData == NULL) {
            [cell setImageForCellImageView:nil];
            [cell.spinner startAnimating];
            dispatch_queue_t downloadQueue = dispatch_queue_create("com.dh.photodownloader", NULL);
            dispatch_async(downloadQueue, ^{ 
//                [self incrementNetworkActivity:nil];
                NSData *imageData = [ParseFetcher photoDataForPhotoObject:photoObject];
                UIImage *image = [UIImage imageWithData:imageData];
                UIImage *thumbImage = nil;
                if (image) {
                    thumbImage = [image thumbnailImage:320 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
                    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, 1.0);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cellPhoto.photoData = thumbImageData;
//                        [self decrementNetworkActivity:nil];
//                        [self.fetchedResultsController.managedObjectContext save:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"AutoSaveRequested" object:nil]];
                    }); 
                } else {
                    thumbImage = [UIImage imageNamed:@"no-image-found.jpg"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([cellID isEqualToString:cell.PFObjectID]) {
                        [cell.spinner stopAnimating];
                        [cell setImageForCellImageView:thumbImage];
                    }
                }); 
            });
            dispatch_release(downloadQueue);
        } else {
            [cell setImageForCellImageView:[UIImage imageWithData:cellPhoto.photoData]];
        }
    } else {
        if (cellPhoto.photoData == NULL) {
            dispatch_queue_t downloadQueue = dispatch_queue_create("com.dh.photodownloader", NULL);
            dispatch_async(downloadQueue, ^{ 
                NSData *imageData = [ParseFetcher photoDataForPhotoObject:photoObject];
                UIImage *image = [UIImage imageWithData:imageData];
                UIImage *thumbImage = nil;
                if (image) {
                    thumbImage = [image thumbnailImage:320 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
                    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, 1.0);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cellPhoto.photoData = thumbImageData;
                        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"AutoSaveRequested" object:nil]];
                    }); 
                } 
            });
            dispatch_release(downloadQueue);
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *CellIdentifier = @"DH Cell";
    DHStreamCell *cell = (DHStreamCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[DHStreamCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    cell.PFObjectID = [object objectId];
    cell.photoObject = object;
//    if ([self.fetchedResultsController.fetchedObjects count]) {
//        cell.cellPhoto = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DHPhoto"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"pfObjectID == %@", [object objectId]];
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:nil];
    if ([results lastObject]) {
        cell.cellPhoto = [results lastObject];
    }
    [cell.spinner stopAnimating];
    [self DHSetImageFromPhoto:cell.cellPhoto withPhotoObject:object forStreamCell:cell];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return ([self.expandedIndexPaths containsObject:indexPath]) ? DH_EXPANDING_CELL_BIG_HEIGHT : DH_EXPANDING_CELL_SMALL_HEIGHT;
    return DH_CELL_HEIGHT;
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    for (PFObject *obj in self.objects) {
//        [DHPhoto photoWithPFObject:obj inManagedObjectContext:self.context];
        [self DHSetImageFromPhoto:[DHPhoto photoWithPFObject:obj inManagedObjectContext:self.context] withPhotoObject:obj forStreamCell:nil];
    }
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

- (void)settingsButtonPressed
{
    if (sortBox) {
        [self sortButtonPressed];
    }
    DHSettingsTVC *settings = [[DHSettingsTVC alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:settings animated:YES];
}

#pragma mark - Photo Selection Methods

- (void)displayImagePickerWithSource:(UIImagePickerControllerSourceType)src;
{
    if([UIImagePickerController isSourceTypeAvailable:src]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:src];
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [self presentViewController:picker animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        }];
    }
}

- (void)cameraButtonPressed
{
    if (sortBox) {
        [self sortButtonPressed];
    }
    if ([PFUser currentUser]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"Select Image Source"
                                          delegate:self 
                                          cancelButtonTitle:@"Cancel" 
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"Camera",@"Photo Library", nil];
            [actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
            [actionSheet showInView:self.view]; 
        } else {
            [self displayImagePickerWithSource:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo posting" message:@"You must sign in to post photos! Please click the settings button to sign in." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    UIImage *selectedPhoto;
    if ([info objectForKey:UIImagePickerControllerEditedImage]) {
        selectedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        selectedPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        DHImageRatingTVC *imageRatingTVC = [[DHImageRatingTVC alloc] init];
        imageRatingTVC.selectedPhoto = selectedPhoto;
        UINavigationController *ratingNav = [[UINavigationController alloc] initWithRootViewController:imageRatingTVC];
        imageRatingTVC.delegate = self;
        [self presentViewController:ratingNav animated:YES completion:nil];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}

- (void)imageRatingTVCDidFinish:(DHImageRatingTVC *)rater withSave:(BOOL)save
{
    if (save) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self performSelector:@selector(uploadBegin:) withObject:nil];
        }];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate Methods


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    if ([actionSheet.title isEqualToString:@"Select Image Source"]) {
        switch (buttonIndex) {
            case 0:
                [self displayImagePickerWithSource:UIImagePickerControllerSourceTypeCamera];
                break;
            case 1:
                [self displayImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            case 2:
                break;
            default:
                break;
        }
    }
}

#pragma mark - DHExpandingStreamCellDelegate Methods

- (UIImage *)cell:(DHExpandingStreamCell *)cell wantsImageForObjectID:(NSString *)objectID
{
    UIImage *image = [self.photosCache objectForKey:objectID];
    if (image != NULL) return image;
    return nil;
}

- (void)cell:(DHExpandingStreamCell *)cell loadedImage:(UIImage *)image forObjectID:(NSString *)objectID
{
    [self.photosCache setObject:image forKey:objectID];
}

#pragma mark - Upload Notification Handlers

- (void)uploadBegin:(NSNotification *)notification
{
    self.uploadNotificationView = [[DHUploadNotificationView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, kDH_Upload_Notification_View_Height)];
    self.uploadNotificationView.messageText = kDH_Uploading_Text;
    self.uploadNotificationView.isLoading = YES;
    [self.tableView.superview addSubview:self.uploadNotificationView];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.uploadNotificationView.frame;
        frame.origin.y = self.tableView.frame.size.height - frame.size.height;
        self.uploadNotificationView.frame = frame;
    }];
}

- (void)uploadSuccess:(NSNotification *)notification
{
    [self loadObjects];
    PFUser *curUser = [PFUser currentUser];
    NSString *pushMessage = [NSString stringWithFormat:@"%@ just shared a moment", curUser.username];
    [PFPush sendPushMessageToChannelInBackground:@"" withMessage:pushMessage];
    self.uploadNotificationView.messageText = kDH_Success_Text;
    self.uploadNotificationView.isLoading = NO;
    [UIView animateWithDuration:0.3 delay:2.0 options:0 animations:^{
        CGRect frame = self.uploadNotificationView.frame;
        frame.origin.y = self.tableView.frame.size.height;
        self.uploadNotificationView.frame = frame;
    } completion:^(BOOL finished) {
        [self.uploadNotificationView removeFromSuperview];
    }];
}

- (void)uploadFailure:(NSNotification *)notification
{
    self.uploadNotificationView.messageText = kDH_Failure_Text;
    self.uploadNotificationView.isLoading = NO;
    [UIView animateWithDuration:0.3 delay:2.0 options:0 animations:^{
        CGRect frame = self.uploadNotificationView.frame;
        frame.origin.y = self.tableView.frame.size.height;
        self.uploadNotificationView.frame = frame;
    } completion:^(BOOL finished) {
        [self.uploadNotificationView removeFromSuperview];
    }];
}



#pragma mark - Sorting Methods

- (PFQuery *)queryBasedOnSortDefaults
{
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    NSString *orderKey = ([[NSUserDefaults standardUserDefaults] boolForKey:DH_SORT_BY_TIME_DEFAULT_KEY]) ? @"createdAt" : @"DHDataHappinessLevel";
    [query orderByDescending:orderKey];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:DH_PUBLIC_VIEW_KEY] && [PFUser currentUser]) {
//        [query whereKey:@"PFUser" equalTo:[PFUser currentUser]];
        PFUser *curUser = [PFUser currentUser];
        [query whereKey:@"DHDataWhoTook" equalTo:curUser.username];
    }
    return query;
}

- (NSFetchedResultsController *)fetchedResultsControllerBasedOnSortDefaults
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"DHPhoto"
                                      inManagedObjectContext:context];
//    NSString *sortKey = ([[NSUserDefaults standardUserDefaults] boolForKey:DH_SORT_BY_TIME_DEFAULT_KEY]) ? @"timestamp" : @"happinessLevel";
    NSArray *sortDescriptors = nil;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:DH_SORT_BY_TIME_DEFAULT_KEY]) {
        sortDescriptors = [NSArray arrayWithObject:
                           [NSSortDescriptor sortDescriptorWithKey:@"timestamp"
                                                         ascending:NO
                                                          selector:@selector(compare:)]];
    } else {
        sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"happinessLevel"
                                                                                  ascending:NO
                                                                                   selector:@selector(compare:)], 
                                                    [NSSortDescriptor sortDescriptorWithKey:@"timestamp"
                                                                                   ascending:NO
                                                                                   selector:@selector(compare:)], nil];
    }
    fetchRequest.sortDescriptors = sortDescriptors;
//    fetchRequest.sortDescriptors = [NSArray arrayWithObject:
//                                    [NSSortDescriptor sortDescriptorWithKey:sortKey
//                                                                  ascending:NO
//                                                                   selector:@selector(compare:)]];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:DH_PUBLIC_VIEW_KEY] && [PFUser currentUser]) {
        PFUser *currentUser = [PFUser currentUser];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"photographerUsername == %@", currentUser.username];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:DH_PUBLIC_VIEW_KEY] && ![[NSUserDefaults standardUserDefaults] boolForKey:DH_SORT_BY_TIME_DEFAULT_KEY]) {
        fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"happinessLevel"
                                                                                               ascending:NO
                                                                                                selector:@selector(compare:)], 
                                        [NSSortDescriptor sortDescriptorWithKey:@"timestamp"
                                                                      ascending:NO
                                                                       selector:@selector(compare:)], nil];
    }
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    return frc;
}

#pragma mark - DHSortBoxViewDelegate Methods

- (void)sortBoxChangedSortType
{
    [sortBox removeFromSuperview];
    sortBox = nil;
    sortBox = [[DHSortBoxView alloc] initWithOrigin:CGPointMake(30, 0)];
    sortBox.sortBoxDelegate = self;
    [self.tableView.superview addSubview:sortBox];
    self.fetchedResultsController = [self fetchedResultsControllerBasedOnSortDefaults];
    [self.fetchedResultsController performFetch:nil];
    [self loadObjects];
//    [self sortButtonPressed];
}


@end
