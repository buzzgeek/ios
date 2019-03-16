//
//  PrefsViewController.h
//  English4Kids
//
//  Created by Jeannine Struck on 8/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PrefsViewController : UIViewController {
	UILabel			*lblDisplay;
	UILabel			*lblWords;
	UILabel			*lblGrid;
	UILabel			*lblVolume;
	UILabel			*lblMusic;
	UILabel			*lblSound;
	
	UISwitch		*sbWords;
	UISwitch		*sbGrid;
	UISlider		*slMusicVolume;
	UISlider		*slSoundVolume;

	UIToolbar		*toolbar;
	UIBarButtonItem	*btnDone;
	
	UIView			*vwDisplay;
	UIView			*vwVolume;
}

@property (nonatomic, retain) IBOutlet UILabel *lblDisplay;
@property (nonatomic, retain) IBOutlet UILabel *lblWords;
@property (nonatomic, retain) IBOutlet UILabel *lblGrid;
@property (nonatomic, retain) IBOutlet UILabel *lblVolume;
@property (nonatomic, retain) IBOutlet UILabel *lblMusic;
@property (nonatomic, retain) IBOutlet UILabel	*lblSound;

@property (nonatomic, retain) IBOutlet UISwitch	*sbWords;
@property (nonatomic, retain) IBOutlet UISwitch	*sbGrid;
@property (nonatomic, retain) IBOutlet UISlider	*slMusicVolume;
@property (nonatomic, retain) IBOutlet UISlider	*slSoundVolume;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnDone;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) IBOutlet UIView *vwDisplay;
@property (nonatomic, retain) IBOutlet UIView *vwVolume;

- (IBAction) goBack;
- (IBAction) musicVolChanged;
- (IBAction) soundVolChanged;

@end
