//
//  DataTool.m
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "DataTool.h"
#import "SqliteDataFetcher.h"
#import "DBManager.h"
#import "Underscore.h"

@implementation DataTool

#pragma mark - private
+ (SqliteDataFetcher *)dataFetcher {
    
    FMEncryptDatabase *database = [[DBManager manager] getResourceDB];
    SqliteDataFetcher *fetcher = [[SqliteDataFetcher alloc] initWithDBContext:nil database:database dataType:SqliteDataTypeCategory];
    return fetcher;
}

+ (SqliteDataFetcher *)userDataFetcher {
    
    FMEncryptDatabaseQueue *dbQueue = [[DBManager manager] getUserDBContext];
    SqliteDataFetcher *fetcher = [[SqliteDataFetcher alloc] initWithDBContext:dbQueue database:nil dataType:SqliteDataTypeCategoryMusic];
    return fetcher;
}

#pragma mark - public
+ (CategoryModel *)categoryFromMusic:(MusicModel *)music {
    
    CategoryModel *m = nil;
    FMEncryptDatabase *database = [[DBManager manager] getResourceDB];
    FMResultSet *rs = [database executeQuery:@"select * from category where c_id = ?", music.c_id];
    if ([rs next]) {
        m = [[CategoryModel alloc]init];
        [m setValuesForKeysWithDictionary:rs.resultDictionary];
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.jpg",@(m.c_id.integerValue - 1)] ofType:nil];
        ATImageEntity *entity = [ATImageEntity entityWithURL:[NSURL fileURLWithPath:imagePath]];
        m.imageEntity = entity;
    }
    return m;
}

+ (id<DataFetcherProtocol>)listCategoryCallback:(void (^)(BOOL suc, id<DataFetcherProtocol> selfFetcher))callback {
    
    SqliteDataFetcher *fetcher = [DataTool dataFetcher];
    fetcher.dataType = SqliteDataTypeCategory;
    NSString *sql = @"select * from category order by idx asc";
    [fetcher asyncFetchDataSQL:sql callback:callback];
    return fetcher;
}

+ (id<DataFetcherProtocol>)listMusicByCategoryId:(NSNumber *)categoryId callback:(void (^)(BOOL suc, id<DataFetcherProtocol> selfFetcher))callback {
    
    SqliteDataFetcher *fetcher = [DataTool dataFetcher];
    fetcher.dataType = SqliteDataTypeCategoryMusic;
    NSString *sql = [NSString stringWithFormat:@"select * from music where c_id = %@", categoryId];
    [fetcher asyncFetchDataSQL:sql callback:callback];
    return fetcher;
}

+ (id<DataFetcherProtocol>)listSearchByKeyword:(NSString *)keyword {
    SqliteDataFetcher *fetcher = [DataTool dataFetcher];
    fetcher.dataType = SqliteDataTypeCategoryMusic;
    keyword = keyword == nil ? @"" : keyword;
    NSString *sql = [NSString stringWithFormat:@"select * from music where title LIKE '%%%@%%'", keyword];
    [fetcher fetchDataSQL:sql];
    return fetcher;
}

+ (NSArray *)randomMusic {
    
    NSInteger count = 5;
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:count];
    NSArray *d = [Underscore randomNumbersFrom:1 to:20 times:count distinguish:YES];
    
    FMEncryptDatabase *database = [[DBManager manager] getResourceDB];
    for (NSNumber *category_id in d) {
        
        FMResultSet *rs = [database executeQuery:@"select * from music where c_id = ? order by RANDOM() limit 1", category_id];
        if ([rs next]) {
            MusicModel *model = [[MusicModel alloc] init];
            [model setValuesForKeysWithDictionary:rs.resultDictionary];
            [results addObject:model];
        }
    }
    return results;
}

+ (NSArray *)randomMusicCount:(NSInteger)count {
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:count];
    NSArray *d = [Underscore randomNumbersFrom:1 to:20 times:count distinguish:YES];
    
    FMEncryptDatabase *database = [[DBManager manager] getResourceDB];
    for (NSNumber *category_id in d) {
        
        FMResultSet *rs = [database executeQuery:@"select * from music where c_id = ? order by RANDOM() limit 1", category_id];
        if ([rs next]) {
            MusicModel *model = [[MusicModel alloc] init];
            [model setValuesForKeysWithDictionary:rs.resultDictionary];
            [results addObject:model];
        }
    }
    return results;
}

@end
