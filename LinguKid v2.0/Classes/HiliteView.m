//
//  HiliteView.m
//  English4Kids
//
//  Created by Jeannine Struck on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HiliteView.h"


@implementation HiliteView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	
	CGContextBeginPath(myContext);
	CGContextSetRGBFillColor(myContext, 0.5, 0.5, 0.1, 0.3);
	CGContextFillRect(myContext, self.frame);
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
