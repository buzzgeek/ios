//
//  RoteKarteAppDelegate.h
//  RoteKarte
//
//  Created by Jeannine Struck on 1/30/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoteKarteViewController;

@interface RoteKarteAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RoteKarteViewController *viewController;
	BOOL whistle;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RoteKarteViewController *viewController;
@property (nonatomic, readwrite) BOOL whistle;

@end

