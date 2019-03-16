//
//  English4KidsAppDelegate.h
//  English4Kids
//
//  Created by Jeannine Struck on 4/30/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseWindow;
@class BaseController;

@interface English4KidsAppDelegate : NSObject <UIApplicationDelegate> {
    BaseWindow		*window;
	UINavigationController *myNavigationController;
	CGFloat volMusic;
	CGFloat volSound;
	BOOL	showWords;
	BOOL	showGrid;
	BOOL	isGameMode;
	BOOL	isGameActive;

}

@property (nonatomic, retain) IBOutlet BaseWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *myNavigationController;
@property (nonatomic) CGFloat volMusic;
@property (nonatomic) CGFloat volSound;
@property (nonatomic) BOOL	showWords;
@property (nonatomic) BOOL	showGrid;
@property (nonatomic) BOOL  isGameMode;
@property (nonatomic) BOOL  isGameActive;

- (void) pushController: (Class) controller;
- (void) pushController: (Class) controller withNib:(NSString *)nib;
- (void) pushController: (Class) controller withNib:(NSString *)nib withPlist:(NSString *)plist;
- (void) pushController: (Class) controller withState: (Class) state withPlist:(NSString *)plist;
- (void) popController;
- (void) popToRootController;


@end

