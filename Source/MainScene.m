//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Fish.h"
#import "Manager.h"

@class TapTapScene;

@implementation MainScene
{
    CCNode * _startMenuNode;
    CCNode* _fish;
    CCPhysicsNode *_physicsNode;
}
-(void)playFromStartMenu
{
    [self sound];
     [[CCDirector sharedDirector]replaceScene:[CCBReader loadAsScene:@"TapTapScene"]];
}

-(void)starFromMenu
{
    
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id827249671";
    NSURL * url = [NSURL URLWithString:iOS7AppStoreURLFormat];
    //    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@"
    
    [[UIApplication sharedApplication] openURL:url]; // Would launch the app store and open the app ID popup
    [self sound];
}
-(void)scoreFromMenu
{
    [[Manager sharedManager]presentLeaderBorad];

    [self sound];
    
}
-(void)update:(CCTime)delta
{
    float fishP = _fish.position.y;
    if (fishP < 0.5) {
        [_fish.physicsBody setVelocity:ccp(0, 200)];
    }
}
- (void)didLoadFromCCB
{
    [_physicsNode setGravity:ccp(0, -400)];
}
-(void)sound
{
    [[OALSimpleAudio sharedInstance]playNextButtonSound];
}

@end
