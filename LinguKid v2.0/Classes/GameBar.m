//
//  GameBar.m
//  English4Kids
//
//  Created by Jeannine Struck on 9/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GameBar.h"
#import "ResourceManager.h"

@interface GameBar (private)

- (void) startAnimationIsHidden:(BOOL)hide;
- (void)onButton:(id)sender event:(id)event;

@end


@implementation GameBar

@synthesize hideBack;
@synthesize isLandscape;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// set up the home & back button
		// note: button are not supposed to be released, coz they will be autoreleased (if alloc would have been used, than it would have been necessary )
		btnShow = [UIButton buttonWithType:UIButtonTypeCustom];
		imgUp = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up" ofType:@"png"]];
		imgDown = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down" ofType:@"png"]];
//		imgUp = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:SCENE_TAG_BACK ofType:@"png"]];
//		imgDown = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:SCENE_TAG_BACK ofType:@"png"]];

		[btnShow setImage:imgUp forState:UIControlStateNormal];
		[btnShow addTarget:self action:@selector(onButton:event:) forControlEvents:UIControlEventTouchUpInside];
		btnShow.hidden = NO;

		btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
		UIImage *imgBack = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:SCENE_TAG_BACK ofType:@"png"]] autorelease];
		[btnBack setImage:imgBack forState:UIControlStateNormal];
		[btnBack addTarget:self action:@selector(onButton:event:) forControlEvents:UIControlEventTouchUpInside];
		btnBack.hidden = NO;
		
		btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
		UIImage *imgHome = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"exit" ofType:@"png"]] autorelease];
		[btnHome setImage:imgHome forState:UIControlStateNormal];
		[btnHome addTarget:self action:@selector(onButton:event:) forControlEvents:UIControlEventTouchUpInside];
		btnHome.hidden = NO;
		
		btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
		UIImage *imgPlay = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qna64" ofType:@"png"]]autorelease];
		[btnPlay setImage:imgPlay forState:UIControlStateNormal];
		[btnPlay addTarget:self action:@selector(onButton:event:) forControlEvents:UIControlEventTouchUpInside];
		btnPlay.hidden = NO;
		
		btnGame = [UIButton buttonWithType:UIButtonTypeCustom];
		UIImage *imgGame = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gameMem64" ofType:@"png"]]autorelease];
		[btnGame setImage:imgGame forState:UIControlStateNormal];
		[btnGame addTarget:self action:@selector(onButton:event:) forControlEvents:UIControlEventTouchUpInside];
		btnGame.hidden = NO;

		btnShow.frame = CGRectMake(0.0, 0.0, [g_ResManager heightPcnt:0.1], [g_ResManager heightPcnt:0.1]);
		btnBack.frame = CGRectMake(0.0, 0.0, [g_ResManager heightPcnt:0.1], [g_ResManager heightPcnt:0.1]);
		btnHome.frame = CGRectMake(0.0, 0.0, [g_ResManager heightPcnt:0.1], [g_ResManager heightPcnt:0.1]);
		btnPlay.frame = CGRectMake(0.0, 0.0, [g_ResManager heightPcnt:0.1], [g_ResManager heightPcnt:0.1]);
		btnGame.frame = CGRectMake(0.0, 0.0, [g_ResManager heightPcnt:0.1], [g_ResManager heightPcnt:0.1]);
		
		[self addSubview:btnShow];
		[self addSubview:btnBack];
		[self addSubview:btnHome];
		[self addSubview:btnPlay];
		[self addSubview:btnGame];
		showBar = NO;
    }
    return self;
}

- (void)onButton:(id)sender event:(id)event
{
	if ([btnBack isEqual:sender]) {
		[self raiseEvent:EVENT_ON_BTN_BACK withObject:nil];
	} else if ([btnHome isEqual:sender]) {
		[self raiseEvent:EVENT_ON_BTN_HOME withObject:nil];
	} else if ([btnPlay isEqual:sender]) {
		[self raiseEvent:EVENT_ON_BTN_PLAY withObject:nil];
	} else if ([btnShow isEqual:sender]) {
		[self startAnimationIsHidden:showBar];
		[self raiseEvent:EVENT_ON_BTN_GAMEBAR withObject:nil];
	} else if ([btnGame isEqual:sender]) {
		[self startAnimationIsHidden:showBar];
		[self raiseEvent:EVENT_ON_BTN_GAME withObject:nil];
	}
}

