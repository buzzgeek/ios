//
//  CFView.m
//  English4Kids
//
//  Created by Jeannine Struck on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CFView.h"
#import "English4KidsAppDelegate.h"
#import "ScenarioViewController.h"
#import "Scenario.h"
#import "ResourceManager.h"

@implementation CFView

- (id) initWithFrame:(struct CGRect)frame covers:(NSMutableDictionary *)covers {
	
	self = [ super initWithFrame: frame ];
	
	if (self != nil) {
		_covers = [[NSMutableArray alloc] initWithCapacity:[covers count]];
		selectedCover = 0;
		
		self.showsVerticalScrollIndicator = YES;
		self.showsHorizontalScrollIndicator = NO;
		self.delegate = self;
		self.scrollsToTop = NO;
		self.bouncesZoom = NO;
		self.bounces = NO;
		self.backgroundColor = [UIColor clearColor];
		
		cfIntLayer = [ [ CAScrollLayer alloc ] init ];
		cfIntLayer.bounds = frame;
		cfIntLayer.frame = frame;
		isActive = NO;
		
		for (NSString *scenario in covers) {
			[_covers addObject:scenario];

			UIImageView *background = [[[UIImageView alloc] initWithImage:[ covers objectForKey:scenario ]] autorelease];
			[ cfIntLayer addSublayer: background.layer ];
		}
		
		self.contentSize = CGSizeMake(frame.size.width, ([g_ResManager heightPcnt:0.5] * ([ _covers count ]-1)));
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		
		[ self.layer addSublayer: cfIntLayer ];
		[ self layoutLayer: cfIntLayer ];
	}
	
	return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	isActive = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    selectedCover = (int) roundf((self.contentOffset.y/[g_ResManager heightPcnt:0.25]));
	if (selectedCover > [ _covers count ] - 1) {
		selectedCover = [ _covers count ] - 1;
	}
	[ self layoutLayer: cfIntLayer ];
	isActive = NO;
}

- (void)setSelectedCover:(int)index {
	
	if (index != selectedCover) {
		selectedCover  = index;
		[ self layoutLayer: cfIntLayer ];
		self.contentOffset = CGPointMake(self.contentOffset.x, selectedCover * [g_ResManager heightPcnt:0.25]);
	}
}

- (int) getSelectedCover {
	return selectedCover;
}

- (NSString *)getSelectedScenario {
	return (NSString *)[_covers objectAtIndex:selectedCover];
}

-(void) layoutLayer:(CAScrollLayer *)layer
{
    NSArray *array = [layer sublayers];
    CGSize cellSize = CGSizeMake ([g_ResManager widthPcnt:0.5], [g_ResManager heightPcnt:0.5]);
    float sideSpacingFactor = 0.25; /* How close should slide covers be */
	float rowScaleFactor = 0.25; /* Distance between main cover and side covers */
    float angle = 1.39;
    CATransform3D leftTransform = CATransform3DMakeRotation(angle, -1, 0, 0);
	CATransform3D rightTransform = CATransform3DMakeRotation(-angle, -1, 0, 0);
	CATransform3D sublayerTransform = CATransform3DIdentity;
    CALayer *sublayer;
    CGRect rect;
	
	/* Set perspective */
	sublayerTransform.m34 = -0.006;
    
	/* Begin a CATransaction so that all animations happen simultaneously */
    [ CATransaction begin ];
    [ CATransaction setValue: [ NSNumber numberWithFloat: 0.5f ] forKey:@"animationDuration" ];
	
	size_t count = [array count];
    for (size_t i = 0; i < count; i++)
    {
        sublayer = [ array objectAtIndex:i ];
		
		rect = CGRectMake(cellSize.width * 0.75 - [g_ResManager widthPcnt:0.1], i * [g_ResManager heightPcnt:0.5], cellSize.width, cellSize.height);
		
        [ [ sublayer superlayer ] setSublayerTransform: sublayerTransform ];
		
        if (i < selectedCover)        /* Left side */
        {
            rect.origin.y += cellSize.height * sideSpacingFactor * (float) (selectedCover - i - rowScaleFactor);
            sublayer.transform = leftTransform;
        }
        else if (i > selectedCover)   /* Right side */
        {
            rect.origin.y -= cellSize.height * sideSpacingFactor * (float) (i - selectedCover - rowScaleFactor);
            sublayer.transform = rightTransform;
        }
        else                     /* Selected cover */
        {
            sublayer.transform = CATransform3DIdentity;
		
            [layer scrollToPoint: CGPointMake(0, rect.origin.y - [g_ResManager heightPcnt:0.25])];
            layer.position = CGPointMake(rect.origin.x, [g_ResManager heightPcnt:0.25] * (selectedCover + 1));
        }
        [ sublayer setFrame: rect ];
		
    }
    [ CATransaction commit ];
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	if ([touch tapCount] > 0 && !isActive) {
		English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		delegate.isGameMode = YES;
		[delegate pushController:[ScenarioViewController class] withState:[Scenario class] withPlist:[self getSelectedScenario]];
	}
}


- (void) dealloc {
	[_covers release];
	[cfIntLayer release];
	[super dealloc];
}

@end

