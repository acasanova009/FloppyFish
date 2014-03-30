//

//  Tower.m
//  LostFin
//
//  Created by Alfonso on 2/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tower.h"
#import "AnglerConstants.h"
@class TapTapScene;

@implementation Tower
{
    
 
    CCSprite *    _pipeBotNode;
    CCSprite*    _pipeTopNode;
    CCNode* _airNode;
    
}
-(void)update:(CCTime)delta
{
//    float mr = self.position.x + self.contentSize.width;
//    
//    NSLog(@"Postition x:%f",self.position.x);
//    static const float pos = 2.5f;
//    [self setPosition:ccp(self.position.x - pos, self.position.y)];
//    
//    NSLog(@"Postition x:%f",_pipeBotNode.position.x);
//    [_pipeBotNode setPosition:ccp(_pipeBotNode.position.x, _pipeBotNode.position.y)];
//    if (mr < 0)
//        [self removeSelf];
    
    
}

- (void)didLoadFromCCB {
    
    self.airNode = _airNode;
    
    _pipeTopNode.physicsBody.collisionType= TowerType;
    _pipeTopNode.physicsBody.collisionCategories= @[OceanCollisionTower];
    _pipeTopNode.physicsBody.collisionMask =@[OceanCollisionFish];
    
    _pipeBotNode.physicsBody.collisionType= _pipeTopNode.physicsBody.collisionType;
    _pipeBotNode.physicsBody.collisionCategories= _pipeTopNode.physicsBody.collisionCategories;
    _pipeBotNode.physicsBody.collisionMask = _pipeTopNode.physicsBody.collisionMask;
    
    
    _airNode.physicsBody.collisionType= AirType;
    _airNode.physicsBody.collisionCategories = @[OceanCollisionAir];
    _airNode.physicsBody.collisionMask = @[OceanCollisionFish];
    
}
-(void)movePipes:(float)xMotion
{
    CCAction * moveBot =[CCActionMoveTo actionWithDuration:Time position:ccp(xMotion,_airNode.position.y)];
    CCAction *killAirNode =[CCActionCallFunc actionWithTarget:self  selector:@selector(removeSelf)];
    [_pipeBotNode runAction:[CCActionMoveTo actionWithDuration:Time position:ccp(xMotion,_pipeBotNode.position.y)]];
//    [_pipeBotNode.physicsBody setVelocity:ccp(-135, 0)];
    [_pipeTopNode runAction:[CCActionMoveTo actionWithDuration:Time position:ccp(xMotion,_pipeTopNode.position.y)]];
//    [_pipeTopNode.physicsBody setVelocity:ccp(-135, 0)];
//        [_airNode.physicsBody setVelocity:ccp(-135, 0)];

    CCAction* seq = [CCActionSequence actionWithArray:@[moveBot,killAirNode]];
    
    [_airNode runAction:seq];

}
-(void)removeTowersCollisionMask
{
    
    
    _pipeTopNode.physicsBody.collisionMask =@[];
    _pipeBotNode.physicsBody.collisionMask = _pipeTopNode.physicsBody.collisionMask;
//
}
-(void)removeSelf
{
    [self.parent removeChild:self cleanup:YES];
}

-(void)killAirNode
{
    [self removeChild:_airNode];
    
}
-(void)stopAllActions
{
    [super stopAllActions];
    [_pipeBotNode stopAllActions];
    [_pipeTopNode stopAllActions];
    [_airNode stopAllActions];
}

@end
