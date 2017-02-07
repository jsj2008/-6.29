//
//  TimeLineViewController.h
//  SalesHelper_A
//
//  Created by ZhipuTech on 15/6/12.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "BaseViewController.h"
#import "ModelViewController.h"

@interface TimeLineViewController : ModelViewController

@property (nonatomic,retain)NSDictionary * customerInfo;

@property (nonatomic , retain)NSDictionary * propertyInfo;

@property (nonatomic, copy) NSString *timeLineID;

@property (nonatomic,assign)BOOL isFromPushIn;
@end