//
//  Tower.h
//  LostFin
//
//  Created by Alfonso on 2/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCScene.h"


@interface Tower : CCNode

//@property (nonatomic) CCSprite * pipeTop;
//@property (nonatomic) CCSprite * pipeBot;
//
@property (nonatomic) CCNode * airNode;

-(void)removeTowersCollisionMask;
-(void)killAirNode;
-(void)movePipes:(float)xMotion;

@end