- (void)setHideBack:(BOOL)hide {
	hideBack = hide;
	btnBack.hidden = hide;
}

- (void)setIsLandscape:(BOOL)val  {
	isLandscape = val;
	if (isLandscape) {
		btnShow.center = CGPointMake([g_ResManager widthPcnt:0.1],[g_ResManager heightPcnt:0.05]);
		btnHome.center = CGPointMake([g_ResManager widthPcnt:0.1],[g_ResManager heightPcnt:0.15]);
		btnPlay.center = CGPointMake([g_ResManager widthPcnt:0.36],[g_ResManager heightPcnt:0.15]);
		btnGame.center = CGPointMake([g_ResManager widthPcnt:0.63], [g_ResManager heightPcnt:0.15]);
		btnBack.center = CGPointMake([g_ResManager widthPcnt:0.9],[g_ResManager heightPcnt:0.15]);
		[btnShow setTransform:CGAffineTransformMakeRotation(1.57)];
		[btnHome setTransform:CGAffineTransformMakeRotation(1.57)];
		[btnBack setTransform:CGAffineTransformMakeRotation(1.57)];
		[btnPlay setTransform:CGAffineTransformMakeRotation(1.57)];
		[btnGame setTransform:CGAffineTransformMakeRotation(1.57)];
	} else {
		btnShow.center = CGPointMake([g_ResManager widthPcnt:0.9], [g_ResManager heightPcnt:0.05]);
		btnHome.center = CGPointMake([g_ResManager widthPcnt:0.1], [g_ResManager heightPcnt:0.15]);
		btnPlay.center = CGPointMake([g_ResManager widthPcnt:0.36], [g_ResManager heightPcnt:0.15]);
		btnGame.center = CGPointMake([g_ResManager widthPcnt:0.63], [g_ResManager heightPcnt:0.15]);
		btnBack.center = CGPointMake([g_ResManager widthPcnt:0.9], [g_ResManager heightPcnt:0.15]);
		[btnShow setTransform:CGAffineTransformIdentity];
		[btnHome setTransform:CGAffineTransformIdentity];
		[btnBack setTransform:CGAffineTransformIdentity];
		[btnPlay setTransform:CGAffineTransformIdentity];
		[btnGame setTransform:CGAffineTransformIdentity];
	}
}

- (void) startAnimationIsHidden:(BOOL)hide {
#define FLIP_ANIMATION_DURATION_SECONDS 0.25

	[UIView beginAnimations:nil context:@"center"];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:FLIP_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	if (hide) {
		self.center = CGPointMake([g_ResManager widthPcnt:0.5], [g_ResManager heightPcnt:1.05]);
		[btnShow setImage:imgUp forState:UIControlStateNormal];
	} else {
		self.center = CGPointMake([g_ResManager widthPcnt:0.5], [g_ResManager heightPcnt:0.95]);
		[btnShow setImage:imgDown forState:UIControlStateNormal];
	}
	[UIView commitAnimations];
	
	showBar = !hide;
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	if (self.hidden) {
		return;
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	if ([touch tapCount] == 1) {
		[self raiseEvent:EVENT_ON_TAP withObject:touch];
	} else {
		[self raiseEvent:EVENT_ON_DOUBLETAP withObject:touch];
	}
}

- (void) hideGameButtons:(BOOL)hide {
	btnPlay.hidden = hide;
	btnGame.hidden = hide;
} 

/*4
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	return;
    // Drawing code
}
*/

- (void)dealloc {
	[imgUp dealloc];
	[imgDown dealloc];
    [super dealloc];
}


@end
