//
//  RoteKarteViewController.h
//  Ampelkarte
//
//  Created by Jeannine Struck on 1/30/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIScrollView.h>
#import <AVFoundation/AVFoundation.h>
#import "CardView.h"

@interface RoteKarteViewController : UIViewController <UIScrollViewDelegate, UIAccelerometerDelegate> {
	UIScrollView *scrollView;
	UIView *mainView;
	CardView *redView;
	CardView *yellowView;
	CardView *buttView;
	BOOL bAudioActive;
	BOOL bUp;
}

@property(nonatomic)int activeSound;

@end

