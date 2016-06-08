//
//  CategoryModel.h
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATImageEntity.h"

@interface CategoryModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *c_id;
@property (nonatomic, strong) NSString *c_pic;
@property (nonatomic, strong) NSNumber *idx;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) ATImageEntity *imageEntity;

@end
