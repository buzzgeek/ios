//
//  IntroView.h
//  English4Kids
//
//  Created by Jeannine Struck on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IntroView : UIView {
	
	UIImageView		*viewImg;
	UIWebView		*webIntro;
	UIToolbar		*toolbar;
	UIBarButtonItem	*btnBack;
	
}

@property (nonatomic, retain) IBOutlet UIImageView *viewImg;
@property (nonatomic, retain) IBOutlet UIWebView *webIntro;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnBack;

- (void) loadDocument:(NSString*)documentName;

@end
