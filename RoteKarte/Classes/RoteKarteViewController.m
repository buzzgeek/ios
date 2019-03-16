//
//  RoteKarteViewController.m
//  RoteKarte
//
//  Created by Jeannine Struck on 1/30/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <CFNetwork/CFNetwork.h>
#import "RoteKarteViewController.h"
#import "RoteKarteAppDelegate.h"
#import "ResourceManager.h"

@implementation RoteKarteViewController

@synthesize activeSound;

- (id)init {
	if (self = [super init]) {
		bAudioActive = NO;
		bUp = YES;
		
		CGRect bounds = [[UIScreen mainScreen]applicationFrame];
		bounds.origin.y = 0.0;
		CGRect contentSize = bounds;
		contentSize.size.width = contentSize.size.width * 3;
		
		mainView = [[UIView alloc]initWithFrame:contentSize];
		mainView.backgroundColor = [UIColor blackColor];
		
		yellowView = [[CardView alloc]initWithFrame:bounds];
		yellowView.backgroundColor = [UIColor yellowColor];
		[mainView addSubview:yellowView];
		
		bounds.origin.x = bounds.size.width;
		redView = [[CardView alloc]initWithFrame:bounds];
		redView.backgroundColor = [UIColor redColor];
		[mainView addSubview:redView];
		
		bounds.origin.x = bounds.size.width * 2;
		buttView = [[CardView alloc]initWithFrame:bounds setImage:@"butt"];
//		buttView = [[CardView alloc]initWithFrame:bounds];
		buttView.backgroundColor = [UIColor brownColor];
		[mainView addSubview:buttView];

		UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
		accelerometer.delegate = self;
		
	}
	return self;
}

- (void)loadView {
	CGRect bounds = [[UIScreen mainScreen]applicationFrame];
	CGRect contentBounds = bounds;
	contentBounds.size.width = contentBounds.size.width * 3;
	
	[super loadView];
	
	scrollView = [[UIScrollView alloc] initWithFrame:bounds];
	scrollView.contentSize = contentBounds.size;
	scrollView.maximumZoomScale = 1.0;
	scrollView.minimumZoomScale = 1.0;
	scrollView.pagingEnabled = YES;
	scrollView.delegate = self;
	scrollView.bounces = YES;
	scrollView.alwaysBounceHorizontal = YES;
	scrollView.alwaysBounceVertical = YES;
	
	[scrollView addSubview:mainView];
	
	self.view = scrollView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return mainView;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation == UIInterfaceOrientationPortrait); 
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	RoteKarteAppDelegate *parent = [[UIApplication sharedApplication] delegate];

#ifdef DEBUG_BUZZ
	NSString *stat = [NSString stringWithFormat:@"x:%02.1f y:%02.1f z:%02.1f", acceleration.x, acceleration.y, acceleration.z];
	[yellowView setText:stat];
#endif
	
	if (parent.whistle && !bAudioActive && !bUp) {
		if (acceleration.y < -0.90 ) {
			bAudioActive = YES;
			bUp = YES;
			CGRect bounds = [[UIScreen mainScreen]applicationFrame];
			CGFloat xpos = bounds.size.width * 2;
			if (scrollView.contentOffset.x < xpos) {
				[g_ResManager playSound:@"whistle.caf"];
			} else {
				[g_ResManager playSound:@"fart2.caf"];
			}

			bAudioActive = NO;
		}
	} else if (!bAudioActive && bUp) {
		if (acceleration.y >= -0.10) {
			bUp = NO;
		}
	}
}

- (void)dealloc {
	[buttView release];
	[yellowView release];
	[redView release];
	[mainView release];
	[scrollView release];
    [super dealloc];
}

@end
