/**
 *  CubeMusicLayer.h
 *  CubeMusic
 *
 *  Created by Yuli Levtov on 21/01/2013.
 *  Copyright __MyCompanyName__ 2013. All rights reserved.
 */


#import "CC3Layer.h"
#import "Joystick.h"



/** A sample application-specific CC3Layer subclass. */
@interface CubeMusicLayer : CC3Layer {
    Joystick* pad1;
    Joystick* pad2;
    Joystick* pad3;
    Joystick* pad4;
    CCMenuItem* Button;
}

@end
