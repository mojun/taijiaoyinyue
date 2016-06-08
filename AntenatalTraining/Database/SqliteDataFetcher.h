//
//  SqliteDataFetcher.h
//  AntenatalTraining
//
//  Created by test on 16/4/29.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFetcherProtocol.h"

typedef NS_ENUM(NSInteger, SqliteDataType) {
    SqliteDataTypeCategory,
    SqliteDataTypeCategoryMusic,
    SqliteDataTypePlaylist,
    SqliteDataTypePlaylistMusic
};

@interface SqliteDataFetcher : NSObject<DataFetcherProtocol>

@property (nonatomic, assign) SqliteDataType dataType;
@property (nonatomic, strong, readonly) FMDatabaseQueue *context;
@property (nonatomic, strong, readonly) FMDatabase *database;

- (instancetype)initWithDBContext:(FMDatabaseQueue *)context
                         database:(FMDatabase *)database
                         dataType:(SqliteDataType)dataType;

- (instancetype)initWithDatas:(NSArray *)datas;

- (void)fetchDataSQL:(NSString *)selectSQL;

- (void)asyncFetchDataSQL:(NSString *)selectSQL
                 callback:(void (^)(BOOL success, id<DataFetcherProtocol> selfFetcher))callback;

@end
