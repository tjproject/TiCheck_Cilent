//
//  BookListViewController.m
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-21.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "BookListViewController.h"
#import "PersonalOrderTableViewCell.h"
#import "BookListSectionView.h"

#define SECTION_BUTTON_TAG_START_INDEX 1000;
#define EXPAND_BUTTON_TAG_START_INDEX 2000;
#define DEFAULT_CELL_NUM 3;


@interface BookListViewController ()
{
    NSMutableArray* bookOrderList;
    
    NSMutableArray* isCellExpanded;
}
@end

@implementation BookListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    self.navigationItem.title=@"我的订阅";
    
    [self initBookOrderList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBookOrderList
{
    bookOrderList=[[NSMutableArray alloc]init];
    isCellExpanded=[[NSMutableArray alloc]init];
    
    for(int i=0; i<4;i++)
    {
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        
        for (int j=0; j<i*3; j++) {
            [temp addObject: [NSString stringWithFormat:@"%i",j*i ]];
        }
        
        [bookOrderList addObject:temp];
    }
    
    
    for (int i=0; i<bookOrderList.count; i++) {
        [isCellExpanded addObject:[NSNumber numberWithInt:0]];
    }
}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return bookOrderList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionCount=((NSMutableArray*)[bookOrderList objectAtIndex:section]).count;
    return [[isCellExpanded objectAtIndex:section] intValue]==1? sectionCount :3;//(sectionCount<=3?sectionCount:3);
}

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    UITableViewHeaderFooterView* sectionView =  [tableView headerViewForSection:section];
//    sectionView.backgroundColor=[UIColor colorWithRed:225/255.0 green:22/255.0 blue:255/255.0 alpha:1.0];
//    
//    
//    return @"test";
//}
//- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)
//{
//    UITableViewHeaderFooterView *view=[[UITableViewHeaderFooterView alloc]init];
//    
//    //
//    view.tintColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//    view.textLabel.text=@"test2";
//    
//    return view;
//}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PersonalOrderCellIdentifier";
    PersonalOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[PersonalOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell initOrderInfoWithFlight:@"东方航空MU5137" Plane:@"320中 经济舱" Time:@"2014-03-11  07:00-09:20" Place:@"虹桥－首都" FlightImage:@"EA_Logo"];
    }
    return cell;
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 39;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* temp=[[UIView alloc]initWithFrame:CGRectMake(0,0, tableView.frame.size.width, 39)];
    temp.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
    
    //add sectionbutton for book change
    UIButton* sectionButton=[UIButton buttonWithType:UIButtonTypeCustom];//initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 39)];
    [sectionButton setFrame:CGRectMake(0, 0, tableView.frame.size.width, 39)];
    [sectionButton setTitle:@"2013-04-13 至 2013-04-25 上海到北京" forState:UIControlStateNormal];
    [sectionButton setTitleColor:[UIColor colorWithRed:12/255.0 green:162/255.0 blue:224/255.0 alpha:1] forState:UIControlStateNormal];
    
    sectionButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12.f];
    [sectionButton addTarget:self action:@selector(sectionListButton:) forControlEvents:UIControlEventTouchUpInside];
    
    sectionButton.tag=section+SECTION_BUTTON_TAG_START_INDEX;
    
    [temp addSubview:sectionButton];
    
    
    
    //bug: section 会被重置  button状态也被重置

    if ( ((NSMutableArray*)[bookOrderList objectAtIndex:section]).count>3) {
        
        //add expand button for expanding all ticket
        UIButton* expandButton=[UIButton buttonWithType:UIButtonTypeCustom];//initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 39)];
        [expandButton setFrame:CGRectMake(260, 0, 70, 39)];
        [expandButton setTitle:@"展开" forState:UIControlStateNormal];
        [expandButton setTitleColor:[UIColor colorWithRed:12/255.0 green:162/255.0 blue:224/255.0 alpha:1] forState:UIControlStateNormal];
        //[expandButton setTitleColor:[UIColor colorWithRed:44/255.0 green:33/255.0 blue:224/255.0 alpha:1] forState:UIControlStateHighlighted];
        [expandButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        expandButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.f];
        [expandButton addTarget:self action:@selector(expandButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        
        expandButton.tag=section+EXPAND_BUTTON_TAG_START_INDEX;
        
        [temp addSubview:expandButton];
        [temp bringSubviewToFront:expandButton];
        
    }
    
    //add separator line
    UIView *separatorline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, temp.frame.size.width, 0.5 )];
    separatorline.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    [temp addSubview:separatorline];
    
    UIView *separatorline2 = [[UIView alloc] initWithFrame:CGRectMake(0, temp.frame.size.height, temp.frame.size.width, 0.5 )];
    separatorline2.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    [temp addSubview:separatorline2];

    

    return temp;
}

