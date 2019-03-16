//
//  CocosViewController.m
//  LinguKid
//
//  Created by Jeannine Struck on 1/23/11.
//  Copyright 2011 Jeannine Struck. All rights reserved.
//

#import "CocosViewController.h"
#import "HelloWorldScene.h"
#import "GameScene.h"
#import "ResourceManager.h"

@implementation CocosViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
		//[g_ResManager stopMusic];
		[[CCDirector sharedDirector] resume];
		[[CCDirector sharedDirector] setDisplayFPS:NO];
		//[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
		[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
		[[CCDirector sharedDirector] setDisplayFPS:YES];
		
		// create an openGL view inside a window
		[[CCDirector sharedDirector] attachInView:self.view];	
		
		
		[[CCDirector sharedDirector] runWithScene: [GameScene scene]];
    }
    return self;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[[CCDirector sharedDirector] detach];
}


- (void)dealloc {
	[[CCDirector sharedDirector] detach];
    [super dealloc];
}


@end
