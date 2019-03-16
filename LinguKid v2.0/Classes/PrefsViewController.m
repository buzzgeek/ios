    //
//  PrefsViewController.m
//  English4Kids
//
//  Created by Jeannine Struck on 8/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PrefsViewController.h"
#import "English4KidsAppDelegate.h"
#import "ResourceManager.h"

@implementation PrefsViewController

@synthesize	lblDisplay;
@synthesize	lblWords;
@synthesize	lblGrid;
@synthesize	lblVolume;
@synthesize	lblMusic;
@synthesize	lblSound;
@synthesize	sbWords;
@synthesize	sbGrid;
@synthesize	slMusicVolume;
@synthesize	slSoundVolume;
@synthesize btnDone;
@synthesize toolbar;
@synthesize vwDisplay;
@synthesize vwVolume;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];

#ifndef DEBUG
	sbGrid.on = NO;
	sbGrid.hidden = YES;
	lblGrid.hidden = YES;
#endif //DEBUG
	
	
	// load prefs
	[[NSBundle mainBundle] loadNibNamed:@"Prefs" owner:self options:nil];
	English4KidsAppDelegate *delegate = (English4KidsAppDelegate *)[[UIApplication sharedApplication] delegate];
	sbWords.on = delegate.showWords;
	sbGrid.on = delegate.showGrid;
	slMusicVolume.value = delegate.volMusic;
	slSoundVolume.value = delegate.volSound;
	
	// setup localized data
	[lblDisplay setText:NSLocalizedString(@"lblDisplay", @"display label")];
	[lblWords setText:NSLocalizedString(@"lblWords", @"words label")];
	[lblGrid setText:NSLocalizedString(@"lblGrid",@"grid label")];
	[lblVolume setText:NSLocalizedString(@"lblVolume",@"volume label")];
	[lblMusic setText:NSLocalizedString(@"lblMusic",@"music label")];
	[lblSound setText:NSLocalizedString(@"lblSound",@"sound label")];
	
	vwDisplay.frame = CGRectMake([g_ResManager widthPcnt:0.05], [g_ResManager heightPcnt:0.05], [g_ResManager widthPcnt:0.9], [g_ResManager heightPcnt:0.30]);
	vwVolume.frame = CGRectMake([g_ResManager widthPcnt:0.05], [g_ResManager heightPcnt:0.40], [g_ResManager widthPcnt:0.9], [g_ResManager heightPcnt:0.30]);
	lblWords.adjustsFontSizeToFitWidth = YES;
	lblGrid.adjustsFontSizeToFitWidth = YES;
	lblMusic.adjustsFontSizeToFitWidth = YES;
	lblSound.adjustsFontSizeToFitWidth = YES;
	
	CGRect rect;
	lblDisplay.center = CGPointMake([g_ResManager widthPcnt:0.45], [g_ResManager heightPcnt:0.02]);
	lblVolume.center = CGPointMake([g_ResManager widthPcnt:0.45], [g_ResManager heightPcnt:0.02]);
	
	rect = CGRectMake([g_ResManager widthPcnt:0.05], [g_ResManager heightPcnt:0.1], [g_ResManager widthPcnt:0.25], 20.0);
	lblWords.frame = rect;
	lblMusic.frame = rect;
	rect = CGRectMake([g_ResManager widthPcnt:0.05], [g_ResManager heightPcnt:0.1] + 40, [g_ResManager widthPcnt:0.25], 20.0);
	lblGrid.frame = rect;
	lblSound.frame = rect;
	rect = CGRectMake([g_ResManager widthPcnt:0.25], [g_ResManager heightPcnt:0.1], [g_ResManager widthPcnt:0.25], 20.0);
	sbWords.frame = rect;
	rect = CGRectMake([g_ResManager widthPcnt:0.25], [g_ResManager heightPcnt:0.1] + 40, [g_ResManager widthPcnt:0.25], 20.0);
	sbGrid.frame = rect;
	rect = CGRectMake([g_ResManager widthPcnt:0.25], [g_ResManager heightPcnt:0.1], [g_ResManager widthPcnt:0.5], 20.0);
	slMusicVolume.frame = rect;
	rect = CGRectMake([g_ResManager widthPcnt:0.25], [g_ResManager heightPcnt:0.1] + 40, [g_ResManager widthPcnt:0.5], 20.0);
	slSoundVolume.frame = rect;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

#ifndef DEBUG
	sbGrid.on = NO;
	sbGrid.hidden = YES;
	lblGrid.hidden = YES;
#endif //DEBUG
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
	English4KidsAppDelegate *delegate = (English4KidsAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// store the configuration data
	delegate.showWords = sbWords.on;
	delegate.showGrid = sbGrid.on;
	delegate.volMusic = slMusicVolume.value;
	delegate.volSound = slSoundVolume.value;
}

- (IBAction) musicVolChanged {
	English4KidsAppDelegate *delegate = (English4KidsAppDelegate *)[[UIApplication sharedApplication] delegate];
	delegate.volMusic = slMusicVolume.value;	
}

- (IBAction) soundVolChanged {
	English4KidsAppDelegate *delegate = (English4KidsAppDelegate *)[[UIApplication sharedApplication] delegate];
	delegate.volSound = slSoundVolume.value;
}

- (IBAction) goBack {
	English4KidsAppDelegate *delegate = (English4KidsAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// store the configuration data
	delegate.showWords = sbWords.on;
	delegate.showGrid = sbGrid.on;
	delegate.volMusic = slMusicVolume.value;
	delegate.volSound = slSoundVolume.value;
	
	[delegate popController];
	//[delegate doControllerChange:[MainMenueController class]];
}


- (void)dealloc {
	[lblDisplay release];
	[lblWords release];
	[lblGrid release];
	[lblVolume release];
	[lblMusic release];
	[lblSound release];
	[sbWords release];
	[sbGrid release];
	[slMusicVolume release];
	[slSoundVolume release];
	[btnDone release];
	[toolbar release];
	[vwDisplay release];
	[vwVolume release];
	
    [super dealloc];
}


@end
