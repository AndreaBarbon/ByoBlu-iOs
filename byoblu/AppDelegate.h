//
//  AppDelegate.h
//  byoblu
//
//  Created by Andrea Barbon on 06/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {
    
}


@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;
@property (nonatomic) BOOL advertisements;
@property (nonatomic) BOOL TVStreaming;


@end
