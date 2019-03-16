//
//  ActionLabel.m
//  English4Kids
//
//  Created by Jeannine Struck on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActionLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface ActionLabel (private)

- (void) fade;

@end


@implementation ActionLabel

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.textColor = [UIColor blueColor];
		count = 0;
    }
    return self;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// UITouch *touch = [touches anyObject];
	// TODO: propagate
	// [self handleEvent:EVENT_ON_TAP withObject:touch];
}


- (void) startAnimation {
	if(count < 0){
		count=0;
	}

	++count;
#define GROW_ANIMATION_DURATION_SECONDS 0.5
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
 	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	self.transform = CGAffineTransformMakeScale(1.1, 1.1);;
	[UIView commitAnimations];
}


- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	
#define SHRINK_ANIMATION_DURATION_SECONDS 0.25
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(shrinkAnimationDidStop:finished:context:)];
	self.transform = CGAffineTransformMakeScale(1.0, 1.0);
	[UIView commitAnimations];
	
}

- (void)shrinkAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self fade];
}

#define FADE_ANIMATION_DURATION_SECONDS 2.0
- (void)fade {
	
	CATransition *anim = [CATransition animation];
	anim.duration = FADE_ANIMATION_DURATION_SECONDS;
	// using the ease in/out timing function
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	anim.type = kCATransitionFade;
	
	[self.layer addAnimation:anim forKey:nil];
	--count;
	if(count <= 0){
		self.hidden = YES;
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
