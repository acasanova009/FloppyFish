//
//  Manager.h
//  FloppyFish
//
//  Created by Alfonso on 2/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//


#import <cocos2d.h>
#import <Foundation/Foundation.h>
#import  <GameKit/GameKit.h>

@interface Manager : NSObject

#ifndef ANDROID
<GKGameCenterControllerDelegate>
#endif

    
-(void)authenticateLocalPlayer;
-(void)presentLeaderBorad;
-(void)reportScore:(int64_t)score;
+ (id)sharedManager;
-(int64_t)getMaxScore;
@end