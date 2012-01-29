//
//  DHUploadNotificationView.h
//  DHToolkit
//
//  Created by Tim Shi on 1/29/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDH_Upload_Notification_View_Height 40
#define kDH_Upload_Notification_Default_Rect(windowWidth, windowHeight) CGRectMake(0, windowHeight - 40, windowWidth, 40)
#define kDH_Uploading_Text @"Uploading..."
#define kDH_Success_Text @"Success!"
#define kDH_Failure_Text @"Upload Failed"

@interface DHUploadNotificationView : UIView

@property (nonatomic, strong) NSString *messageText;
@property (nonatomic) BOOL isLoading;

@end
