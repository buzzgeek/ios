//
//  IntroViewContoller.m
//  English4Kids
//
//  Created by Jeannine Struck on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IntroViewController.h"
#import "IntroView.h"
#import "English4KidsAppDelegate.h"

@implementation IntroViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		IntroView *introView = (IntroView *)self.view;
		if(introView) {
			[introView loadDocument:@"intro.html"];
		}
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
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction)onDone {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate popController];	
}

- (void)dealloc {
    [super dealloc];
}


@end
