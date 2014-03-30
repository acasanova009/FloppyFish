//
//  TapTapScene.m
//  LostFin
//
//  Created by Alfonso on 2/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TapTapScene.h"
#import "Fish.h"
#import "Tower.h"
#import "Ground.h"
#import "AnglerConstants.h"
#import "GameOverNode.h"
#import "Manager.h"



@implementation TapTapScene
{
    CCPhysicsNode* _physicsNode;
    Fish* _fish;
    
    CCNode * _lowerGround;
    CCNode *_taptapNode;
    GameOverNode *_gameOverMenuNode;
    
    Ground *    _ground1;
    Ground *    _ground2;
    

    
    CCAction *_jump;
    CCAction *_rotate;
    int64_t score;
    CCLabelTTF *_score;
    
    
#ifndef ANDROID
    ADBannerView *adView;
#endif
    CGRect windowFrame;
    
    
    BOOL isBannerVisible;
    BOOL isTheFishStillSwimming;
    BOOL shouldCreateNewPipes;

    CGFloat win;
    
}

- (void)didLoadFromCCB
{
    self.userInteractionEnabled =YES;
    shouldCreateNewPipes= YES;
    isTheFishStillSwimming =NO;
    isBannerVisible = NO;
//    _physicsNode.debugDraw =YES;
    [_ground1 setZOrder:10];
    [_ground2 setZOrder:10];
    [_fish setZOrder:9];
    [_physicsNode setGravity:ccp(0, -1200)];
    [_physicsNode setCollisionDelegate:self];

    [self loadAdBanner];

    windowFrame =[CCDirector sharedDirector].view.bounds;
    
}

