/**
 *  CubeMusicScene.m
 *  CubeMusic
 *
 *  Created by Yuli Levtov on 21/01/2013.
 *  Copyright __MyCompanyName__ 2013. All rights reserved.
 */

#import "CubeMusicScene.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3ParametricMeshes.h"
#import "CC3ParametricMeshNodes.h"

#import "CC3Camera.h"
#import "CC3Light.h"


@implementation CubeMusicScene

-(void) dealloc {
	[super dealloc];
}



-(void) initializeScene {
    
	// Create the camera, place it back a bit, and add it to the scene
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
	cam.location = cc3v( 0.0, 0.0, 20.0 );
    float fov=1;
    
    [cam setScale: cc3v(fov,fov,fov)];
	[self addChild: cam];
    
	// Create a light, place it back and to the left at a specific
	// position (not just directional lighting), and add it to the scene
	//CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	//lamp.location = cc3v( -2.0, 0.0, 0.0 );
	//lamp.isDirectionalOnly = NO;
	//[cam addChild: lamp];
    
    /*
    (void) addSpotlight {
        CC3Light* spotLight = [CC3Light nodeWithName: kSpotlightName];
        spotLight.visible = NO;
        spotLight.spotExponent = 30.0;
        spotLight.spotCutoffAngle = 60.0;
        spotLight.attenuation = CC3AttenuationCoefficientsMake(0.0, 0.002, 0.000001);
        spotLight.isDirectionalOnly = NO;
        [self.activeCamera addChild: spotLight];
    }
     */

    
    CC3Light* front = [CC3Light nodeWithName: @"_frontLight"];
    CC3Light* filler = [CC3Light nodeWithName: @"_fillerLight"];
    
    front.location = cc3v(30,60,60);
    front.spotExponent = 40;
    front.spotCutoffAngle = 45;
    front.attenuation = CC3AttenuationCoefficientsMake(0.0, 0.002, 0.000001);
    
    filler.location= cc3v(-10,5,5);
    filler.spotExponent = 40;
    filler.spotCutoffAngle = 45;
    filler.attenuation = CC3AttenuationCoefficientsMake(0.0, 0.002, 0.000001);
    
    [self addChild: front];
    [self addChild: filler];
	
	
	// Create OpenGL ES buffers for the vertex arrays to keep things fast and efficient,
	// and to save memory, release the vertex content in main memory because it is now redundant.
    
    
	largeCube = [CC3BoxNode nodeWithName:@"_largeCube"];
    [largeCube setReferenceUpDirection:cc3v(0.0,0.0,1.0)];
    NSLog(@"cubes global rotation = %f,%f,%f", largeCube.rotation.x,largeCube.rotation.y,largeCube.rotation.z);
    
    [self addChild:largeCube];
    [self addChildCubes: 4];
    
    
    
    
    
    
    [self createGLBuffers];
	[self releaseRedundantContent];
	
	// That's it! The scene is now constructed and is good to go.
	
	// If you encounter problems displaying your models, you can uncomment one or more of the
	// following lines to help you troubleshoot. You can also use these features on a single node,
	// or a structure of nodes. See the CC3Node notes for more explanation of these properties.
	// Also, the onOpen method below contains additional troubleshooting code you can comment
	// out to move the camera so that it will display the entire scene automatically.
	
	// Displays short descriptive text for each node (including class, node name & tag).
	// The text is displayed centered on the pivot point (origin) of the node.
    //	self.shouldDrawAllDescriptors = YES;
	
	// Displays bounding boxes around those nodes with local content (eg- meshes).
    //	self.shouldDrawAllLocalContentWireframeBoxes = YES;
	
	// Displays bounding boxes around all nodes. The bounding box for each node
	// will encompass its child nodes.
    //	self.shouldDrawAllWireframeBoxes = YES;
	
	// If you encounter issues creating and adding nodes, or loading models from
	// files, the following line is used to log the full structure of the scene.
	//LogInfo(@"The structure of this scene is: %@", [self structureDescription]);
	
	// ------------------------------------------
    
	// But to add some dynamism, we'll animate the 'hello, world' message
	// using a couple of cocos2d actions...
	
	// Fetch the 'hello, world' 3D text object that was loaded from the
	// POD file and start it rotating
	//CC3MeshNode* helloTxt = (CC3MeshNode*)[self getNodeNamed: @"Hello"];
	
}


-(void)addChildCubes:(int) _row{
    
    int rows=_row;
    int rowsSquare = pow(rows,2);
    float sizeOfBigCube= 11;
    
    float sizeOfGaps=0.2;
    float sizeOfCubes= (sizeOfBigCube-((rows-1)*sizeOfGaps))/rows;
    float rotateOffset = +(sizeOfCubes*0.5)-sizeOfGaps-(sizeOfBigCube*0.5);
    
    NSMutableArray* babyCubes = [[NSMutableArray alloc] initWithCapacity:rowsSquare];
    
    for(int i=0; i<rows; i++)
    {
        for(int j=0; j<rows; j++)
        {
            for(int k=0; k<rows; k++)
            {
                
                CC3BoxNode* tempCube = [CC3BoxNode nodeWithName: @"cube"];
                [tempCube populateAsSolidBox: CC3BoundingBoxMake(-0.5f, -0.5f, -0.5f, 0.5f, +0.5f, 0.5f)];
                tempCube.uniformScale =sizeOfCubes;
                tempCube.location=cc3v((i*(sizeOfCubes+sizeOfGaps)+rotateOffset),(j*(sizeOfCubes+sizeOfGaps)+rotateOffset),(k*(sizeOfCubes+sizeOfGaps)+rotateOffset));
                
                tempCube.texture = [CC3Texture textureFromFile: @"cubeTexture.png"];
                tempCube.textureRectangle = CGRectMake(0, 0, 1, 0.75);
                //	texCube.texture = [CC3Texture textureFromFile: kCubeTextureFile];
                
                tempCube.ambientColor = CCC4FMake(0.30*i+0.3, 0.30*j+0.3, 0.30*k+0.3, 1.0);
                tempCube.diffuseColor =CCC4FMake(0.7,0.7,0.9,1.0);
                
                [babyCubes insertObject:tempCube atIndex: (i*rowsSquare)+(j*rows)+k];
                
            }
            
        }
        
    };
    
    
    for(int i=0;i<babyCubes.count;i++)
    {
        
        [largeCube addChild:[babyCubes objectAtIndex:i]];
    }
    
    
    
}









