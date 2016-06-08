//
//  FMEncryptDatabaseQueue.m
//  FmdbDemo
//
//  Created by ZhengXiankai on 15/7/31.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.

#import "FMEncryptDatabaseQueue.h"
#import "FMEncryptDatabase.h"

@implementation FMEncryptDatabaseQueue

+ (Class)databaseClass
{
    return [FMEncryptDatabase class];
}

@end
