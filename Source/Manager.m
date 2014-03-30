//
//  Manager.m
//  FloppyFish
//
//  Created by Alfonso on 2/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//



#import "Manager.h"
#import <GameKit/GameKit.h>

@implementation Manager

#define urlLibaryPreferencesData @"Library/Preferences/"
#pragma mark Singleton Methods
{
    BOOL isGameCenterEnabled;
    int64_t maxScore;
}

+ (id)sharedManager {
    static Manager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
    
- (id)init {
    if (self = [super init]) {
        maxScore = 0;
    }
    return self;
}

#pragma mark Android Redefine
- (void) authenticateLocalPlayer
{
    
#ifndef ANDROID
//        __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
//        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
//            
//            if (viewController != nil)
//            {
//                [[CCDirector sharedDirector]presentViewController:viewController animated:YES completion:^(){}];
//                
//            }
//            else if (localPlayer.isAuthenticated)
//            {
//                
//                [self loadPlayerHighScore];
//                isGameCenterEnabled = YES;
//            }
//            else {
//                
//                [self readPlayerHighScore];
//                isGameCenterEnabled = NO;
//            }
//        };
#endif
}

-(void)loadPlayerHighScore
{

    
//#ifndef ANDROID
//    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
//    if (leaderboardRequest != nil) {
//        leaderboardRequest.identifier = @"lost.highscore";
//        leaderboardRequest.timeScope  = GKLeaderboardTimeScopeAllTime;
//        
//        [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error){
//            if (error != nil) {
//                //Handle error
//            }
//            if (scores != nil) {
//
//                 maxScore =  leaderboardRequest.localPlayerScore.value;
//            }
//        }];
//    }
//#endif
    
}
-(void)presentLeaderBorad
{
    
    
#ifndef ANDROID
    GKLeaderboardViewController *ctrl = [[GKLeaderboardViewController alloc]init];
    if (ctrl != nil)
    {
        ctrl.gameCenterDelegate = self;
        [[CCDirector sharedDirector] presentModalViewController: ctrl animated:YES];
    }
#endif
}

#ifndef ANDROID
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:^{}];
}
#endif

-(int64_t)getMaxScore
{return maxScore;}

-(void)reportScore:(int64_t)score
{
    
    if (maxScore < score) {
        
        maxScore = score;
        
        [self saveData:[NSNumber numberWithLongLong:maxScore] ToURL:[self URLsetUpFrom:urlLibaryPreferencesData]];
        
#ifndef ANDROID
        
        [self showBanner];
    if (isGameCenterEnabled ) {
        
        GKScore *currentScore = [[GKScore alloc]initWithCategory:@"lost.highscore"];

        currentScore.value = maxScore;
        
        [currentScore reportScoreWithCompletionHandler:^(NSError*error){
            if (error) {
                NSLog(@"Description %@",[error description]);
            }
            }];
        }
#endif
    }
    
    
    
}
- (void) showBanner
{

    
#ifndef ANDROID

    NSString* title = @"Highscore!";
    NSString* message = @"You've just passed your highscore!";
    [GKNotificationBanner showBannerWithTitle: title message: message
                            completionHandler:^{}];
#endif

}

#pragma mark Android Compatible
-(void)readPlayerHighScore
{
    NSNumber * nsScore =  [self readDataOfClass:[NSNumber class] FromURL:[self URLsetUpFrom:urlLibaryPreferencesData]];
    maxScore = [nsScore integerValue];
    
}
-(NSURL*)URLsetUpFrom:(NSString*)afterBundle

{
    
    NSURL* url =[[[[NSBundle mainBundle]bundleURL] URLByDeletingLastPathComponent]URLByAppendingPathComponent:afterBundle];
    
    NSFileManager *manager= [NSFileManager defaultManager];
    NSError *error;
    
    [manager createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        //Hanlde error
        NSLog(@"Error at creating directories at %@",url);
    }
    return url;
}
-(id)readDataOfClass:(Class)class FromURL:(NSURL*)url
{
    url = [url URLByAppendingPathComponent:@"data"];
    NSData *readArchive = [NSData  dataWithContentsOfURL:url];
    if (!readArchive) {
        id data = [[class alloc]init];
        return data;
        
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:readArchive];
}
-(BOOL)saveData:(id)data ToURL:(NSURL*)url
{
    url = [url URLByAppendingPathComponent:@"data"];
    NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:data];
    return [archive writeToURL:url atomically:YES];
}

@end
