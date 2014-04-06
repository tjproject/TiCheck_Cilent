//
//  LineChart.m
//  LineChart
//
//  Created by 邱峰 on 13-10-20.
//  Copyright (c) 2013年 邱峰. All rights reserved.
//

#import "LineChart.h"

@interface LineChart ()

@property (nonatomic,strong) NSMutableArray* scoreArray;   //每个点的高度
@property (nonatomic,strong) NSMutableArray* price;
@property (nonatomic,strong) NSMutableArray* footerLabel;   //每个点的高度

@property (nonatomic,readwrite) int delayTime;      //每2个点之间的画线时间
@property (nonatomic,retain) UIColor* lineColor;    //线颜色
@property (nonatomic,retain) UIColor* fillColor;    //填充颜色
@property (nonatomic,readwrite) float lineWidth;      //线宽度
@property (nonatomic,readwrite) int indexScore;     //画到第几个点
@property (nonatomic,readwrite) float pointRadius;  //点半径
@property (nonatomic,readwrite) BOOL isNeedFill;    //是否需要填充背景
@property (nonatomic,readwrite) int currentIndex;


@end

@implementation LineChart
{
    int nowDelay;
    float average;
    BOOL isAlreadyInit;
    BOOL isNeedReset;
    float minData;
}

@synthesize lineChartDataSource=_lineChartDataSource;


@synthesize scoreArray=_scoreArray;
@synthesize delayTime=_delayTime;
@synthesize lineColor=_lineColor;
@synthesize fillColor=_fillColor;

@synthesize lineWidth=_lineWidth;
@synthesize isNeedFill=_isNeedFill;

@synthesize indexScore=_indexScore;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(NSMutableArray*) footerLabel
{
    if (_footerLabel==nil)
    {
        _footerLabel=[self.lineChartDataSource setFooterLabel];
    }
    return _footerLabel;
}

-(NSMutableArray*) scoreArray
{
    if (_scoreArray==nil)
    {
        _scoreArray=[self.lineChartDataSource setScoreArray];
        
        self.price=[[NSMutableArray alloc] initWithArray:_scoreArray copyItems:YES];
        [self getMinData];
        
        if (_scoreArray==nil || _scoreArray.count==0)
        {
            [_scoreArray addObject:@(0)];
            [_scoreArray addObject:@(0)];
            return _scoreArray;
        }
        
        //前后各插入一个数据
        
        self.parentView.delegate=self;
        float maxObj=0;
        float minObj=100000;
        for (NSNumber* obj in _scoreArray)
        {
            if ([obj floatValue]>maxObj) maxObj=[obj floatValue];
            if ([obj floatValue]<minObj) minObj=[obj floatValue];
        }
        
        
        float firstObj=[[_scoreArray firstObject] floatValue];
        
        if (_scoreArray.count==1)
        {
            [_scoreArray addObject:@(firstObj)];
            [_scoreArray addObject:@(firstObj)];
        }
        else
        {
            float second=[[_scoreArray objectAtIndex:1] floatValue];
            float insert=firstObj-(second-firstObj);
            insert=MAX(minObj, insert);
            insert=MIN(maxObj, insert);
            [_scoreArray insertObject:@(insert) atIndex:0];
            
            float secondLast=[[_scoreArray objectAtIndex:_scoreArray.count-2] floatValue];
            float lastObj=[[_scoreArray lastObject] floatValue];
            float insertLast=lastObj-secondLast+lastObj;
            insertLast=MIN(maxObj, insertLast);
            insertLast=MAX(minObj, insertLast);
            [_scoreArray addObject:@(insertLast)];
        }
    }
    return _scoreArray;
}

-(int) currentIndex
{
    return [self.lineChartDataSource setCurrentIndex];
}

-(int) delayTime
{
    if (_delayTime==0)
    {
        if ([self.lineChartDataSource respondsToSelector:@selector(setDelayTime)])
        {
            _delayTime=[self.lineChartDataSource setDelayTime];
            if (_delayTime<=0) _delayTime=1;
        }
        else   _delayTime=5;
    }
    return _delayTime;
}

-(float) lineWidth
{
    if (_lineWidth==0)
    {
        if ([self.lineChartDataSource respondsToSelector:@selector(setlineWidth)])
        {
            _lineWidth=[self.lineChartDataSource setlineWidth];
            if (_lineWidth<=0) _lineWidth=1;
        }
        else _lineWidth=1;
    }
    return _lineWidth;
}

