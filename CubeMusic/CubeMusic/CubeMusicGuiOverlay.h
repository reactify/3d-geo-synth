//
//  CubeMusicGuiOverlay.h
//  CubeMusic
//
//  Created by Yuli Levtov on 22/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CC3Actions.h"
#import "CC3CC2Extensions.h"
#import "CC3IOSExtensions.h"
#import "CC3layer.h"
#import "ccMacros.h"
#import "models.h"


@interface CubeMusicGuiOverlay : CC3Layer {
    Joystick* topLeft;
    Joystick* topRight;
    Joystick* bottomLeft;
    Joystick* bottomRight;
}

@end
