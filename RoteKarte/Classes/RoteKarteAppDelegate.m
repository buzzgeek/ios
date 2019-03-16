//
//  RoteKarteAppDelegate.m
//  RoteKarte
//
//  Created by Jeannine Struck on 1/30/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RoteKarteAppDelegate.h"
#import "RoteKarteViewController.h"
#import "ResourceManager.h"

@implementation RoteKarteAppDelegate

@synthesize whistle;
@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	[ResourceManager initialize];
	[g_ResManager setupSound];
	[g_ResManager getSound:@"fart2.caf"];
	[g_ResManager getSound:@"whistle.caf"];

	CGRect bounds = [[UIScreen mainScreen] bounds];
	
	self.window = [[[UIWindow alloc] initWithFrame:bounds]autorelease];
	viewController = [[RoteKarteViewController alloc] init];

	whistle = YES;
	
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[g_ResManager stopSounds];
	/*TODO: purging sounds crashes if sound effect is still playing*/
	[g_ResManager purgeSounds];
	[g_ResManager purgeTextures];
}

- (void) applicationWillTerminate:(UIApplication *)application {
	[g_ResManager shutdown];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end
