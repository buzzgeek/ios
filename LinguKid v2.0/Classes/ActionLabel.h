//
//  ActionLabel.h
//  English4Kids
//
//  Created by Jeannine Struck on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActionLabel : UILabel {
	int count;	//startanimation counter
}

- (void) startAnimation;

@end
