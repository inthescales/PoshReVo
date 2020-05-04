//
//  ObjCPonto.m
//  PoshReVo
//
//  Created by Robin Hill on 3/22/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

/*
 Chi tiu dosiero ebligas la uzadon de kelkaj objective-c funkcioj ene de la Swift kodo,
 kiu alie ne estus atingeblaj
 */

// UIAppearance+Swift.m
@implementation UIView (UIViewAppearance_Swift)
+ (instancetype)nia_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass {
    return [self appearanceWhenContainedIn:containerClass, nil];
}
@end
