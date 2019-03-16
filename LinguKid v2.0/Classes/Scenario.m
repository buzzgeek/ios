//
//  Scenario.m
//  English4Kids
//
//  Created by Jeannine Struck on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "English4KidsAppDelegate.h"
#import "ResourceManager.h"
#import "GridView.h"
#import "Scenario.h"
#import "SceneView.h"
#import "GameBar.h"
#import "GameMemoryController.h"

#define FADE_ANIMATION_DURATION_SECONDS 0.5
#define TIMER_DELAY 0.25

@interface Scenario (private)

- (void) changeToScene:(NSString *)scene;
- (void) setupButtons;
- (void) onGameModeDone;
- (void) onHome:(id)data;
- (void) onPlay:(id)data;
- (void) onBack:(id)data;
- (void) onGameBar:(id)data;
- (void) onGame:(id)data;
- (BOOL) initPlist;

@end

@implementation Scenario

- (id) initWithFrame:(CGRect)frame loadPlist:(NSString *)plist {
	_plist = [plist copy];
    if ((self = [super initWithFrame:frame])) {
		
		[self initPlist];
		// set up the event view
		viewEvents = [[GridView alloc] initWithFrame:frame];
		
		[viewEvents setNotificationDelegate:self forEvent:EVENT_ON_TAP withSelector:@selector(onTap:)];
		[viewEvents setNotificationDelegate:self forEvent:EVENT_ON_DOUBLETAP withSelector:@selector(onDoubleTap:)];
		[self insertSubview:viewEvents atIndex:0];
		
		// set up the scene view
		viewActive = [[SceneView alloc] initWithFrame:frame loadPlist:plist withScene:SCENE_MAIN_SCENE];
		[viewActive setNotificationDelegate:self forEvent:EVENT_ON_GAME_FINISHED withSelector:@selector(onGameModeDone)];
		[self insertSubview:viewActive belowSubview:viewEvents];
		
		// set up the game menu bar
		//viewGameBar = [[GameBar alloc] initWithFrame:CGRectMake(0.0, [g_ResManager heightPcnt:0.95], [g_ResManager widthPcnt:1.0], [g_ResManager heightPcnt:0.2])];
		viewGameBar = [[GameBar alloc] initWithFrame:CGRectMake(0.0, [g_ResManager heightPcnt:0.90], [g_ResManager widthPcnt:1.0], [g_ResManager heightPcnt:0.3])];
		[viewGameBar setNotificationDelegate:self forEvent:EVENT_ON_BTN_HOME withSelector:@selector(onHome:)];
		[viewGameBar setNotificationDelegate:self forEvent:EVENT_ON_BTN_PLAY withSelector:@selector(onPlay:)];
		[viewGameBar setNotificationDelegate:self forEvent:EVENT_ON_BTN_BACK withSelector:@selector(onBack:)];
		[viewGameBar setNotificationDelegate:self forEvent:EVENT_ON_BTN_GAMEBAR withSelector:@selector(onGameBar:)];
		[viewGameBar setNotificationDelegate:self forEvent:EVENT_ON_BTN_GAME withSelector:@selector(onGame:)];
		[viewGameBar setNotificationDelegate:self forEvent:EVENT_ON_TAP withSelector:@selector(onTap:)];
		[viewGameBar setNotificationDelegate:self forEvent:EVENT_ON_DOUBLETAP withSelector:@selector(onDoubleTap:)];
		viewGameBar.hideBack = [viewActive._scene isEqualToString:SCENE_MAIN_SCENE];
		
		[self addSubview:viewGameBar];
		[self setupButtons];
		
	}
	return self;
}

- (BOOL) initPlist {
	NSData		*pData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_plist ofType:@"plist"]];
	NSString	*error;
	NSPropertyListFormat format;
	
	NSDictionary *dicScenario = [NSPropertyListSerialization 
								 propertyListFromData:pData 
								 mutabilityOption:NSPropertyListImmutable 
								 format:&format 
								 errorDescription:&error];
	if (error != nil) {
#ifdef DEBUG_ALL
		NSLog(@"error - %@", error);
#endif
		return NO;
	}
	
	noGameScene = [[dicScenario objectForKey:SENARIO_NO_GAME_SCENE] retain];
	music = [[dicScenario objectForKey:SENARIO_MUSIC] retain];
	
#ifdef DEBUG
	NSLog(@"%@", noGameScene);
#endif
	if (music) {
		[g_ResManager playMusic:music];
	} else {
		[g_ResManager playMusic:@"English4Kids.mp3"];
	}	
	[g_ResManager setMusicVolume:[[g_ResManager getUserData:@"volMusic"] floatValue]];
	
	return YES;
}


- (void) onHome:(id)data {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate popToRootController];
}

- (void) onPlay:(id)data {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	delegate.isGameActive = YES;
	[viewActive startGameModeInSecs:TIMER_DELAY];
	[self setupButtons];
}

- (void) onBack:(id)data {
	[self changeToScene:viewActive._prevScene];
	[viewEvents setText:[NSString stringWithFormat:@"%@", viewActive._prevScene]];
	[self raiseEvent:EVENT_ON_CHANGE_SCENE withObject:viewActive._prevScene];
}

