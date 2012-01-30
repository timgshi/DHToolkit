
//
//  main.m
//  DHToolkit
//
//  Created by Tim Shi on 12/21/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "AppDelegate.h"

//#ifdef DEBUG
//#define kDH_APP_ID @"Hh6RFNweSFBt4GcB3DFd48NuT7j8VHNZuG9N9sZG"
//#define KDH_CLIENT_KEY @"o22vDTQ6LhIBjkf4z5mZ9JIRpssl0L1FlzeGY09Q"
//#else
#define kDH_APP_ID @"53Rdo20D9PA1hiPTN7qPzcPVaNQEmAkMXi3j6tLv" 
#define KDH_CLIENT_KEY @"CVNgA15kiHcktyOTkHDu4hXOfm8c8V9ACgpT2DPu"
//#endif

int main(int argc, char *argv[])
{
    [Parse setApplicationId:kDH_APP_ID 
                  clientKey:KDH_CLIENT_KEY];
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
