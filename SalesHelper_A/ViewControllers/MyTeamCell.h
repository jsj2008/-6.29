//
//  MyTeamCell.h
//  SalesHelper_A
//
//  Created by flysss on 16/5/17.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTeamCell : UITableViewCell

@property (nonatomic, strong) UIImageView * headImg;

@property (nonatomic, strong) UILabel * nameLab;

@property (nonatomic, strong) UILabel * genderLab;

@property (nonatomic, strong) UIImageView * genderImg;

@property (nonatomic, strong) UILabel * phoneLab;

@property (nonatomic, strong) UILabel * numberLab;

@property (nonatomic, strong) UIButton * messageBtn;

@property (nonatomic, strong) UIImageView * sympolImg;




-(void)setAttributeForCellWithDictionary:(NSDictionary*)dict;


@end