//
//  GameBarController.m
//  English4Kids
//
//  Created by Jeannine Struck on 9/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameBarController.h"
#import "ResourceManager.h"
#import "GameBar.h"


@implementation GameBarController

- (id) init {
	if ((self = [super init])) {
		GameBar *gameBar = [[GameBar alloc] initWithFrame:CGRectMake(0.0, [g_ResManager heightPcnt:0.8], [g_ResManager widthPcnt:1.0], [g_ResManager heightPcnt:0.2])]; 
		[self.view addSubview:gameBar];
		[gameBar release];
	}
	return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	return [super initWithCoder:aDecoder];
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		
		//self.view.frame = CGRectMake(0.0, [g_ResManager heightPcnt:0.8], [g_ResManager widthPcnt:1.0], [g_ResManager heightPcnt:0.2]);
		GameBar *gameBar = [[GameBar alloc] initWithFrame:CGRectMake(0.0, 0.0, [g_ResManager widthPcnt:1.0], [g_ResManager heightPcnt:0.2])]; 
		[self.view addSubview:gameBar];
		[gameBar release];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.view.frame = CGRectMake(0.0, [g_ResManager heightPcnt:0.8], [g_ResManager widthPcnt:1.0], [g_ResManager heightPcnt:0.2]);
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
}


- (void)dealloc {
    [super dealloc];
}


@end
