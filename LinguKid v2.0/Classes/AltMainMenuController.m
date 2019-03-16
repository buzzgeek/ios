//
//  AltMainMenuController.m
//  English4Kids
//
//  Created by Jeannine Struck on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AltMainMenuController.h"
#import "English4KidsAppDelegate.h"
#import "ScenarioViewController.h"
#import	"PrefsViewController.h"
#import "AboutViewController.h"
#import "IntroViewController.h"
#import "GameMemoryController.h"
#import "CocosViewController.h"
#import "CFView.h"
#import "Scenario.h"
#import "ResourceManager.h"

@interface AltMainMenuController (private)

- (BOOL) initScenarios:(NSString *)plist;

@end

@implementation AltMainMenuController

@synthesize btnPlay;
@synthesize btnFreestyle;
@synthesize btnPrefs;
@synthesize btnInfo;
@synthesize btnIntro;
@synthesize coverFlowViewController;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//[btnPlay setTitle:NSLocalizedString(@"btnPlay",@"run the game in play mode") forState:UIControlStateNormal]; 
	//[btnFreestyle setTitle:NSLocalizedString(@"btnFreestyle",@"run the game in play mode") forState:UIControlStateNormal]; 
	//[btnPrefs setTitle:NSLocalizedString(@"btnPrefs",@"open the prefs view") forState:UIControlStateNormal]; 
	
	btnPlay.hidden = YES;
	btnFreestyle.hidden = YES;
	btnPrefs.center = CGPointMake([g_ResManager widthPcnt:0.1], [g_ResManager heightPcnt:0.95]);
	btnIntro.center = CGPointMake([g_ResManager widthPcnt:0.5], [g_ResManager heightPcnt:0.95]);
	btnInfo.center = CGPointMake([g_ResManager widthPcnt:0.9], [g_ResManager heightPcnt:0.95]);

	// setup coverflow view
	[self initScenarios:@"scenarios"];

}

- (BOOL) initScenarios:(NSString *)plist {
	NSData		*pData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plist ofType:@"plist"]];
	NSString	*error;
	NSPropertyListFormat format;
	
	NSDictionary *_dictScenarios = [NSPropertyListSerialization 
					   propertyListFromData:pData 
					   mutabilityOption:NSPropertyListImmutable 
					   format:&format 
					   errorDescription:&error];
	if (error != nil) {
#ifdef DEBUG_ALL
		NSLog(@"error - %@", error);
#endif
		return NO;
	}

	NSString *scenario = nil;
	
	covers = [ [ NSMutableDictionary alloc ] init ];
	for (scenario in _dictScenarios) {
		NSDictionary *dict = [_dictScenarios objectForKey:scenario];
		NSString *img = [dict objectForKey:SCENE_TAG_IMAGE];
#ifdef DEBUG_ALL 			
		NSLog(@"Loading demo image %@\n", img);
#endif
		UIImage *image	= [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:img ofType:@"png"]];
		[ covers setObject: image forKey:scenario ];
		[image release];
	}
	
	
	CGRect rect = CGRectMake([g_ResManager widthPcnt: 0.1], [g_ResManager heightPcnt:0.075], [g_ResManager widthPcnt: 0.8], [g_ResManager heightPcnt:0.8]);
	[coverFlowViewController.view setFrame:rect];
	
	rect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	coverFlowView = [ [ CFView alloc ] initWithFrame: rect covers: covers ];
	//coverFlowView = [ [ CFView alloc ] initWithFrame: coverFlowViewController.view.bounds covers: covers ];
	
	coverFlowView.selectedCover = 1;
	[coverFlowViewController.view addSubview:coverFlowView];
	
	return YES;
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
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[covers release];
	covers = nil;
}


- (IBAction) onButton:(id)sender {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

	if ([btnPlay isEqual:sender]) {
		delegate.isGameMode = YES;
		[delegate pushController:[ScenarioViewController class] withState:[Scenario class] withPlist:[self getSelectedScenario]];
	} else if ([btnFreestyle isEqual:sender]) {
		delegate.isGameMode = NO;
		[delegate pushController:[ScenarioViewController class] withState:[Scenario class] withPlist:[self getSelectedScenario]];
	} else if ([btnPrefs isEqual:sender]) {
		[delegate pushController:[PrefsViewController class]];
	} else if ([btnInfo isEqual:sender]) {
		[delegate pushController:[CocosViewController class]];
//		[delegate pushController:[AboutViewController class]];
	} else if ([btnIntro isEqual:sender]) {
		[delegate pushController:[IntroViewController class]];
	}
}

- (NSString *)getSelectedScenario {
	return [coverFlowView getSelectedScenario];
}

- (void)dealloc {
	//[_dictScenarios release];
	[covers release];
	[btnPlay release];
	[btnFreestyle release];
	[btnPrefs release];
	[btnIntro release];
	[btnInfo release];
	[coverFlowViewController release];
    [super dealloc];
}


@end
