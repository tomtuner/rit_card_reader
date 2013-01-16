//
//  AppDelegate.h
//  Card_Reader
//
//  Created by Thomas DeMeo on 1/16/13.
//  Copyright (c) 2013 Thomas DeMeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiJackMgr.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, HiJackDelegate> {
    HiJackMgr *hiJackMgr;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;


@end