-(UIColor*) lineColor
{
    if (_lineColor==nil)
    {
        if ([self.lineChartDataSource respondsToSelector:@selector(setLineColor)])
        {
            _lineColor=[self.lineChartDataSource setLineColor];
        }
        else
        {
            _lineColor=[UIColor blackColor];
        }
    }
    return _lineColor;
}

-(UIColor*) fillColor
{
    if (_fillColor==nil)
    {
        if ([self.lineChartDataSource respondsToSelector:@selector(setFillColor)])
        {
            _fillColor=[self.lineChartDataSource setFillColor];
        }
        else
        {
            _fillColor=[UIColor blackColor];
        }
    }
    return _fillColor;
}

-(float) pointRadius
{
    if (_pointRadius==0)
    {
        if ([self.lineChartDataSource respondsToSelector:@selector(setPointRadius)])
        {
            _pointRadius=[self.lineChartDataSource setPointRadius];
        }
        else
        {
            _pointRadius=0.01;
        }
    }
    return _pointRadius;
}

-(BOOL) isNeedFill
{
    if (_isNeedFill==NO)
    {
        if ([self.lineChartDataSource respondsToSelector:@selector(setIsNeedFill)])
        {
            _isNeedFill=[self.lineChartDataSource setIsNeedFill];
        }
        else
        {
            _isNeedFill=NO;
        }
    }
    return _isNeedFill;
}


-(void) getMinData
{
    minData=1000000000.0;
    for (int i=0; i<self.price.count; i++)
    {
        if ([[self.price objectAtIndex:i] floatValue]<minData) minData=[[self.price objectAtIndex:i] floatValue];
    }
}

-(void) initLineChartMemberData
{
    self.backgroundColor=[UIColor whiteColor];
    if (isAlreadyInit) return ;
    isAlreadyInit=YES;
    
    float width=self.parentView.frame.size.width;
    float height=self.parentView.frame.size.height;
    self.parentView.scrollEnabled=NO;
    average=width/(self.scoreArray.count-1);
    if (average<20)  average=20;
    
    self.parentView.contentSize=CGSizeMake(average*(self.scoreArray.count-1), self.frame.size.height);
    self.frame=CGRectMake(0, 0, self.parentView.contentSize.width, self.parentView.frame.size.height);
    
    int maxScore=0;
    int minScore=1000000;
    
    for (NSNumber* score in self.scoreArray)
    {
        if (maxScore<[score floatValue]) maxScore=[score intValue];
        if (minScore>[score floatValue]) minScore=[score intValue];
    }
    minScore=MIN(50, minScore);
    maxScore=maxScore+500;
    
    //不断循环 直到minscore和maxscore相差10以上 间隔为10的倍数
    int i=0;
    while (maxScore-minScore<9 || (maxScore-minScore) %9 !=0 )
    {
        if ( (i & 1) == 0)              //奇数加min 偶数加max  使得在调整最大最小值以后可以间距正好,目的是为了轮流加
        {
            maxScore=MIN(maxScore+1,999);
        }
        else
        {
            minScore=MAX(0,minScore-1);
        }
        i++;
    }
    
    for (int i=0; i<self.scoreArray.count; i++)
    {
        float fixScore=[[self.scoreArray objectAtIndex:i] floatValue]-minScore;
        fixScore=fixScore/(maxScore-minScore)*(height-height/10);           //乘以的高度要减去第一格不被占用的
        [self.scoreArray replaceObjectAtIndex:i withObject:@(fixScore)];
    }
}

//填充从poinX到pointY的所有点
-(void) fillScoreFromPoint:(CGPoint)pointX toPoint:(CGPoint)pointY withColor:(UIColor*)color inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    CGContextBeginPath(context);
    
    float height=self.frame.size.height;
    
    CGContextMoveToPoint(context, pointX.x, height);
    CGContextAddLineToPoint(context, pointX.x, pointX.y);
    CGContextAddLineToPoint(context, pointY.x, pointY.y);
    CGContextAddLineToPoint(context, pointY.x, height);
    
    [color set];
    CGContextFillPath(context);
    
    UIGraphicsPopContext();

}

//填充前面不用动画的线
-(void) addLineFromPoint:(CGPoint)pointX toPoint:(CGPoint)PointY withColor:(UIColor*)color lineWidth:(float)lineWidth inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, pointX.x, pointX.y);
    CGContextAddLineToPoint(context, PointY.x, PointY.y);
    
    [color set];
    CGContextSetLineWidth(context, lineWidth);
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

