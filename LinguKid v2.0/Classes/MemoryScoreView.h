//
//  MemoryScoreView.h
//  LinguKid
//
//  Created by Jeannine Struck on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCORE_FONT_SIZE		0.072
@interface MemoryScoreView : UIView {
	int			score;
	UIColor		*textColor;
	UITextView	*frontView;
	UITextView	*backView;
	BOOL		showBack;
	BOOL		active;
}

@property (nonatomic, readwrite) int score;
@property (nonatomic, assign) UIColor *textColor;
@property (nonatomic, readwrite) BOOL active;

@end