- (void) onGameBar:(id)data {
	[viewActive resetScore];
}

-(void) onGame:(id)data {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	if ([noGameScene length] > 0) {
		[self changeToScene:noGameScene];
		[viewEvents setText:[NSString stringWithFormat:@"%@", noGameScene]];
		[self raiseEvent:EVENT_ON_CHANGE_SCENE withObject:noGameScene];
	} else {
		[delegate pushController:[GameMemoryController class] withNib:@"GameMemoryController" withPlist:_plist];
	}
}

- (void)setupButtons {
	
	BOOL hide = !viewActive.qnaGameAvailable;
	[viewGameBar hideGameButtons:hide];
	
	[self hideButtons];
	viewGameBar.isLandscape = [viewActive._landscape isEqualToString:@"1"];
}

- (void) hideButtons {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	// phase in/out the buttons until the game is done;
	// use some cool animation
	CATransition *anim = [CATransition animation];
	anim.duration = FADE_ANIMATION_DURATION_SECONDS;
	// using the ease in/out timing function
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	anim.type = kCATransitionFade;

	[viewGameBar.layer addAnimation:anim forKey:nil];
	viewGameBar.hidden = delegate.isGameActive || !delegate.isGameMode; 

} 


-(void) processEvent:(NSString *)event withObject:(id)data {
	if ([event isEqualToString:EVENT_ON_TAP]) {
		[self onTap:(UITouch *)data];
	} else 	if ([event isEqualToString:EVENT_ON_TAP]) {
		[self onDoubleTap:(UITouch *)data];
	}
}

-(void) onTap:(UITouch *) touch {
	CGPoint position;
	CGPoint cord;
	if(g_ResManager.isLandscape) {	
		position = [touch locationInView:viewActive];
		CGPoint lsCenter = CGPointMake(viewActive.center.y, viewActive.center.x);
		cord = [self getLandscapeCoordRelToOrigin:lsCenter forPosition:position];
	} else {
		position = [touch locationInView:self];
		cord = [self getCoordRelToOrigin:viewActive.center forPosition:position];
	}

	[viewEvents setText:[NSString stringWithFormat:@"%+i:%+i", (int)cord.x, (int)cord.y]];

	[viewActive onTap:touch];

	if (viewActive._nextScene.length > 0) {
		if ([viewActive._nextScene isEqualToString:@"main"]) {
			English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			[delegate popToRootController];
		} else {
			[self changeToScene:viewActive._nextScene];
			[viewEvents setText:[NSString stringWithFormat:@"%@", viewActive._nextScene]];
			[self raiseEvent:EVENT_ON_CHANGE_SCENE withObject:viewActive._nextScene];
		}
	}
}

-(void) onDoubleTap:(UITouch *) touch {
	CGPoint position;
	CGPoint cord;
	if(g_ResManager.isLandscape) {	
		position = [touch locationInView:viewActive];
		CGPoint lsCenter = CGPointMake(viewActive.center.y, viewActive.center.x);
		cord = [self getLandscapeCoordRelToOrigin:lsCenter forPosition:position];
	} else {
		position = [touch locationInView:self];
		cord = [self getCoordRelToOrigin:viewActive.center forPosition:position];
	}
	
	[viewEvents setText:[NSString stringWithFormat:@"%+i:%+i", (int)cord.x, (int)cord.y]];

	[viewActive onDoubleTap:touch];
	
	if (viewActive._nextScene.length > 0) {
		if ([viewActive._nextScene isEqualToString:@"main"]) {
			English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			[delegate popToRootController];
		} else {
			[self changeToScene:viewActive._nextScene];
			[viewEvents setText:[NSString stringWithFormat:@"%@", viewActive._nextScene]];
			[self raiseEvent:EVENT_ON_CHANGE_SCENE withObject:viewActive._nextScene];
		}
	}
}

- (void) changeToScene:(NSString *)scene {
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
	CGRect bounds = [[UIScreen mainScreen]applicationFrame];
	bounds.origin.y = 0.0;
	CGRect contentSize = bounds;
	
	viewNext = [[SceneView alloc] initWithFrame:contentSize loadPlist:_plist withScene:scene ];
	[viewNext setNotificationDelegate:self forEvent:EVENT_ON_GAME_FINISHED withSelector:@selector(onGameModeDone)];
	
	if (viewNext.isValid) {
	
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:YES]; //does nothing without this line.

		[self insertSubview:viewNext aboveSubview:viewActive];
		
		[UIView commitAnimations];

		[viewActive removeFromSuperview];
	} else {
		[viewNext dealloc];
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag context:(id)cont
{
	[viewActive release];
	viewActive = viewNext;
	[self setupButtons];
	viewGameBar.hideBack = [viewActive._scene isEqualToString:SCENE_MAIN_SCENE];
	[viewGameBar startAnimationIsHidden:YES];

	[viewEvents setNeedsDisplay];
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void) onGameModeDone {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	delegate.isGameActive = NO;
	[self setupButtons];
}

- (void) dealloc {
	[music release];
	[noGameScene release];
	[g_ResManager stopSounds];
	[viewActive release];
	[viewEvents release];
	[_plist release];
	[super dealloc];
}
@end
