//
//  interestModel.h
//  dope
//
//  Created by apple on 2018/11/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface interestModel1 : NSObject
@property (nonatomic,copy)NSString *  interestId;
@property (nonatomic,strong)NSString *  interestName;
@property (nonatomic,strong)NSString *  peopleTotal;
@property (nonatomic,strong)NSString * backgroundUrl;
@property (nonatomic,strong)NSString * materialId;
@property (nonatomic,strong)NSString * materialInfo;

@property (nonatomic,assign)BOOL isSected;

@end

NS_ASSUME_NONNULL_END
