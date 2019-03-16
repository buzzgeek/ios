//
//  ActionView.h
//  English4Kids
//
//  Created by Jeannine Struck on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionView : UIImageView {

	UIImage *img;
	NSString *snd;
}

@property (retain, nonatomic) NSString *snd;

- (void) loadImage:(NSString *)image;
- (void) loadUImage:(UIImage *)image;
- (void) startAnimationIsHidden:(BOOL)hide;
- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