//在坐标为midpoint的地方画一个半径为radius 空心白色 边框3
-(void) drawCircleAtMiddlePoint:(CGPoint)midPoint withRadius:(float)radius inContext:(CGContextRef)context useColor:(UIColor*)color
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, midPoint.x, midPoint.y, radius, 0, 2*M_PI, YES);
    
    [[UIColor whiteColor] set];
    CGContextFillPath(context);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, midPoint.x, midPoint.y, radius, 0, 2*M_PI, YES);
    [color set];
    CGContextSetLineWidth(context, self.pointRadius);
    CGContextStrokePath(context);

    
    UIGraphicsPopContext();
}

//画出从index-1 到 第index个点的时候曲线移动动画
const float afterDelay=0.01;
-(void) drawScoreAnimateAtIndex:(int)index inContext:(CGContextRef)context
{
    CGFloat frameHeight=self.frame.size.height;
    if (index<self.scoreArray.count)
    {
        float height1=[[self.scoreArray objectAtIndex:index-1] floatValue];
        float height2=[[self.scoreArray objectAtIndex:index] floatValue];
        
        CGPoint point1=CGPointMake(average*(index-1),frameHeight-height1);
        
        float heightDis=height2-height1;    //前后2个坐标高度差
        
        CGPoint point2=CGPointMake( point1.x+average*nowDelay/self.delayTime, frameHeight-(height1+heightDis*nowDelay/self.delayTime));
        
        [self addLineFromPoint:point1  toPoint:point2 withColor:self.lineColor lineWidth:self.lineWidth  inContext:context];
        if (self.isNeedFill)
        {
            [self fillScoreFromPoint:point1 toPoint:point2 withColor:self.fillColor inContext:context];
        }
    }
}

-(void) drawLable:(NSString*)str atPoint:(CGPoint)point withDictionary:(NSDictionary*)dic inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    [str drawAtPoint:point withAttributes:dic];
    UIGraphicsPopContext();
}

-(void) drawImgeAtPoint:(CGPoint)point image:(UIImage*)img inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    [img drawAtPoint:point];
    UIGraphicsPopContext();
}

