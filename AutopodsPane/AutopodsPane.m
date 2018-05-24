//
//  AutopodsPane.m
//  AutopodsPane
//
//  Created by Patrick Horlebein on 13.07.17.
//  Copyright © 2017 piay. All rights reserved.
//

#import "AutopodsPane.h"

@implementation AutopodsPane

- (void)mainViewDidLoad
{
    _shared = self;
}

+ (AutopodsPane *)shared
{
    return _shared;
}

@end
