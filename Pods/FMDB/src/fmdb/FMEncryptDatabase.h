//
//  FMEncryptDatabase.h
//  FmdbDemo
//
//  Created by ZhengXiankai on 15/7/31.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.
//
#import <FMDB/FMDatabase.h>

@interface FMEncryptDatabase : FMDatabase

/** 如果需要自定义encryptkey，可以调用这个方法修改（在使用之前）*/
+ (void)setEncryptKey:(NSString *)encryptKey;

@end
