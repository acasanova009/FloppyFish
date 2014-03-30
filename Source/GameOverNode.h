//
//  GameOverNode.h
//  LostFin
//
//  Created by Alfonso on 2/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GameOverNode : CCNode
-(void)play;
-(void)score;

-(void)setVisibleScore:(int64_t)value;
@end