-(void)update:(CCTime)delta
{
    static const float pos = 2.5f;
    if (!isTheFishStillSwimming) {
        
    
    [_ground1 setPosition:ccp(_ground1.position.x - pos, _ground1.position.y)];
    [_ground2 setPosition:ccp(_ground2.position.x - pos, _ground2.position.y)];
    if (_ground1.position.x <= -windowFrame.size.width)
        _ground1.position = ccp(windowFrame.size.width, _ground1.position.y);

    if (_ground2.position.x <= -windowFrame.size.width)
        _ground2.position = ccp(windowFrame.size.width, _ground2.position.y);
    }
    
    
}
#pragma mark Collision Delegate

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair air:(CCNode *)nodeA wildcard:(CCNode *)nodeB
{
    Tower* tP = (Tower*)[nodeA parent];
    [tP killAirNode];
    
    [[OALSimpleAudio sharedInstance]playEffect:@"coin.wav"];
    score+=1;
    [_score setString:[NSString stringWithFormat:@"%lld",score]];
    
    
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair tower:(CCNode *)nodeA wildcard:(CCNode *)nodeB
{
    id padre = [nodeA parent];
    if ([padre respondsToSelector:@selector(removeTowersCollisionMask)]) 
        [padre removeTowersCollisionMask];


    [[OALSimpleAudio sharedInstance]playEffect:@"pipe.wav"];
    
    _fish.physicsBody.collisionMask = @[OceanCollisionGround];
    [self crash];
    
    
}
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ground:(CCNode *)nodeA wildcard:(CCNode *)nodeB
{
    _fish.physicsBody =nil;
    [[OALSimpleAudio sharedInstance]playEffect:@"slap.wav"];
    [self crash];
    
}
-(void)crash
{
    if (!isTheFishStillSwimming) {
        [self presentGameOverMenuNode];
        [_physicsNode.children makeObjectsPerformSelector:@selector(stopAllActions)];
        [_physicsNode stopAllActions];
        CCActionBlink *blick = [CCActionBlink actionWithDuration:0.2f blinks:2];

        [self runAction:blick];
        
        isTheFishStillSwimming =YES;
        

        [[Manager sharedManager] reportScore:score];

    }
}

-(void)jump
{
    if (CGRectIntersectsRect(windowFrame,[_fish boundingBox])){
    if (!isTheFishStillSwimming) {
            [_fish jump];
            if (_taptapNode.visible) {
                [_taptapNode runAction:[CCActionHide action]];
                [self startMovingPipes];
                [self stopAllActions];
                [_fish.physicsBody setAffectedByGravity:YES];
            }
        }
    }
}
-(void)createNewPipe {
    
    Tower * p = (Tower*)[CCBReader load:@"Tower"];

    
    int airNode = p.airNode.contentSize.height;
    int max = [CCDirector sharedDirector].view.frame.size.height - airNode;
    int min = _ground1.contentSize.height + airNode;
    
    int randNum = rand() % (max - min) + min;
    [p setPosition:ccp(windowFrame.size.width +p.contentSize.width, randNum)];
    [_physicsNode addChild:p];
    if ([p respondsToSelector:@selector(movePipes:)])
        [p movePipes:-10.0f];
}
-(void)startMovingPipes
{
    if (shouldCreateNewPipes) {
        
    CCActionInstant* seleccionador = [CCActionCallFunc actionWithTarget:self selector:@selector(createNewPipe)];
    CCAction* idle = [CCActionDelay actionWithDuration:1.5];
    CCActionInterval * seq =[CCActionSequence actionWithArray:@[seleccionador,idle]];
    CCAction * forever = [CCActionRepeatForever actionWithAction:seq];
    [_physicsNode runAction:forever];
    }
}
-(void)presentGameOverMenuNode
{
 
    
        CGSize pint = [CCDirector sharedDirector].view.frame.size;
    _gameOverMenuNode =(GameOverNode*)[CCBReader load:@"GameOverNode"];
    [_gameOverMenuNode setPosition:ccp(pint.width,0)];
    [_score stopAllActions];
    CCAction *remove = [CCActionMoveTo actionWithDuration:1.0f position:ccp(_score.position.x-pint.width/2- _score.contentSize.width,_score.position.y)];
    CCActionInstant* seleccionador = [CCActionCallFunc actionWithTarget:self selector:@selector(sendScore)];
    [_score runAction:[CCActionSequence actionWithArray:@[remove,seleccionador]]];
//    [_score setPosition:ccp(pint.width, pint.height-_score.contentSize.height)];
    [self addChild:_gameOverMenuNode];
    [_gameOverMenuNode runAction:[CCActionMoveTo actionWithDuration:1.0f position:ccp(0, 0)]];
    
    
}
-(void)sendScore
{
    [_gameOverMenuNode setVisibleScore:score];
    
}

#pragma mark Game Over Menu Node;

-(void)playFromGameOverMenu
{
    
    [self sound];
#ifndef ANDROID
    [adView removeFromSuperview];
#endif
    [[CCDirector sharedDirector]replaceScene:[CCBReader loadAsScene:@"TapTapScene"] withTransition:[CCTransition transitionFadeWithColor:[CCColor blackColor] duration:0.5f]];
}


-(void)scoreFromGameOverMenu
{
    
    [[Manager sharedManager]presentLeaderBorad];
    [self sound];
}
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{[self jump];}


#pragma mark iAd Delegate Methods

-(void)loadAdBanner
{
#ifndef ANDROID
//    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]){
        adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    
    adView.delegate = self;
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        
    CGRect window =[CCDirector sharedDirector].view.bounds;
    CGRect bannerFrame = adView.frame;
    bannerFrame.origin.y = window.size.height;
    adView.frame = bannerFrame;

        isBannerVisible =NO;

    [[[CCDirector sharedDirector]view]addSubview:adView];
//    }
#endif
}

#ifndef ANDROID
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!isBannerVisible)
    {
        

        CGRect window =[CCDirector sharedDirector].view.bounds;
        CGRect bannerFrame = adView.frame;
        window.size.height -= adView.frame.size.height;
        bannerFrame.origin.y = window.size.height;
        adView.frame = bannerFrame;
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView animateWithDuration:10.0f animations:^(void){
            banner.frame = CGRectMake( banner.frame.origin.x, adView.frame.origin.y, banner.frame.size.width, banner.frame.size.height );
        }];
        [UIView commitAnimations];
        isBannerVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (isBannerVisible)
    {
        
        CGRect bannerFrame = adView.frame;
        
        bannerFrame.origin.y = windowFrame.size.height;
        adView.frame = bannerFrame;
        
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
         banner.frame = CGRectMake( banner.frame.origin.x, adView.frame.origin.y, banner.frame.size.width, banner.frame.size.height );
        [UIView commitAnimations];
        
        isBannerVisible = NO;
    }
    
}


- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    [[CCDirector sharedDirector]pause];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [[CCDirector sharedDirector]resume];
}
#endif
-(void)sound
{
    [[OALSimpleAudio sharedInstance]playNextButtonSound];
}
@end
