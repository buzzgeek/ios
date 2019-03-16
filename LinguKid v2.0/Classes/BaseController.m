//
//  BaseController.m
//  English4Kids
//
//  Created by Jeannine Struck on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseController.h"


@implementation BaseController

- (id) initWithState:(Class)state withPlist:(NSString *)plist{
	if ((self = [super init])) {
		//todo
	}
	return self;
} 

-(void) setPlistScenario:(NSString *)plist {
	plistScenario = [NSString stringWithString:plist];
}

- (NSString *)plistScenario {
	return plistScenario;
}


@end
