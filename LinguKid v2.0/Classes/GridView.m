//
//  gridView.m
//  English4Kids
//
//  Created by Jeannine Struck on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GridView.h"
#import "TargetView.h"
#import "HiliteView.h"
#import "ResourceManager.h"
#import "English4KidsAppDelegate.h"

@interface GridView (private)

- (void) fade;
- (void) tapAtPosition:(CGPoint)_pos;
- (void) startAnimation:(CGPoint)_pos;

@end

@implementation GridView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
#ifdef DEBUG
		// create the hiliter
		hiliteView = [[HiliteView alloc]initWithFrame:frame];
		hiliteView.frame = CGRectMake(0.0, 0.0, g_ResManager.widthGrid, g_ResManager.heightGrid);
		[self.layer addSublayer: hiliteView.layer];
		hiliteView.hidden = YES;
		[hiliteView setNotificationDelegate:self forEvent:EVENT_ON_TAP withSelector:@selector(onTap:)];
		[hiliteView setNotificationDelegate:self forEvent:EVENT_ON_DOUBLETAP withSelector:@selector(onDoubleTap:)];
		
		// create the 'fadenkreuz'
		tgtView = [[TargetView alloc]initWithFrame:CGRectMake(0.0, 0.0, g_ResManager.widthGrid, g_ResManager.heightGrid)];
		[self.layer addSublayer: tgtView.layer];
		tgtView.hidden = YES;
		[tgtView setNotificationDelegate:self forEvent:EVENT_ON_TAP withSelector:@selector(onTap:)];
		[tgtView setNotificationDelegate:self forEvent:EVENT_ON_DOUBLETAP withSelector:@selector(onDoubleTap:)];
		
		// create the text view
		txtView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 64.0, 32.0)];
		txtView.backgroundColor = [UIColor whiteColor];
		txtView.textColor = [UIColor blackColor];
		txtView.font = [UIFont fontWithName:@"arial" size:14.0];
		txtView.textAlignment = UITextAlignmentCenter;
		txtView.editable = NO;
		[self.layer addSublayer: txtView.layer];
#endif
    }
    return self;
}


#ifdef DEBUG
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

	if(delegate.showGrid){
		CGContextRef myContext = UIGraphicsGetCurrentContext();

		CGContextBeginPath(myContext);
		CGContextSetRGBStrokeColor(myContext, 0.5, 1.0, 0.3, 0.8);	

		CGFloat x = g_ResManager.gridXOffset;
		CGFloat maxX = g_ResManager.bounds.size.width / g_ResManager.widthGrid;
		
	
		for (int r = 0; r < maxX; ++r) {
			CGContextMoveToPoint(myContext, x, 0.0);
			CGContextAddLineToPoint(myContext, x, g_ResManager.bounds.size.height);
			x += g_ResManager.widthGrid;
		}

		CGFloat maxY = g_ResManager.bounds.size.height / g_ResManager.heightGrid;
		CGFloat y = g_ResManager.gridYOffset;
		for (int c = 0; c < maxY; ++c) {
			CGContextMoveToPoint(myContext, 0.0, y);
			CGContextAddLineToPoint(myContext, g_ResManager.bounds.size.width, y);
			y +=  g_ResManager.heightGrid;
		}
		CGContextStrokePath(myContext);
	}
}
#endif

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
#ifdef DEBUG	
	[self tapAtPosition:[touch locationInView:self]];
#endif	
	if ([touch tapCount] == 1) {
		[self raiseEvent:EVENT_ON_TAP withObject:touch];
	} else {
		[self raiseEvent:EVENT_ON_DOUBLETAP withObject:touch];
	}
}

#ifdef DEBUG
- (void)tapAtPosition:(CGPoint)_pos {
	
	[self setPosition:_pos];

	// show target and highlight view and use animation	
	tgtView.center = _pos;
	tgtView.hidden = NO;
	hiliteView.center = pos;
	hiliteView.hidden = NO;
	
	[self startAnimation: _pos];	
}

#define GROW_ANIMATION_DURATION_SECONDS 0.15
- (void)startAnimation:(CGPoint)_pos {
	NSValue *touchPointValue = [NSValue valueWithCGPoint:_pos];
	[UIView beginAnimations:nil context:touchPointValue];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
 	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	hiliteView.transform = CGAffineTransformMakeScale(1.1, 1.1);;
	tgtView.transform = CGAffineTransformMakeScale(1.1, 1.1);;
	[UIView commitAnimations];
}

#define SHRINK_ANIMATION_DURATION_SECONDS 0.15
- (void)moveAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(shrinkAnimationDidStop:finished:context:)];
	hiliteView.transform = CGAffineTransformMakeScale(0.9, 0.9);
	tgtView.transform = CGAffineTransformMakeScale(0.9, 0.9);
	NSValue *touchPointValue = (NSValue *)context;
	[touchPointValue release];
	[UIView commitAnimations];
}

#define MOVE_ANIMATION_DURATION_SECONDS 0.15
- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:@"center" context:NULL];
	[UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(moveAnimationDidStop:finished:context:)];
	[UIView commitAnimations];
}

- (void)shrinkAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self fade];
}

#define FADE_ANIMATION_DURATION_SECONDS 0.15
- (void)fade {

	CATransition *anim = [CATransition animation];
	anim.duration = FADE_ANIMATION_DURATION_SECONDS;
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	anim.type = kCATransitionFade;
	
	[hiliteView.layer addAnimation:anim forKey:nil];
	[tgtView.layer addAnimation:anim forKey:nil];

	hiliteView.hidden = YES;	
	tgtView.hidden = YES;	
}
#endif

- (void) onTap:(UITouch *) touch {
	// propagate tap event
	[self raiseEvent:EVENT_ON_TAP withObject:touch];
}

- (void) onDoubleTap:(UITouch *) touch {
	// propagate tap event
	[self raiseEvent:EVENT_ON_DOUBLETAP withObject:touch];
}

- (void) setText:(NSString *)txt {
	txtView.text = txt;
}

- (void)dealloc {
	[txtView release];
	[tgtView release];
	[hiliteView release];
    [super dealloc];
}

@end
