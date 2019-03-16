//
//  MemoryTileView.m
//  LinguKid
//
//  Created by Jeannine Struck on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MemoryTileView.h"
#import "ResourceManager.h"

@interface MemoryTileView (private)

- (void) createBackView;
- (void) createFrontView;
- (void) resetDeleayed:(NSTimer*)timer;

@end

@implementation MemoryTileView

@synthesize frontImage;
@synthesize backImage;
@synthesize sound;
@synthesize tapSound;
@synthesize word;
@synthesize showBack;
@synthesize active;
@synthesize coords;
@synthesize pickedByAI;
@synthesize outOfGame;

- (id)initWithFrame:(CGRect)frame withBackImage:(NSString *)backImg withFrontImage:(NSString *)frontImg
{
	if ((self = [super initWithFrame:frame])) {
		_frame = frame;
		frontView = nil;
		backView = nil;
		sound = nil;
		tapSound = nil;
		active = YES;
		pickedByAI = NO;
		outOfGame = NO;
		showBack = NO;
		
		if (!frontImg || ![frontImg length]) {
			frontImage = [[NSString stringWithString:MEMTILE_DEF_FRONT_IMG] retain];
		} else {
			frontImage = [[NSString stringWithString:frontImg] retain];
		}
		
		if (!backImg || ![backImg length]) {
			backImage = [[NSString stringWithString:MEMTILE_DEF_FRONT_IMG] retain];
		} else {
			backImage = [[NSString stringWithString:backImg] retain];
		}
		
#ifdef DEBUG
		NSLog(@"image: %@", frontImage); 
#endif
		
		[self createBackView];
		[self addSubview:backView];
	}
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		_frame = frame;
		frontView = nil;
		backView = nil;
		sound = nil;
		tapSound = nil;
		active = YES;
		pickedByAI = NO;
		outOfGame = NO;
		showBack = NO;

		frontImage = [NSString stringWithString:MEMTILE_DEF_FRONT_IMG];
		backImage = [NSString stringWithString:MEMTILE_DEF_BACK_IMG];

		[self createBackView];
		[self addSubview:backView];
	}
    return self;
}

- (void)dealloc {
	if (showBack && backView) {
		[backView release];
	} else if (frontView) {
		[frontView release];
	}
	[sound release];
	[tapSound release];
	[frontImage release];
	[backImage release];
    [super dealloc];
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];

	if(flipping) {
		return;
	}
	
	[self raiseEvent:EVENT_TILE_TAP withObject:self];

	if (!active) {
		active = YES;
		return;
	}

	if ([touch tapCount] >= 1) {
		self.pickedByAI = NO;
		flipping = YES;
		[self flip: NO];
	}
}

- (void) createBackView
{
	if (backView) {
		return;
	}
	UIImage *back = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:backImage ofType:@"png"]];
	backView = [[UIImageView alloc] initWithFrame:_frame];
	[backView setImage:back];
	[back release];
}

- (void) createFrontView
{
	if (frontView) {
		return;
	}
	
#ifdef DEBUG
	NSLog(@"image: %@", frontImage); 
#endif
	
	UIImage *front = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:frontImage ofType:@"png"]];
	frontView = [[UIImageView alloc] initWithFrame:_frame];
	[frontView setImage:front];
	[front release];
}

- (void) resetInTimeInterval:(NSTimeInterval)ti {
	[NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(resetDeleayed:) userInfo:nil repeats:NO];
}

- (void) resetDeleayed:(NSTimer*)timer {
	[self reset];
}


- (void) flip:(BOOL)force
{
	if (!force) {
		[self raiseEvent:EVENT_TILE_FLIP withObject:self];
	}
	
	if (!active) {
		active = YES;
		return;
	}
	
	flipping = YES;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES]; //does nothing without this line.
	
	if (!showBack) {
		[backView removeFromSuperview];
		[self createFrontView];
		[self addSubview:frontView];
	} else {
		[frontView removeFromSuperview];
		[self createBackView];
		[self addSubview:backView];
	}

	[UIView commitAnimations];
	if(tapSound) {
		[g_ResManager playSound:tapSound];
	}
}

- (void) animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag context:(id)cont
{
	if (showBack) {
		[frontView release];
		frontView = NULL;
	} else {
		[backView release];
		backView = NULL;
	}
	showBack = !showBack;
	flipping = NO;
}

- (void) startAnimationIsHidden:(BOOL)hide {
#define FLIP_ANIMATION_DURATION_SECONDS 0.75
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:FLIP_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES]; //does nothing without this line.
	//[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView commitAnimations];
	self.hidden = hide;
}

- (void) reset {
	self.hidden = NO;
	self.active = YES;
	self.pickedByAI = NO;
	self.outOfGame = NO;
	if (self.showBack) {
		[self flip:YES];
	}
}

#define FADE_ANIMATION_DURATION_SECONDS 0.5
- (void)fade {
	
	CATransition *anim = [CATransition animation];
	anim.duration = FADE_ANIMATION_DURATION_SECONDS;
	// using the ease in/out timing function
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	anim.type = kCATransitionFade;
	
	[self.layer addAnimation:anim forKey:nil];
	self.hidden = YES;
	self.outOfGame = YES;
}


@end
