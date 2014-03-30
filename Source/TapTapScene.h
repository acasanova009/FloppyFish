//
//  TapTapScene.h
//  LostFin
//
//  Created by Alfonso on 2/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import <iAd/iAd.h>
@interface TapTapScene : CCNode <CCPhysicsCollisionDelegate,ADBannerViewDelegate>
-(void)playFromGameOverMenu;
-(void)scoreFromGameOverMenu;
@end
