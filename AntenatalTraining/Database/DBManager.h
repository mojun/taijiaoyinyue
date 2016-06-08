//
//  DBManager.h
//  AntenatalTraining
//
//  Created by test on 16/4/29.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+ (instancetype)manager;

- (FMEncryptDatabase *)getResourceDB;

- (FMEncryptDatabaseQueue *)getUserDBContext;

@end
