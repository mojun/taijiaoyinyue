//
//  FMEncryptHelper.h
//  FmdbDemo
//
//  Created by ZhengXiankai on 15/8/26.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMEncryptHelper : NSObject

/** 如果需要自定义encryptkey，可以调用这个方法修改（在使用之前）*/
+ (void)setEncryptKey:(NSString *)encryptKey;

/** 对数据库加密 */
+ (BOOL)encryptDatabase:(NSString *)path;

/** 对数据库解密 */
+ (BOOL)unEncryptDatabase:(NSString *)path;

/** 对数据库加密 */
+ (BOOL)encryptDatabase:(NSString *)sourcePath targetPath:(NSString *)targetPath;

/** 对数据库解密 */
+ (BOOL)unEncryptDatabase:(NSString *)sourcePath targetPath:(NSString *)targetPath;

/** 修改数据库秘钥 */
+ (BOOL)changeKey:(NSString *)dbPath originKey:(NSString *)originKey newKey:(NSString *)newKey;

@end