- (void) sectionListButton:(id)sender
{
    //
    //NSLog(@"test section button");
    UIButton *temp=(UIButton*)sender;
    NSInteger buttonIndex=temp.tag-SECTION_BUTTON_TAG_START_INDEX;
    NSLog(@"section %d",buttonIndex);
}

- (void) expandButtonFunction:(id)sender
{
    UIButton *temp=(UIButton*)sender;
    NSInteger buttonIndex=temp.tag-EXPAND_BUTTON_TAG_START_INDEX;
    NSLog(@"button %d",buttonIndex);
    
    
    int result =([[isCellExpanded objectAtIndex:buttonIndex] intValue]+1)%2;
    //update state
    [isCellExpanded replaceObjectAtIndex:buttonIndex withObject:[NSNumber numberWithInt:result]];
    
    //bug:在收起cell时， 删除了不该删除的cell
    //animation
    NSMutableArray *changedCellIndexArray = [NSMutableArray array];
    for (NSInteger i = 0; i < (((NSMutableArray*)[bookOrderList objectAtIndex:buttonIndex]).count-3 ); i++)
    {
        NSIndexPath *toChangedCell = [NSIndexPath indexPathForRow: 3+i inSection:buttonIndex];
        [changedCellIndexArray addObject:toChangedCell];
    }
    if(result==1)
    {
        [temp setTitle:@"收起" forState:UIControlStateNormal];
        //expand, add cells
        //[self.bookListTableView beginUpdates];
        [self.bookListTableView insertRowsAtIndexPaths:changedCellIndexArray withRowAnimation:UITableViewRowAnimationTop];
        //[self.bookListTableView endUpdates];
    }
    else if(result==0)
    {
        [temp setTitle:@"展开" forState:UIControlStateNormal];
        //unexpand, delete cells
        //[self.bookListTableView beginUpdates];
        [self.bookListTableView deleteRowsAtIndexPaths:changedCellIndexArray withRowAnimation:UITableViewRowAnimationTop];
        //[self.bookListTableView endUpdates];
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    NSInteger moreOptionsBeginCounter = 3;
//    if (isReturn) moreOptionsBeginCounter++;
//    
//    NSMutableArray *moreOptionIndexArray = [NSMutableArray array];
//    for (NSInteger i = 0; i < 4; ++i) {
//        NSIndexPath *toAddOption = [NSIndexPath indexPathForRow:moreOptionsBeginCounter + i inSection:0];
//        [moreOptionIndexArray addObject:toAddOption];
//    }
//    
//    NSIndexPath *moreButton = [NSIndexPath indexPathForRow:moreOptionsBeginCounter inSection:0];
//    
//    [self.searchOptionTableView beginUpdates];
//    [self.searchOptionTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:moreButton] withRowAnimation:UITableViewRowAnimationTop];
//    [self.searchOptionTableView insertRowsAtIndexPaths:moreOptionIndexArray withRowAnimation:UITableViewRowAnimationTop];
//    [self.searchOptionTableView endUpdates];
//    
    
    
    
    
    
    
    
    //change it to cell animation insertion
    //[self.bookListTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
