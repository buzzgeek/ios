//
//  AltMainMenuController.h
//  English4Kids
//
//  Created by Jeannine Struck on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CovertFlowViewController.h"

@interface AltMainMenuController : UIViewController {
	UIButton					*btnPlay;
	UIButton					*btnFreestyle;
	UIButton					*btnPrefs;
	UIButton					*btnIntro;
	UIButton					*btnInfo;

	CovertFlowViewController	*coverFlowViewController;
	CFView						*coverFlowView;

	NSMutableDictionary			*covers;

}

@property (nonatomic, retain) IBOutlet UIButton	*btnPlay;
@property (nonatomic, retain) IBOutlet UIButton	*btnFreestyle;
@property (nonatomic, retain) IBOutlet UIButton	*btnPrefs;
@property (nonatomic, retain) IBOutlet UIButton	*btnIntro;
@property (nonatomic, retain) IBOutlet UIButton	*btnInfo;
@property (nonatomic, retain) IBOutlet CovertFlowViewController *coverFlowViewController;

- (IBAction) onButton:(id)sender;
- (NSString *)getSelectedScenario;

@end
