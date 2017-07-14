//
//  CocoapodsPane.m
//  CocoapodsPane
//
//  Created by Patrick Horlebein on 13.07.17.
//  Copyright © 2017 piay. All rights reserved.
//

#import "CocoapodsPane.h"

@implementation CocoapodsPane

- (void)mainViewDidLoad
{
    _shared = self;
}

+ (CocoapodsPane *)shared
{
    return _shared;
}

@end
