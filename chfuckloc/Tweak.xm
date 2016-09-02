#import "LCBridge.h"

%hook CLLocation
- (CLLocationCoordinate2D) coordinate{

if([LCBridge isOpenSwitch] == YES){

    return [LCBridge getFakeLocation];

}else{
    return %orig;
}

}
%end
