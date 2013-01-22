/**
 *  CubeMusicScene.h
 *  CubeMusic
 *
 *  Created by Yuli Levtov on 21/01/2013.
 *  Copyright __MyCompanyName__ 2013. All rights reserved.
 */


#import "CC3Scene.h"
#import "models.h"


/** A sample application-specific CC3Scene subclass.*/
@interface CubeMusicScene : CC3Scene {
    
    SpinningNode *largeCube;
    NSMutableArray* particleArray;
    CC3ParticleEmitter* particleEmitter;

    
    CC3Node *particleManager;
    
    
    
    CGPoint lastTouchedPoint;
}

@end
