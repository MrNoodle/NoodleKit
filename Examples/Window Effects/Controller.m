#import "Controller.h"
#import "NSWindow-NoodleEffects.h"

@implementation Controller

- (IBAction)toggleWindow:sender
{
    NSRect	rect;
	
    rect = [sender convertRect:[sender bounds] toView:nil];
    rect.origin = [[sender window] convertBaseToScreen:rect.origin];
    
    if ([_window isVisible])
    {
        [_window zoomOffToRect:rect];
    }
    else
    {
        [_window zoomOnFromRect:rect];
    }
}

@end
