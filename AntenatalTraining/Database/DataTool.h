//
//  DataTool.h
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFetcherProtocol.h"
#import "CategoryModel.h"
#import "MusicModel.h"

@interface DataTool : NSObject

+ (id<DataFetcherProtocol>)listCategoryCallback:(void (^)(BOOL suc, id<DataFetcherProtocol> selfFetcher))callback;

+ (id<DataFetcherProtocol>)listMusicByCategoryId:(NSNumber *)categoryId callback:(void (^)(BOOL suc, id<DataFetcherProtocol> selfFetcher))callback;

+ (NSArray *)randomMusic;

+ (CategoryModel *)categoryFromMusic:(MusicModel *)music;

+ (NSArray *)randomMusicCount:(NSInteger)count;

+ (id<DataFetcherProtocol>)listSearchByKeyword:(NSString *)keyword;

@end
