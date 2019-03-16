//
//  MemoryMenuController.m
//  LinguKid
//
//  Created by Jeannine Struck on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MemoryMenuController.h"
#import "English4KidsAppDelegate.h"



@implementation MemoryMenuController

@synthesize delegate;
@synthesize btnOnePlayer;
@synthesize btnTwoPlayers;
@synthesize btnBack;
@synthesize background;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		//
    }
    return self;
}
*/
- (void)dealloc {
	[btnOnePlayer release];
	[btnTwoPlayers release];
	[btnBack release];
	[background release];
    [super dealloc];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) onButton:(id)sender {
	int	numOfPlayers = 0;

	if(delegate) {
		if ([btnOnePlayer isEqual:sender]) {
			numOfPlayers = 1;	
		} else if ([btnTwoPlayers isEqual:sender]) {
			numOfPlayers = 2;
		} else {
			numOfPlayers = 0;
		}
		[delegate memoryMenuController:self selectedNumberOfPlayers:numOfPlayers];
	}
	[self dismissModalViewControllerAnimated:YES];
}

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



@end
