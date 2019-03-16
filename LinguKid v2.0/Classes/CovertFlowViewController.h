#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import	"BaseController.h"

@class CFView;

@interface CovertFlowViewController : BaseController {
	NSDictionary *_dictScenarios;
	NSMutableDictionary *covers;
    CFView *covertFlowView;
}

- (NSString *)getSelectedScenario;

@end

