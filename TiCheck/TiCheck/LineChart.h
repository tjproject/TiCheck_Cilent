//
//  LineChart.h
//  LineChart
//
//  Created by 邱峰 on 13-10-20.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LineChart;

@protocol LineChartDataSource <NSObject>

@required

-(NSMutableArray*) setScoreArray;
-(NSMutableArray*) setFooterLabel;
-(int) setCurrentIndex;

@optional

-(UIColor*) setLineColor;
-(UIColor*) setFillColor;
-(float) setlineWidth;
-(float) setPointRadius;
-(BOOL) setIsNeedFill;

/*
 0.01s为单位
 */
-(int) setDelayTime;

@end



@interface LineChart : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,weak) id<LineChartDataSource> lineChartDataSource;
@property (nonatomic,weak) UIScrollView* parentView;
@property (nonatomic,readwrite) BOOL isNeedToDraw;

-(void) resetLineChartData;
-(void) initLineChartMemberData;

@end
