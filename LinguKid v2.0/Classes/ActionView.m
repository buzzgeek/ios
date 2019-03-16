//
//  ActionView.m
//  English4Kids
//
//  Created by Jeannine Struck on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActionView.h"
#import <QuartzCore/QuartzCore.h>
#import "ResourceManager.h"
#import "English4KidsAppDelegate.h"

@interface ActionView (private)

//- (void) fade:(BOOL) hide;

@end

@implementation ActionView
@synthesize snd;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		img = nil;
		snd = nil;
    }
    return self;
}


- (void) loadImage:(NSString *)image {
	if (img != nil) {
		[img release];
	}
	img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:image ofType:@"png"]];
	[self setImage:img];
}

- (void) loadUImage:(UIImage *)image {
	if (img != nil) {
		[img release];
	}
	img = [[UIImage alloc] initWithCGImage:[image CGImage]];
	[self setImage:img];
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// UITouch *touch = [touches anyObject];
	// TODO: propagate
	// [self handleEvent:EVENT_ON_TAP withObject:touch];
}


- (void) startAnimationIsHidden:(BOOL)hide {
#define FLIP_ANIMATION_DURATION_SECONDS 0.75
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:FLIP_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES]; //does nothing without this line.
 	//[UIView setAnimationWillStartSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView commitAnimations];
	self.hidden = hide;
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	//TODO: this is neva called ?
	if (self.hidden) {
		return;
	}
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	if(snd != nil && [snd length] > 0)
		[g_ResManager playSound:snd setVolume:delegate.volSound];
}

/*
- (void) startAnimationIsHidden:(BOOL)hide {
#define GROW_ANIMATION_DURATION_SECONDS 0.25
	
	[UIView beginAnimations:nil context:[NSNumber numberWithBool:hide]];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
 	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	self.transform = CGAffineTransformMakeScale(1.1, 1.1);;
	[UIView commitAnimations];
}


- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	
#define SHRINK_ANIMATION_DURATION_SECONDS 0.25
	
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(shrinkAnimationDidStop:finished:context:)];
	self.transform = CGAffineTransformMakeScale(1.0, 1.0);
	[UIView commitAnimations];
}

- (void)shrinkAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES]; //does nothing without this line.
	[UIView commitAnimations];

	NSNumber *numHide = (NSNumber *)context;
//	TODO: kill this code and determine if shrink & grow is still necessary!
//	[self fade:[numHide boolValue]];
//	[numHide release];

	self.hidden = [numHide boolValue];
}

#define FADE_ANIMATION_DURATION_SECONDS 1.0
- (void)fade:(BOOL) hide {
	CATransition *anim = [CATransition animation];
	anim.duration = FADE_ANIMATION_DURATION_SECONDS;
	// using the ease in/out timing function
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	anim.type = kCATransitionFade;
	
	[self.layer addAnimation:anim forKey:nil];
	self.hidden = hide;

	
}
*/

- (void) dealloc {
	if(img != nil)
		[img release];
	if(snd != nil)
		[snd release];
    [super dealloc];
}


@end
