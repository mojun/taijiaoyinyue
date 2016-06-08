//
//  SqliteDataFetcher.m
//  AntenatalTraining
//
//  Created by test on 16/4/29.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "SqliteDataFetcher.h"
#import "CategoryModel.h"
#import "MusicModel.h"

@interface SqliteDataFetcher ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) void (^callback)(BOOL success, id<DataFetcherProtocol> selfFetcher);

@end

@implementation SqliteDataFetcher

- (instancetype)initWithDBContext:(FMDatabaseQueue *)context
                         database:(FMDatabase *)database
                         dataType:(SqliteDataType)dataType {
    if (self = [super init]) {
        _context = context;
        _database = database;
        _dataType = dataType;
        _dataArray = [NSMutableArray array];
        NSAssert(((_context != nil && _database == nil) || (_context == nil && _database != nil)), @"不能同时不为空");
    }
    return self;
}

- (instancetype)initWithDatas:(NSArray *)datas {
    if (self = [super init]) {
        
        _dataArray = [NSMutableArray arrayWithArray:datas];
    }
    return self;
}

- (void)fetchDataSQL:(NSString *)selectSQL {
    
    @synchronized(_dataArray) {
        [_dataArray removeAllObjects];
        if (_context) {
            __weak __typeof(*&self)weakSelf = self;
            [_context inDatabase:^(FMDatabase *db) {
                [weakSelf fetchFromDB:db sql:selectSQL];
            }];
        } else if (_database) {
            [self fetchFromDB:_database sql:selectSQL];
        }
    }
}

- (void)asyncFetchDataSQL:(NSString *)selectSQL
                 callback:(void (^)(BOOL success, id<DataFetcherProtocol> selfFetcher))callback {
    self.callback = callback;
    __weak __typeof(*&self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf fetchDataSQL:selectSQL];
        dispatch_async(dispatch_get_main_queue(), ^{
            void (^b)(BOOL suc, id<DataFetcherProtocol> selfFetcher) = weakSelf.callback;
            if (b) {
                b(YES, weakSelf);
            }
        });
    });
}

- (NSInteger)count {
    return [_dataArray count];
}

- (id)objectAtIndex:(NSInteger)index {
    return [_dataArray objectAtIndex:index];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self objectAtIndex:indexPath.row];
}

- (void)fetchFromDB:(FMDatabase *)db
                sql:(NSString *)selectSQL {
    FMResultSet *rs = [db executeQuery:selectSQL];
    while ([rs next]) {
        [_dataArray addObject:[self ormProc:rs.resultDictionary]];
    }
    [rs close];
}

- (id)ormProc:(id)object {
    switch (_dataType) {
        case SqliteDataTypeCategory: {
            CategoryModel *m = [[CategoryModel alloc] init];
            [m setValuesForKeysWithDictionary:object];
            
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.jpg",@(m.c_id.integerValue - 1)] ofType:nil];
            ATImageEntity *entity = [ATImageEntity entityWithURL:[NSURL fileURLWithPath:imagePath]];
            m.imageEntity = entity;
            return m;
        }
        case SqliteDataTypeCategoryMusic: {
            MusicModel *m = [[MusicModel alloc] init];
            [m setValuesForKeysWithDictionary:object];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.jpg",@(m.c_id.integerValue - 1)] ofType:nil];
            ATImageEntity *entity = [ATImageEntity entityWithURL:[NSURL fileURLWithPath:imagePath]];
            m.imageEntity = entity;
            
            return m;
        }
        default:
            break;
    }
    return object;
}

@end
