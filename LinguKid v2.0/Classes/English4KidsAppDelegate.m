//
//  English4KidsAppDelegate.m
//  English4Kids
//
//  Created by Jeannine Struck on 4/30/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "English4KidsAppDelegate.h"
#import "BaseWindow.h"
#import "ResourceManager.h"
#import "BaseController.h"
#import "cocos2d.h"

#define WORK_INIT_APP 0
#define IPHONE_HEIGHT 480
#define IPHONE_WIDTH 320

@implementation English4KidsAppDelegate

@synthesize window;
@synthesize myNavigationController;
@synthesize volMusic;
@synthesize volSound;
@synthesize showWords;
@synthesize showGrid;
@synthesize isGameMode;
@synthesize isGameActive;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	[myNavigationController setToolbarHidden:YES];
	[myNavigationController setNavigationBarHidden:YES]; 
	

	[ResourceManager initialize];
	//[g_ResManager setupSound];

	if (![g_ResManager userDataExists:@"firstTime"]) {
		[g_ResManager storeUserData:[NSNumber numberWithBool:YES] toFile:@"firstTime"];
		self.showWords = YES;
		self.showGrid = NO;
		self.volMusic = 0.5;
		self.volSound = 1.0;
	}
	showWords = [[g_ResManager getUserData:@"showWords"] boolValue]; 
	showGrid = [[g_ResManager getUserData:@"showGrid"] boolValue]; 
	volMusic = [[g_ResManager getUserData:@"volMusic"] floatValue];
	volSound = [[g_ResManager getUserData:@"volSound"] floatValue];
	isGameMode = NO;
	isGameActive = NO;
	
	[g_ResManager playMusic:@"English4Kids.mp3"];
	[g_ResManager setMusicVolume:volMusic];
	[g_ResManager setSoundVolume:volSound];
	
	//vwController = [[MainMenueController alloc] init];

#ifdef DEBUG
	UIDevice *device = [UIDevice currentDevice];
	NSLog(@"current device: %@", device.model);
	if(g_ResManager.isIPad)
		NSLog(@"%@", @"this is an ipad");
#endif
	
	// setup cocos2d
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:CCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:CCDirectorTypeDefault];
	
	// Use RGBA_8888 buffers
	// Default is: RGB_565 buffers
	[[CCDirector sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
	
	// Create a depth buffer of 16 bits
	// Enable it if you are going to use 3D transitions or 3d objects
	//	[[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// before creating any layer, set the landscape mode
	//[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	//[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
	//[[CCDirector sharedDirector] setDisplayFPS:YES];

	/*
	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];		
	
	
	[[CCDirector sharedDirector] runWithScene: [HelloWorld scene]];
	 */
	
	[window addSubview:myNavigationController.view];
    [window makeKeyAndVisible];
	 
	return YES;
}

- (void) applicationWillTerminate:(UIApplication *)application {
#ifdef DEBUG_ALL
	NSLog(@"%@", @"app will terminate");
#endif
	[g_ResManager shutdown];
	[[CCDirector sharedDirector] end];
}

-(void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
#ifdef DEBUG_ALL
	NSLog(@"%@", @"received memory warning");
#endif
	/*TODO: purging sounds crashes in iOS 3.1 if sound effect is still playing*/
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
	[g_ResManager stopSounds];
	[g_ResManager purgeSounds];
#endif
#endif
	[g_ResManager purgeTextures];
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void) pushController: (Class) controller withNib:(NSString *)nib {

	NSString *nibNew = [NSString stringWithString:nib];
	
	
	if(g_ResManager.isIPad) {
		nibNew = [NSString stringWithFormat:@"%@~iPad", nib];
	}

	BaseController *baseControl = [[controller alloc] initWithNibName:nibNew bundle:nil];
	[myNavigationController pushViewController:baseControl animated:YES];
	[baseControl release];
}



- (void) pushController: (Class) controller withNib:(NSString *)nib withPlist:(NSString *)plist {
	
	NSString *nibNew = [NSString stringWithString:nib];
	
	
	if(g_ResManager.isIPad) {
		nibNew = [NSString stringWithFormat:@"%@~iPad", nib];
	}
	
	BaseController *baseControl = [[controller alloc] initWithNibName:nibNew bundle:nil];
	baseControl.plistScenario = plist;
	
	[myNavigationController pushViewController:baseControl animated:YES];
	[baseControl release];
}


- (void)pushController:(Class)controller {
	BaseController *baseControl = [[controller alloc] init];
	[myNavigationController pushViewController:baseControl animated:YES];
	[baseControl release];
}

- (void)pushController:(Class)controller withState:(Class)state withPlist:(NSString *)plist {
	BaseController *baseControl = [[controller alloc] initWithState:state withPlist:plist];
	
	[myNavigationController pushViewController:baseControl animated:YES];
	[baseControl release];
}

- (void)popController {
	[[CCDirector sharedDirector] pause];
	[myNavigationController popViewControllerAnimated:YES];
}

- (void)popToRootController {
	[[CCDirector sharedDirector] pause];
	[myNavigationController popToRootViewControllerAnimated:YES];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

-(BOOL) showWords {
	showWords = [[g_ResManager getUserData:@"showWords"] boolValue];
	return showWords;
}

- (void) setShowWords:(BOOL)val{
	showWords = val;
	[g_ResManager storeUserData:[NSNumber numberWithBool:showWords] toFile:@"showWords"];	
}

- (BOOL) showGrid {
	showGrid = [[g_ResManager getUserData:@"showGrid"] boolValue]; 
	return showGrid;
}

- (void) setShowGrid:(BOOL)val {
	showGrid = val;
	[g_ResManager storeUserData:[NSNumber numberWithBool:showGrid] toFile:@"showGrid"];
}

- (CGFloat) volMusic {
	volMusic = [[g_ResManager getUserData:@"volMusic"] floatValue];
	return volMusic;
}

- (void) setVolMusic:(CGFloat)val {
	volMusic = val;
	[g_ResManager storeUserData:[NSNumber numberWithFloat:volMusic] toFile:@"volMusic"];
	[g_ResManager setMusicVolume:volMusic];
}

- (CGFloat) volSound {
	volSound = [[g_ResManager getUserData:@"volSound"] floatValue];
	return volSound;
}

- (void) setVolSound:(CGFloat)val {
	volSound = val;
	[g_ResManager storeUserData:[NSNumber numberWithFloat:volSound] toFile:@"volSound"];
	[g_ResManager setSoundVolume:volSound];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[myNavigationController release];
    [window release];
    [super dealloc];
}

/*
 - (void)doWork:(NSNumber *)workid {
 // create the threads autoreleaspool
 NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
 switch ([workid intValue]) {
 case WORK_INIT_APP:
 // nothing to do atm
 break;
 default:
 break;
 }
 [workid release];
 [autoreleasepool release];
 }
 */

@end
