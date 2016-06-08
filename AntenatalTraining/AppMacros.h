//
//  AppMacros.h
//  AntenatalTraining
//
//  Created by test on 16/4/27.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PREFERENCES              [NSUserDefaults standardUserDefaults]
#define PREF_KEY_VALUE(x)        [PREFERENCES valueForKey:(x)]
#define PREF_KEY_BOOL(x)         [PREFERENCES boolForKey:(x)]
#define PREF_KEY_INT(x)          [PREFERENCES integerForKey:(x)]
#define PREF_KEY_SET_VALUE(x, y) [PREFERENCES setValue:y forKey:x]; [PREFERENCES synchronize]
#define PREF_KEY_SET_BOOL(x, y)  [PREFERENCES setBool:y forKey:x]; [PREFERENCES synchronize]
#define PREF_KEY_SET_INT(x, y)   [PREFERENCES setInteger:y forKey:x]; [PREFERENCES synchronize]

#define SSELF __block __typeof(&*self) weakSelf = self;

CGSize screenSize();

CGFloat screenHScale();

UIColor *UIColor_HexString(NSString *stringToConvert);

UIColor *UIColor_RGBA(CGFloat r, CGFloat g, CGFloat b, CGFloat a);

UIColor *UIColor_RGB(CGFloat r, CGFloat g, CGFloat b);

NSArray *arrayFromResource(NSString *fileName);
