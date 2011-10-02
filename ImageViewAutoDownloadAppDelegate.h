//
//  ImageViewAutoDownloadAppDelegate.h
//  ImageViewAutoDownload
//
//  Created by Ignazio Calò on 10/1/11.
//  Copyright 2011 Ignazio Calò. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageViewAutoDownloadViewController;

@interface ImageViewAutoDownloadAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ImageViewAutoDownloadViewController *viewController;

@end
