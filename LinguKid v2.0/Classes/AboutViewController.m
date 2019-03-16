//
//  AboutViewController.m
//  English4Kids
//
//  Created by Jeannine Struck on 8/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutView.h"
#import "English4KidsAppDelegate.h"
#import "ResourceManager.h"


@interface AboutViewController (private)

@end

@implementation AboutViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		AboutView *aboutView = (AboutView *)self.view;
		if (aboutView) {
			[aboutView loadDocument:@"about.html"];
		}
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	AboutView *aboutView = (AboutView *)self.view;
	
	[aboutView.lblAbout setText:NSLocalizedString(@"lblAbout",@"about label")];
	aboutView.btnDone.hidden = YES;
	aboutView.tvwAbout.hidden = YES;

	//aboutView.webAbout.frame = CGRectMake([g_ResManager widthPcnt:0.05], [g_ResManager heightPcnt:0.1], [g_ResManager widthPcnt:1.0], [g_ResManager heightPcnt:0.8]);
	aboutView.webAbout.frame = CGRectMake(0.0, [g_ResManager heightPcnt:0.1], [g_ResManager widthPcnt:1.0], [g_ResManager heightPcnt:0.8]);
	aboutView.lblAbout.center = CGPointMake([g_ResManager widthPcnt:0.5], [g_ResManager heightPcnt:0.05]);
	
	//tvwAbout.frame = CGRectMake([g_ResManager widthPcnt:0.05], [g_ResManager heightPcnt:0.1], [g_ResManager widthPcnt:0.9], [g_ResManager heightPcnt:0.8]);
	//btnDone.center = CGPointMake([g_ResManager widthPcnt:0.5], [g_ResManager heightPcnt:0.95]);
	//[tvwAbout setText:NSLocalizedString(@"tvwAbout",@"the about text")];
	//[btnDone setTitle:NSLocalizedString(@"btnDone", @"done button") forState:UIControlStateNormal];
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

- (IBAction) onDone {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate popController];	
};

@end
