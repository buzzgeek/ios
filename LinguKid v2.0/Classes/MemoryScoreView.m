//
//  MemoryScoreView.m
//  LinguKid
//
//  Created by Jeannine Struck on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MemoryScoreView.h"
#import "ResourceManager.h"

@interface MemoryScoreView (private)

- (void) createBackView;
- (void) createFrontView;

@end


@implementation MemoryScoreView
@synthesize score;
@synthesize textColor;
@synthesize active;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if((self = [super initWithCoder:aDecoder])) {
		showBack = NO;
		score = 0;
		active = NO;
		textColor = [UIColor blueColor];
		//self.backgroundColor = [UIColor yellowColor];
		[self createFrontView];
		[self createBackView];
		frontView.text = [NSString stringWithFormat:@"%i", score];
		[self addSubview:frontView];
	}
	return self;	
}
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		showBack = NO;
		score = 0;
		textColor = [UIColor blueColor];
		[self createFrontView];
		frontView.text = [NSString stringWithFormat:@"%i", score];
		[self addSubview:frontView];
    }
    return self;
}

- (void)dealloc {
	[backView release];
	[frontView release];
    [super dealloc];
}

- (void)setActive:(BOOL)value {
	active = value;
	[self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)color {
	textColor = color;
	if (frontView) {
		frontView.textColor = color;
	}
	if (backView) {
		frontView.textColor = color;
	}
}

- (void)setScore:(int)value {
	if (value == score) {
		return;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES]; //does nothing without this line.
	
	score = value;
	
	if (!showBack) {
		backView.hidden = YES;
		frontView.hidden = NO;
		frontView.text = [NSString stringWithFormat:@"%i", score];
		frontView.textColor = textColor;
		[self insertSubview:frontView aboveSubview:backView];
	} else {
		frontView.hidden = YES;
		backView.hidden = NO;
		backView.text = [NSString stringWithFormat:@"%i", score];
		backView.textColor = textColor;
		[self insertSubview:backView aboveSubview:frontView];
	}
	
	[UIView commitAnimations];
}

- (void) animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag context:(id)cont
{
	if(showBack){
		[frontView removeFromSuperview];
	} else {
		[backView removeFromSuperview];
	}

	showBack = !showBack;
}

- (void) createBackView
{
	if (backView) {
		return;
	}
	CGRect rect = CGRectMake(0.0, 
							 0.0, 
							self.frame.size.width, 
							self.frame.size.height);
	
	backView = [[UITextView alloc] initWithFrame:rect];
	backView.editable = NO;
	backView.scrollEnabled = NO;
	backView.textColor = self.textColor;
	backView.textAlignment = UITextAlignmentCenter;
	backView.backgroundColor = [UIColor clearColor];
	backView.font = [backView.font fontWithSize:[g_ResManager heightPcnt:SCORE_FONT_SIZE]];
	//backView.center = CGPointMake(rect.size.width * 0.5, rect.size.height *.5);
}

- (void) createFrontView
{
	if (frontView) {
		return;
	}
	CGRect rect = CGRectMake(0.0, 
							 0.0, 
							 self.frame.size.width, 
							 self.frame.size.height);
	
	frontView = [[UITextView alloc] initWithFrame:rect];
	frontView.editable = NO;
	frontView.scrollEnabled = NO;
	frontView.textColor = self.textColor;
	frontView.textAlignment = UITextAlignmentCenter;
	frontView.backgroundColor = [UIColor clearColor];
	frontView.font = [frontView.font fontWithSize:[g_ResManager heightPcnt:SCORE_FONT_SIZE]];
	//frontView.center = CGPointMake(rect.size.width * 0.5, rect.size.height *.5);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	if (!active) {
		return;
	}
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	
	CGContextBeginPath(myContext);
	CGContextSetRGBStrokeColor(myContext, 0.0, 0.42, 0.42, 1.0);	
//	CGContextStrokeEllipseInRect(myContext, rect);
	CGContextStrokeRect(myContext, rect);
}



@end
