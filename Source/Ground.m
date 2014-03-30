//
//  Ground.m
//  LostFin
//
//  Created by Alfonso on 2/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Ground.h"
#import "AnglerConstants.h"
@implementation Ground

- (void)didLoadFromCCB {
    //    self.physicsBody.collisionType = @"tower";
    //    [self addChild:_fisicaNudo];
    //    self.pipeBot = _pipeBotNode;
    //    self.pipeTop = _pipeTopNode;
    self.physicsBody.collisionType = GroundType;
    
    self.physicsBody.collisionCategories = @[OceanCollisionGround];
    self.physicsBody.collisionMask = @[OceanCollisionFish];
    
}
@end
