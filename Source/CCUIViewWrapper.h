//
//  CCUIViewWrapper.h
//  FloppyFish
//
//  Created by Alfonso on 2/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"


@interface CCUIViewWrapper : CCSprite
{
    UIView *uiItem;
    float rotation;
}

@property (nonatomic, retain) UIView *uiItem;

+ (id) wrapperForUIView:(UIView*)ui;
- (id) initForUIView:(UIView*)ui;

- (void) updateUIViewTransform;

@end