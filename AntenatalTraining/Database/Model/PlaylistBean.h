//
//  PlaylistBean.h
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaylistBean : NSObject

@property (nonatomic, strong) NSNumber *playlist_id;
@property (nonatomic, strong) NSNumber *order_index;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *song_num;

@end
