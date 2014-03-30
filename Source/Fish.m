//
//  FFish.m
//  LostFin
//
//  Created by Alfonso on 2/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Fish.h"
#import "AnglerConstants.h"
@implementation Fish

{
    
    CCNode *_rope;
}
-(void)startSwimming
{
    CCBAnimationManager* animationManager = self.userObject;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"swimAnim"];

}
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = FishType;
    self.physicsBody.collisionCategories = @[OceanCollisionFish];
    self.physicsBody.collisionMask = @[OceanCollisionGround,OceanCollisionTower, OceanCollisionAir];
    
}
-(void)jump
{
    
    
    [self runAction:[CCActionRotateTo actionWithDuration:0.1f angle:-20]];
    [self.physicsBody setVelocity:ccp(0, 360)];
    [[OALSimpleAudio sharedInstance]playEffect:@"splash.wav"];

}
-(void)update:(CCTime)delta
{
    
    if (self.physicsBody.velocity.y <0)
        if (self.rotation < 75)
            [self setRotation:self.rotation + 4 ];
}
-(void)stopAllActions
{
    
    [super stopAllActions];

}
@end
