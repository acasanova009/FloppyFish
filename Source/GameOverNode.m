//
//  GameOverNode.m
//  LostFin
//
//  Created by Alfonso on 2/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOverNode.h"
#import "TapTapScene.h"

#import "Manager.h"
@implementation GameOverNode
{
}
-(void)play
{
    id sc = [self parent];
    if ([sc respondsToSelector:@selector(playFromGameOverMenu)])
        [sc playFromGameOverMenu];
   
}
-(void)score
{
    id sc = [self parent];
    if ([sc respondsToSelector:@selector(scoreFromGameOverMenu)])
        [sc scoreFromGameOverMenu];
    
}
-(void)setVisibleScore:(int64_t)value
{
    
    CCSprite*medal;

    if ([self isThisValue:value InRangeOf:10 to:20]) {
        medal = (CCSprite*)[CCBReader load:@"Medallas/medalla1"];
    }else if ([self isThisValue:value InRangeOf:20 to:40]) {

    
        medal = (CCSprite*)[CCBReader load:@"Medallas/medalla2"];
    }else if ([self isThisValue:value InRangeOf:40 to:80]){
        
        medal = (CCSprite*)[CCBReader load:@"Medallas/medalla3"];
    }else if ([self isThisValue:value InRangeOf:80 to:200]){
        
        medal = (CCSprite*)[CCBReader load:@"Medallas/medalla4"];
    }else if (value>199){
        
        medal = (CCSprite*)[CCBReader load:@"Medallas/medalla5"];
    }
    
    CGSize si = [CCDirector sharedDirector].view.frame.size;
    float middleScreen = si.height/2;
    
//    Score NEW LAbel
    
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%lld", value] fontName:@"Copperplate-bold" fontSize:40.0f];
    CCLabelTTF *bestLabel  = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%lld",[[Manager sharedManager]getMaxScore] ] fontName:@"Copperplate-bold" fontSize:40.0f];
    

//    Set Position
    [bestLabel setPosition:ccp(si.width+bestLabel.contentSize.width, middleScreen)];
    [scoreLabel setPosition:bestLabel.position];
//    
    CGPoint scoreLabelPos = ccp(si.width/5, scoreLabel.position.y);
    CGPoint bestLabelPos = ccp(si.width *4/5, scoreLabel.position.y);
    
    if (medal) {
        
        [medal setPosition:ccp(si.width+medal.contentSize.width, middleScreen)];
        
        [self addChild:medal];
        [medal runAction:[CCActionMoveTo actionWithDuration:1.5f position:ccp(si.width/2, middleScreen)]];
        
//        MEDAL ROTATION
        CCActionRotateBy *rot = [CCActionRotateTo actionWithDuration:1.0f angle:5.0f];
        CCActionRotateBy *rot2 = [CCActionRotateTo actionWithDuration:1.0f angle:-5.0f];
        CCActionSequence *seq = [CCActionSequence actionWithArray:@[rot,rot2]];
        CCActionRepeatForever *forever = [CCActionRepeatForever actionWithAction:seq];
        [medal runAction:forever];
    }
    
    [self addChild:scoreLabel];
    [self addChild:bestLabel];
    
    [scoreLabel runAction:[CCActionMoveTo actionWithDuration:1.0f position:scoreLabelPos]];
    [bestLabel runAction:[CCActionMoveTo actionWithDuration:1.0f position:bestLabelPos]];
    
    CCActionRotateBy *rot = [CCActionRotateTo actionWithDuration:1.3f angle:7.0f];
    CCActionRotateBy *rot2 = [CCActionRotateTo actionWithDuration:1.0f angle:-7.0f];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[rot,rot2]];
    CCActionRepeatForever *forever = [CCActionRepeatForever actionWithAction:seq];
    [scoreLabel runAction:forever];
    [bestLabel runAction:forever];
    
    

}
-(BOOL)isThisValue:(int64_t)value InRangeOf:(int64_t)left to:(int64_t)right
{
    BOOL doesIt = NO;
    if (value>=left && value<right)
        doesIt = YES;
    return doesIt;
}
@end
