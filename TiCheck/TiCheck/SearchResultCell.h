//
//  SearchResultCell.h
//  TiCheck
//
//  Created by 邱峰 on 14-4-3.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

/**
 *  航班的标志 logo
 */
@property (weak, nonatomic) IBOutlet UIImageView *flightLogo;

/**
 *  起飞时间 07：00
 */
@property (weak, nonatomic) IBOutlet UILabel *startTime;

/**
 *  到达时间 09：20
 */
@property (weak, nonatomic) IBOutlet UILabel *endTime;

/**
 *  地点 虹桥——北京
 */
@property (weak, nonatomic) IBOutlet UILabel *address;

/**
 *  折扣信息 4.3折
 */
@property (weak, nonatomic) IBOutlet UILabel *discount;

/**
 *  价格 ￥1520
 */
@property (weak, nonatomic) IBOutlet UILabel *price;

/**
 *  航班编号  东航MU5173
 */
@property (weak, nonatomic) IBOutlet UILabel *flightNumber;

/**
 *  航班类型  320中
 */
@property (weak, nonatomic) IBOutlet UILabel *flighModel;

/**
 *  价格类型  经济舱/头等舱
 */
@property (weak, nonatomic) IBOutlet UILabel *priceType;

/**
 *  是否有余票  有余票/少量票
 */
@property (weak, nonatomic) IBOutlet UILabel *remain;

@end