-(void) drawFooterAtMidPoint:(CGPoint)midPoint atIndex:(int)i inContext:(CGContextRef)context
{
    CGFloat frameHeight=self.frame.size.height;
    NSDictionary* dictionary=[NSDictionary dictionaryWithObjectsAndKeys:
                              [UIColor colorWithRed:149/255.0 green:169/255.0 blue:108/255.0 alpha:1],NSForegroundColorAttributeName,
                              [UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    
    NSString* str=[NSString stringWithFormat:@"%@",[self.footerLabel objectAtIndex:i-1]];
    if (str.length==1) str=[NSString stringWithFormat:@"0%@",str];
    [self drawLable:str atPoint:CGPointMake(midPoint.x-8, frameHeight-20) withDictionary:dictionary inContext:context];
}

-(void) drawPriceAtMidPoint:(CGPoint)midPoint atIndex:(int)i inContext:(CGContextRef)context
{
    if ([[self.price objectAtIndex:i-1] floatValue]==minData)   //最低价
    {
        NSDictionary* dictionary=[NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor colorWithRed:236/255.0 green:99/255.0 blue:51/255.0 alpha:1],NSForegroundColorAttributeName,
                                  [UIFont systemFontOfSize:15],NSFontAttributeName,nil];
        [self drawImgeAtPoint:CGPointMake(midPoint.x-10, midPoint.y-30) image:[UIImage imageNamed:@"lowPrice"] inContext:context];
        [self drawLable:[NSString stringWithFormat:@"%@",[self.price objectAtIndex:i-1]] atPoint:CGPointMake(midPoint.x-13, midPoint.y-50) withDictionary:dictionary inContext:context];
        
    }
    else if (i-1==self.currentIndex)                                            //当前
    {
        NSDictionary* dictionary=[NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor colorWithRed:7/255.0 green:159/255.0 blue:221/255.0 alpha:1],NSForegroundColorAttributeName,
                                  [UIFont systemFontOfSize:15],NSFontAttributeName,nil];
        [self drawImgeAtPoint:CGPointMake(midPoint.x-10, midPoint.y-30) image:[UIImage imageNamed:@"nowPrice"] inContext:context];
        [self drawLable:[NSString stringWithFormat:@"%@",[self.price objectAtIndex:i-1]] atPoint:CGPointMake(midPoint.x-13, midPoint.y-50) withDictionary:dictionary inContext:context];
    }
    else                                                        //普通
    {
        NSDictionary* dictionary=[NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor colorWithRed:255/255.0 green:152/255.0 blue:0 alpha:1],NSForegroundColorAttributeName,
                                  [UIFont systemFontOfSize:15],NSFontAttributeName,nil];
        [self drawLable:[NSString stringWithFormat:@"%@",[self.price objectAtIndex:i-1]] atPoint:CGPointMake(midPoint.x-13, midPoint.y-20) withDictionary:dictionary inContext:context];
    }

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!self.isNeedToDraw) return ;
    
    if (isNeedReset)
    {
        [self startResetData];
        /*
         注意把scrollview的offset清空
         */
        self.parentView.contentOffset=CGPointZero;
        self.isNeedToDraw=YES;
    }
    
    if (self.indexScore>self.scoreArray.count) self.indexScore=(int)self.scoreArray.count ;
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGFloat frameHeight=self.frame.size.height;
 
    
    if (self.indexScore==0)
    {
        [self initLineChartMemberData];
        self.indexScore++;
    }
    
    [self drawScoreAnimateAtIndex:self.indexScore inContext:context];
    
    for (int i=1; i<self.indexScore; i++)
    {
        float height1=[[self.scoreArray objectAtIndex:i-1] floatValue];
        float height2=[[self.scoreArray objectAtIndex:i] floatValue];
        CGPoint point1=CGPointMake( average*(i-1), frameHeight-height1);
        CGPoint point2=CGPointMake( average*i, frameHeight-height2 );
        
        
        [self addLineFromPoint:point1 toPoint:point2 withColor:self.lineColor lineWidth:self.lineWidth inContext:context];
        
        if (self.isNeedFill)
        {
            [self fillScoreFromPoint:point1 toPoint:point2 withColor:self.fillColor inContext:context];
        }
    }
    
    /**
     *  画出已经self.indexScore之前的点
     */
    for (int i=1; i<self.indexScore; i++)
    {
        if (i<self.scoreArray.count-1)
        {
            CGPoint midPoint=CGPointMake(average*i,frameHeight-[[self.scoreArray objectAtIndex:i] floatValue]);
            
            if ([[self.price objectAtIndex:i-1] floatValue]==minData)
            {
                [self drawCircleAtMiddlePoint:midPoint withRadius:self.pointRadius inContext:context useColor:[UIColor colorWithRed:236/255.0 green:99/255.0 blue:51/255.0 alpha:1]];
            }
            else if (i-1==self.currentIndex)
            {
                [self drawCircleAtMiddlePoint:midPoint withRadius:self.pointRadius inContext:context useColor:[UIColor colorWithRed:7/255.0 green:159/255.0 blue:221/255.0 alpha:1]];
            }
            else
            {
                [self drawCircleAtMiddlePoint:midPoint withRadius:self.pointRadius inContext:context useColor:self.lineColor];
            }
            

            [self addLineFromPoint:CGPointMake(midPoint.x, midPoint.y+self.pointRadius*2) toPoint:CGPointMake(midPoint.x, frameHeight) withColor:[UIColor colorWithRed:229/255.0 green:238/255.0 blue:211/255.0 alpha:1] lineWidth:1 inContext:context];
            [self drawFooterAtMidPoint:midPoint atIndex:i inContext:context];
            [self drawPriceAtMidPoint:midPoint atIndex:i inContext:context];
        }
    }
    
    [self performSelector:@selector(addNowDelay) withObject:self afterDelay:afterDelay];

}

-(void) addNowDelay
{
    nowDelay++;
    if (nowDelay>=self.delayTime)
    {
        nowDelay=0;
        self.indexScore++;
        if ((self.indexScore-1)*average>=self.parentView.frame.size.width)  //画好屏幕上的宽度
        {
            self.indexScore=(int)self.scoreArray.count;
            self.parentView.scrollEnabled=YES;
            return ;
        }
    }
    
    [self setNeedsDisplay];
}


-(void) resetLineChartData
{
    if (nowDelay==0 && self.indexScore==self.scoreArray.count)
    {
        isNeedReset=YES;
        [self setNeedsDisplay];
    }
    else
    {
        isNeedReset=YES;
    }
}

-(void) startResetData
{
    self.scoreArray=nil;
    self.delayTime=0;
    self.lineColor=nil;
    self.fillColor=nil;
    self.lineWidth=0;
    self.indexScore=0;
    self.pointRadius=0;
    self.isNeedFill=NO;
    nowDelay=0;
    average=0;
    isAlreadyInit=NO;
    isNeedReset=NO;
}


@end
