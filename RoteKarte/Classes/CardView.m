//
//  cardView.m
//  Ampelkarte
//
//  Created by Jeannine Struck on 1/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CFNetwork/CFNetwork.h>
#import <QuartzCore/QuartzCore.h>
#import "cardView.h"
#import "RoteKarteAppDelegate.h"

@interface CardView (private)

- (void) flip;
- (void) fade;

@end


@implementation CardView

- (id)initWithFrame:(CGRect) frame setImage:(NSString *)img {
	if (self = [self initWithFrame:frame]) {
		background = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:img ofType:@"png"]];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
		for (int i = 0; i<4; ++i) {
			NSString *img = [NSString stringWithFormat:@"corner%d", i + 1];
			cornerImg[i] = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:img ofType:@"png"]];
		}
		background=nil;
		
		//freeImg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"free" ofType:@"png"]];
		yes_whistle = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"yes_whistle" ofType:@"png"]];
		no_whistle = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"no_whistle" ofType:@"png"]];
		yesWhistleView = [[UIImageView alloc] initWithImage:yes_whistle];
		noWhistleView = [[UIImageView alloc] initWithImage:no_whistle];
		
		CGRect bounds = [[UIScreen mainScreen] bounds];
		CGFloat width = bounds.size.width;
		CGFloat height = bounds.size.height;

#ifdef DEBUG_BUZZ
		txtView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 40.0, width, 220.0)];
		txtView.backgroundColor = [UIColor yellowColor];
		txtView.textColor = [UIColor redColor];
		[txtView setText:@"text"];
		txtView.editable = NO;
		txtView.scrollEnabled = YES;
		[self addSubview:txtView];
#endif		
		CGPoint pos = CGPointMake(width / 2.0, height / 2.0);
		[noWhistleView.layer setPosition:pos];
		[yesWhistleView.layer setPosition:pos];
			
		[self.layer addSublayer: noWhistleView.layer];
		[self.layer addSublayer: yesWhistleView.layer];
		noWhistleView.hidden = YES;
		yesWhistleView.hidden = YES;
	}
    return self;
}


- (void)drawRect:(CGRect)rect {
	CGFloat width = self.bounds.size.width;
	CGFloat height = self.bounds.size.height;
    // Drawing code
	if (background != nil) {
		[background drawInRect:self.bounds];
	}
	[cornerImg[1] drawInRect:CGRectMake(-1.0, -1.0, 50.0, 50.0)];
	[cornerImg[0] drawInRect:CGRectMake(-1.0, height - 49.0, 50.0, 50.0)];
	[cornerImg[3] drawInRect:CGRectMake(width - 49.0, 0.0, 50.0, 50.0)];
	[cornerImg[2] drawInRect:CGRectMake(width - 49.0, height - 49.0, 50.0, 50.0)];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	RoteKarteAppDelegate *parent = [[UIApplication sharedApplication]delegate];
	if ([touch tapCount] >= 2) {
		noWhistleView.hidden = !parent.whistle;
		yesWhistleView.hidden = parent.whistle;
		parent.whistle = !parent.whistle;
		self.flip;
	}
}

- (void) flip {
	BOOL animateTransition = true;
	
	if(animateTransition){
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES]; //does nothing without this line.
	
	}
	
	if(animateTransition){
		[UIView commitAnimations];
	}

	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fade) userInfo:nil repeats:NO];
}

- (void)fade {
	RoteKarteAppDelegate *parent = [[UIApplication sharedApplication]delegate];
	UIView *msgView = parent.whistle ? yesWhistleView : noWhistleView;
	
	CATransition *anim = [CATransition animation];
	anim.duration = 0.5;
	// using the ease in/out timing function
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	anim.type = kCATransitionFade;
	[msgView.layer addAnimation:anim forKey:nil];
	noWhistleView.hidden = YES;
	yesWhistleView.hidden = YES;
	
} 

#ifdef DEBUG_BUZZ
- (void)setText:(NSString *)txt {
	[txtView setText:txt];
}
#endif

- (void)dealloc {
#ifdef DEBUG_BUZZ	
	[txtView release];
#endif
	[noWhistleView release];
	[yesWhistleView release];
	[no_whistle release];
	[yes_whistle release];
	//[freeImg release];
	for (int i = 0; i<4; ++i) {
		[cornerImg[i] release];
	}
    [super dealloc];
}


@end
