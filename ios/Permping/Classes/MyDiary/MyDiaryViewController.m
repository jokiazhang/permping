//
//  MyDiaryViewController.m
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyDiaryViewController.h"
#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "KalView.h"
#import "MyPermDiaryViewController.h"
#import "MyDiaryScreen_DataLoader.h"
#import "AppData.h"

@interface MyDiaryViewController ()
@property (nonatomic, retain, readwrite) NSDate *initialDate;
@property (nonatomic, retain, readwrite) NSDate *selectedDate;
@property (nonatomic, retain, readwrite) NSDateFormatter *dateFormat;
- (KalView*)calendarView;
@end

@implementation MyDiaryViewController
@synthesize dataSource, initialDate, selectedDate, dateFormat, resultModel;


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];
    [initialDate release];
    [selectedDate release];
    [logic release];
    [dateFormat release];
    self.resultModel = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"MyDiaryTabTitle", @"My Diary");
        self.tabBarItem.image = [UIImage imageNamed:@"tab-item-mydiary"];
        
        NSDate *date = [NSDate date];
        logic = [[KalLogic alloc] initForDate:date];
        self.initialDate = date;
        self.selectedDate = date;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    self.initialDate = self.selectedDate;
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSDateFormatter*)dateFormat {
    if (dateFormat == nil) {
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
    }
    return dateFormat;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    headerLabel.text = NSLocalizedString(@"MyDiaryHeader", @"My Diary");
    CGRect r = [[UIScreen mainScreen] applicationFrame];
    r.origin.y = 50;
    kalView = [[[KalView alloc] initWithFrame:r delegate:self logic:logic] autorelease];
    kalView.tableView.hidden = YES;
    [self.view addSubview:kalView];
    [self reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)loadNewData {
    [self cancelAllThreads];
    [self startActivityIndicator];
    self.resultModel.arrResults = nil;
    self.resultModel = [[[Taglist_NDModel alloc] init] autorelease];
    self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadDataForMe:thread:) dataObject:[self getMyDataLoader]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[AppData getInstance] didLogin]) {
        [self loadNewData];
    } else {
        [kalView updateImagesForCurrentMonth:nil];
    }
}

- (KalView*)calendarView { return kalView; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
    if (dataSource != aDataSource) {
        dataSource = aDataSource;
    }
}

- (void)clearTable
{
    [dataSource removeAllItems];
}

- (void)reloadData
{
    [dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self];
}

- (void)significantTimeChangeOccurred
{
    [[self calendarView] jumpToSelectedMonth];
    [self reloadData];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate *)date
{
    self.selectedDate = [date NSDate];
    NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
    NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
    [self clearTable];
    [dataSource loadItemsFromDate:from toDate:to];
    
    MyPermDiaryViewController *controler = [[MyPermDiaryViewController alloc] initWithNibName:@"MyPermDiaryViewController" bundle:nil];
    NSString *theDate = [self.dateFormat stringFromDate:self.selectedDate];

    controler.currentDate = theDate;
    [self.navigationController pushViewController:controler animated:YES];
    [controler release];
}

- (void)showPreviousMonth
{
    [self clearTable];
    [logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
    [self reloadData];
    [self loadNewData];
}

- (void)showFollowingMonth
{
    [self clearTable];
    [logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
    [self reloadData];
    [self loadNewData];
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
    NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
    NSMutableArray *dates = [[markedDates mutableCopy] autorelease];
    NSInteger count = dates.count;
    for (int i=0; i<count; i++)
        [dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
    
    [[self calendarView] markTilesForDates:dates];
    [self didSelectDate:self.calendarView.selectedDate];
}

// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
    if ([[self calendarView] isSliding])
        return;
    
    [logic moveToMonthForDate:date];
    [[self calendarView] jumpToSelectedMonth];
    [[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
    [self reloadData];
}

- (NSDate *)selectedDate
{
    return [self.calendarView.selectedDate NSDate];
}

- (NSString *)currentMonth {
    NSString *month = [self.dateFormat stringFromDate:logic.baseDate];
    return [[month retain] autorelease];
}

- (void)finishLoadData {
    [kalView updateImagesForCurrentMonth:self.resultModel.arrResults];
}

#pragma mark - Override methods
- (id)getMyDataLoader
{
    MyDiaryScreen_DataLoader *loader = [[MyDiaryScreen_DataLoader alloc] init];
    return [loader autorelease];
}

- (void)loadDataForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![threadObj isCancelled]) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //[self initializeUIControls]; 
                           
                       });
        NSArray *arr = nil;
        NSString *userId = [[[AppData getInstance] user] userId];
        PermListResponse *response = [(MyDiaryScreen_DataLoader *)loader getPermWithMonth:[self currentMonth] forUserId:userId];

        arr = [response getResponsePermList];
        
        if (![threadObj isCancelled]) {
            self.resultModel.arrResults = arr;
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                               //reload table
                               [self finishLoadData]; 
                           });
            //[self downloadThumbnailForObjectList:arr];
        }
    }
    //[myLoader release];
    [pool drain];
}

- (void)logoutDidFinish:(NSNotification*)notification {
    if (self == [self.navigationController topViewController]) {
        BOOL isSuccess = [[notification.userInfo objectForKey:@"isSuccess"] boolValue];
        if (isSuccess) {
            [kalView updateImagesForCurrentMonth:nil];
        }
    }
}


@end
