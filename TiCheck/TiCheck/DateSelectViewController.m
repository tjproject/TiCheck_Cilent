//
//  DateSelectViewController.m
//  TiCheck
//
//  Created by Boyi on 4/21/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "DateSelectViewController.h"
#import "PDTSimpleCalendar.h"

@interface DateSelectViewController () <PDTSimpleCalendarViewDelegate>

@property (strong, nonatomic) PDTSimpleCalendarViewController *calendarViewController;

@property (weak, nonatomic) IBOutlet UIButton *todayButton;

@end

@implementation DateSelectViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.todayButton.hidden = self.isTodayButtonHidden;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setIsTodayButtonHidden:(BOOL)isTodayButtonHidden
{
    _isTodayButtonHidden = isTodayButtonHidden;
    self.todayButton.hidden = _isTodayButtonHidden;
}

#pragma mark - Click Event

- (IBAction)closeClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)todayClicked:(id)sender
{
    [self.calendarViewController updateSelectedDateWithoutDelegateNotify:[NSDate date]];
    [self.calendarViewController scrollToSelectedDate:YES];
}

#pragma mark - Calendar Delegate

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    switch (self.routeType) {
        case Take_Off:
            [self.delegate setTakeOffTimeLabel:date];
            break;
        case Return:
            [self.delegate setReturnTimeLabel:date];
            break;
    }
    
    self.calendarViewController.view.userInteractionEnabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(dismissCalendarViewController) userInfo:nil repeats:NO];
}

- (void)dismissCalendarViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"EmbedCalendarSegue"]) {
        self.calendarViewController = [segue destinationViewController];
        self.calendarViewController.delegate = self;
        
        self.calendarViewController.firstDate = self.beginDate;
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        offsetComponents.day = 150;
//        offsetComponents.month = 5;
        NSDate *lastDate = [self.calendarViewController.calendar dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
        self.calendarViewController.lastDate = lastDate;
        [self.calendarViewController updateSelectedDateWithoutDelegateNotify:self.selectedDate];
        [self.calendarViewController scrollToSelectedDate:YES];
    }
}


@end
