//
//  GameBar.h
//  English4Kids
//
//  Created by Jeannine Struck on 9/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"


@interface GameBar : BaseView {
	UIImage		*imgUp;
	UIImage		*imgDown;
	UIButton	*btnShow;		// when pressed the game bar menu will slide up
	UIButton	*btnBack;		// when pressed the previous screen will appear
	UIButton	*btnHome;		// when pressed the main menu will appear
	UIButton	*btnPlay;		// if game mode play will be initially visible 
	UIButton	*btnGame;		// when pressed a game should start
	BOOL		hideBack;
	BOOL		showBar;
	BOOL		isLandscape;
}

@property (readwrite) BOOL hideBack;
@property (readwrite) BOOL isLandscape;


- (void) startAnimationIsHidden:(BOOL)hide;
- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void) hideGameButtons:(BOOL)hide;

@end
