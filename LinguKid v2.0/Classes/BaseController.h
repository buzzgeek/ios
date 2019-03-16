//
//  BaseController.h
//  English4Kids
//
//  Created by Jeannine Struck on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtController.h"


@interface BaseController : UIViewController <ProtController> {
	NSString			*plistScenario;
}

@property (nonatomic, assign) IBOutlet NSString	*plistScenario;

@end
