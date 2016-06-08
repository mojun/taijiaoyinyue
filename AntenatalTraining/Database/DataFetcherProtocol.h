//
//  DataFetcherProtocol.h
//  AntenatalTraining
//
//  Created by test on 16/4/29.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

@protocol DataFetcherProtocol <NSObject>

@required
/**
 *  @brief 获取数据当前数
 *
 *  @return 数据总数
 */
- (NSInteger)count;

/**
 *  @brief 获取指定位置的数据
 *
 *  @param index 位置序号
 *
 *  @return 指定位置的数据
 */
- (id)objectAtIndex:(NSInteger)index;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)dataArray;

@end
