//
//  cardView.h
//  Ampelkarte
//
//  Created by Jeannine Struck on 1/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define DEBUG_BUZZ

@interface CardView : UIView {
	UIView *panes[4];
	UIImage *cornerImg[4];
//	UIImage *freeImg;
	UIImage *no_whistle;
	UIImage *yes_whistle;
	UIImage	*background;
	UIImageView *noWhistleView;
	UIImageView *yesWhistleView;
#ifdef DEBUG_BUZZ	
	UITextView *txtView;
#endif

}

- (id)initWithFrame:(CGRect) frame setImage:(NSString *)img;

#ifdef DEBUG_BUZZ
- (void) setText:(NSString *)txt;
#endif


@end

