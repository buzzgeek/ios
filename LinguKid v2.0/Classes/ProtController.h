//
//  ProtController.h
//  English4Kids
//
//  Created by Jeannine Struck on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ProtController

- (id) initWithState:(Class)state withPlist:(NSString *)plist;

@end
