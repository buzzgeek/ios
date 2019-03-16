//
//  gridView.h
//  English4Kids
//
//  Created by Jeannine Struck on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@class TargetView;
@class HiliteView;

@interface GridView : BaseView {
	TargetView	*tgtView;
	HiliteView	*hiliteView;
	UITextView	*txtView;
}

- (void) setText:(NSString *)txt;

@end
