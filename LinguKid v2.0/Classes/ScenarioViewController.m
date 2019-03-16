//
//  ScenarioViewController.m
//  English4Kids
//
//  Created by Jeannine Struck on 8/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScenarioViewController.h"
#import "BaseView.h"
#import "GameBarController.h"
#import "GameBar.h"
#import "ResourceManager.h"

@interface ScenarioViewController (Private)

- (void) onGameBar:(id)data;

@end


@implementation ScenarioViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self=[super initWithCoder:aDecoder])) {
		//TODO
	}
	return self;
	
}

- (id) initWithState:(Class)state withPlist:(NSString *)plist{
	if ((self = [self init])) {
		BaseView *viewTmp = [[state alloc] initWithFrame:[[UIScreen mainScreen]applicationFrame] loadPlist:plist];
		[viewTmp setNotificationDelegate:self forEvent:EVENT_ON_BTN_GAMEBAR withSelector:@selector(onGameBar:)];
		[self.view addSubview:viewTmp];
		[viewTmp release];
	}
	return self;
} 

- (id)init {
	if ((self=[super init])) {
		//TODO
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
	// for iOS 3.1 the purgesound causes a crash if the sound is still playing
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
	[g_ResManager stopSounds];
	[g_ResManager purgeSounds];
#endif
#endif
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void) onGameBar:(id)data {
	/*
	GameBarController *gameBarController = [[GameBarController alloc] 
												initWithNibName:@"GameBarController" 
												bundle:nil];
	//		aboutViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
	gameBarController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	//gameBarController.myConfigViewController = self;
	[self presentModalViewController:gameBarController animated:YES];
	[gameBarController release];
	*/
}

@end
