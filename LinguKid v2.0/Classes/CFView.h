//
//  CFView.h
//  English4Kids
//
//  Created by Jeannine Struck on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CFView : UIScrollView <UIScrollViewDelegate>
{
	CAScrollLayer *cfIntLayer;
	NSMutableArray *_covers;
	
	int  selectedCover;
	BOOL isActive;
}

- (id) initWithFrame:(struct CGRect)frame covers:(NSMutableDictionary *)dictCovers;
- (void)layoutLayer:(CAScrollLayer *)layer;
- (NSString *)getSelectedScenario;

@property(nonatomic,getter=getSelectedCover) int selectedCover;

@end
