//
//  CocoapodsPane.h
//  CocoapodsPane
//
//  Created by Patrick Horlebein on 13.07.17.
//  Copyright © 2017 piay. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

@interface CocoapodsPane : NSPreferencePane

+ (CocoapodsPane *)shared;
- (void)mainViewDidLoad;

@end

static CocoapodsPane* _shared = nil;
