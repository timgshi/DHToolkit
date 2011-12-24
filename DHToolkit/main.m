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

int main(int argc, char *argv[])
{
    [Parse setApplicationId:@"53Rdo20D9PA1hiPTN7qPzcPVaNQEmAkMXi3j6tLv" 
                  clientKey:@"CVNgA15kiHcktyOTkHDu4hXOfm8c8V9ACgpT2DPu"];
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