#pragma mark Updating custom activity

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities before
 * any changes are applied to the transformMatrix of the 3D nodes in the scene.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {
    
    
    
    
    
    
    
}


-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {
	// If you have uncommented the moveWithDuration: invocation in the onOpen: method, you
	// can uncomment the following to track how the camera moves, where it ends up, and what
	// the camera's clipping distances are, in order to determine how to position and configure
	// the camera to view the entire scene.
    //	LogDebug(@"Camera: %@", activeCamera.fullDescription);
}


#pragma mark Scene opening and closing

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene is first displayed.
 *
 * This method is a good place to invoke one of CC3Camera moveToShowAllOf:... family
 * of methods, used to cause the camera to automatically focus on and frame a particular
 * node, or the entire scene.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onOpen {
    
	// Uncomment this line to have the camera move to show the entire scene. This must be done
	// after the CC3Layer has been attached to the view, because this makes use of the camera
	// frustum and projection. If you uncomment this line, you might also want to uncomment the
	// LogDebug line in the updateAfterTransform: method to track how the camera moves, where
	// it ends up, and what the camera's clipping distances are, in order to determine how to
	// position and configure the camera to view the entire scene.
    //	[self.activeCamera moveWithDuration: 3.0 toShowAllOf: self];
    
	// Uncomment this line to draw the bounding box of the scene.
    //	self.shouldDrawWireframeBox = YES;
}

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene has been removed from display.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onClose {}


-(void) TouchParticles:(CGPoint) location{
    
    NSLog(@"Particle Creation at: (%f,%f)",location.x,location.y);

    
   
    
}


#pragma mark Handling touch events

/**
 * This method is invoked from the CC3Layer whenever a touch event occurs, if that layer
 * has indicated that it is interested in receiving touch events, and is handling them.
 *
 * Override this method to handle touch events, or remove this method to make use of
 * the superclass behaviour of selecting 3D nodes on each touch-down event.
 *
 * This method is not invoked when gestures are used for user interaction. Your custom
 * CC3Layer processes gestures and invokes higher-level application-defined behaviour
 * on this customized CC3Scene subclass.
 *
 * For more info, read the notes of this method on CC3Scene.
 */

-(void) nudgeCube{
    CCActionInterval* left = [CC3RotateBy actionWithDuration: 0.2 rotateBy: cc3v(0.0, 90.0, 0.0)];
       [largeCube runAction: left];
}


-(void) touchEvent: (uint) touchType at: (CGPoint) touchPoint{
    
    lastTouchedPoint = touchPoint;
    
    switch (touchType) {
		case kCCTouchBegan:
            if(touchPoint.x >= 150)
            {
                [self rotateCube:1];
                NSLog(@"touched at: (%f,%f)",touchPoint.x,touchPoint.y);
            }
            else{
                [self rotateCube:0];
            }
                //[self TouchParticles:touchPoint];
			break;
		case kCCTouchMoved:
            {
                NSLog(@"dragged at: (%f,%f)",touchPoint.x,touchPoint.y);
                [self nudgeCube];
                
            
			break;
            }
		case kCCTouchEnded:
        {
			NSLog(@"picked up at: (%f,%f)",touchPoint.x,touchPoint.y);
			break;
        }
		default:
			break;
	}
	
	// For all event types, remember where the touchpoint was, for subsequent events.
}




-(void)rotateCube:(uint)Direction
{
    CCActionInterval* left = [CC3RotateBy actionWithDuration: 0.2 rotateBy: cc3v(0.0, 90.0, 0.0)];
    CCActionInterval* right = [CC3RotateBy actionWithDuration: 0.2 rotateBy: cc3v(0.0, -90.0, 0.0)];
    
    switch(Direction){
        case 1:
            [largeCube runAction: left];
            break;
        case 0:
            [largeCube runAction: right];
            break;
        default:
            break;
    }
    
    NSLog(@"cubes global rotation = %f,%f,%f", largeCube.rotation.x,largeCube.rotation.y,largeCube.rotation.z);
   
    
}



/**
 * This callback template method is invoked automatically when a node has been picked
 * by the invocation of the pickNodeFromTapAt: or pickNodeFromTouchEvent:at: methods,
 * as a result of a touch event or tap gesture.
 *
 * Override this method to perform activities on 3D nodes that have been picked by the user.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) nodeSelected: (CC3Node*) aNode byTouchEvent: (uint) touchType at: (CGPoint) touchPoint {}

@end

