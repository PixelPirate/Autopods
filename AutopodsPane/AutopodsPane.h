//
//  AutopodsPane.h
//  AutopodsPane
//
//  Created by Patrick Horlebein on 13.07.17.
//  Copyright © 2017 piay. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

@interface AutopodsPane : NSPreferencePane

+ (AutopodsPane *)shared;
- (void)mainViewDidLoad;

@end

static AutopodsPane* _shared = nil;
