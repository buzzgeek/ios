#import "CovertFlowViewController.h"
#import "CFView.h"
#import "ResourceManager.h"

@interface CovertFlowViewController (private)

- (BOOL) initScenarios:(NSString *)plist;

@end

@implementation CovertFlowViewController

- (id)init {
	self = [ super init ];
	if (self != nil) {
		covers = [ [ NSMutableDictionary alloc ] init ];

		[self initScenarios:@"scenarios"];

		NSString *scenario = nil;
		for (scenario in _dictScenarios) {
			NSDictionary *dict = [_dictScenarios objectForKey:scenario];
			NSString *img = [dict objectForKey:SCENE_TAG_IMAGE];
#ifdef DEBUG_ALL 			
			NSLog(@"Loading demo image %@\n", img);
#endif
			UIImage *image	= [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:img ofType:@"png"]] autorelease];
			[ covers setObject: image forKey:scenario ];
		}
	}
    return self;
}

- (BOOL) initScenarios:(NSString *)plist {
	NSData		*pData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plist ofType:@"plist"]];
	NSString	*error;
	NSPropertyListFormat format;
	
	_dictScenarios = [NSPropertyListSerialization 
					  propertyListFromData:pData 
					  mutabilityOption:NSPropertyListImmutable 
					  format:&format 
					  errorDescription:&error];
	if (error != nil) {
#ifdef DEBUG_ALL
		NSLog(@"error - %@", error);
#endif
		return NO;
	}
	
	return YES;
}

- (void)loadView {
	[ super loadView ];
	
	covertFlowView = [ [ CFView alloc ] initWithFrame: self.view.frame covers: covers ];
	covertFlowView.selectedCover = 2;

	self.view = covertFlowView;	 
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [ super didReceiveMemoryWarning ];
}

- (NSString *)getSelectedScenario {
	return [covertFlowView getSelectedScenario];
}

- (void) doStateChange:(Class)state withPlist:(NSString *)plist {}

- (void)dealloc {
	[ covertFlowView release ];
	[covers release];
	[_dictScenarios release];
    [ super dealloc ];
}

@end
