//
//  AboutView.h
//  English4Kids
//
//  Created by Jeannine Struck on 8/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutView : UIView {
	UILabel			*lblAbout;
	UIButton		*btnDone;
	UIImageView		*viewImg;
	UITextView		*tvwAbout;
	UIWebView		*webAbout;
	
	UIToolbar		*toolbar;
	UIBarButtonItem	*btnBack;
	
}

@property (nonatomic, retain) IBOutlet UILabel *lblAbout;
@property (nonatomic, retain) IBOutlet UIButton *btnDone;
@property (nonatomic, retain) IBOutlet UIImageView *viewImg;
@property (nonatomic, retain) IBOutlet UIScrollView *tvwAbout;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnBack;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIWebView *webAbout;

- (void) loadDocument:(NSString*)documentName;

@end
