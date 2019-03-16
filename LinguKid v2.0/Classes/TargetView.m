//
//  TargetView.m
//  English4Kids
//
//  Created by Jeannine Struck on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TargetView.h"


@implementation TargetView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGFloat r = self.bounds.size.width / 2.0;
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	
	CGContextBeginPath(myContext);
	CGContextSetRGBStrokeColor(myContext, 1.0, 1.0, 1.0, 1.0);	
	CGContextAddArc(myContext, r, r, r / 2.0, 0.0, 2 * M_PI, false);
	CGContextAddArc(myContext, r, r, r / 4.0, 0.0, 2 * M_PI, false);
	
	CGContextMoveToPoint(myContext, r, 0.0);
	CGContextAddLineToPoint(myContext, r, r * 2.0);

	CGContextMoveToPoint(myContext, 0.0, r);
	CGContextAddLineToPoint(myContext, r * 2.0, r);

 	CGContextStrokePath(myContext);
	
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	if ([touch tapCount] == 1) {
		[self raiseEvent:EVENT_ON_TAP withObject:touch];
	} else {
		[self raiseEvent:EVENT_ON_DOUBLETAP withObject:touch];
	}
}

- (void) dealloc {
    [super dealloc];
}


@end
