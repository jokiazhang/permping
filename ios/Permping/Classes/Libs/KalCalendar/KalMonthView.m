/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalDate.h"
#import "KalPrivate.h"

#import "PermModel.h"

extern const CGSize kTileSize;

@implementation KalMonthView

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.clipsToBounds = YES;
    for (int i=0; i<6; i++) {
      for (int j=0; j<7; j++) {
        CGRect r = CGRectMake(j*kTileSize.width, i*kTileSize.height, kTileSize.width, kTileSize.height);
        [self addSubview:[[[KalTileView alloc] initWithFrame:r] autorelease]];
      }
    }
  }
  return self;
}

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates
{
  int tileNum = 0;
  NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
  
  for (int i=0; i<3; i++) {
    for (KalDate *d in dates[i]) {
      KalTileView *tile = [self.subviews objectAtIndex:tileNum];
      [tile resetState];
      tile.date = d;
      tile.type = dates[i] != mainDates
                    ? KalTileTypeAdjacent
                    : [d isToday] ? KalTileTypeToday : KalTileTypeRegular;
      tileNum++;
    }
  }
  
  numWeeks = ceilf(tileNum / 7.f);
  [self sizeToFit];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize}, [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] CGImage]);
}

- (KalTileView *)firstTileOfMonth
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if (!t.belongsToAdjacentMonth) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView *)tileForDate:(KalDate *)date
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if ([t.date isEqual:date]) {
      tile = t;
      break;
    }
  }
  // Tuan comment
  //NSAssert1(tile != nil, @"Failed to find corresponding tile for date %@", date);
  
  return tile;
}

- (void)sizeToFit
{
  self.height = 1.f + kTileSize.height * numWeeks;
}

- (void)markTilesForDates:(NSArray *)dates
{
  for (KalTileView *tile in self.subviews)
    tile.marked = [dates containsObject:tile.date];
}

// Tuan added

- (NSDateFormatter*)dateFormat {
    if (dateFormat == nil) {
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return dateFormat;
}

- (void)updateImages:(NSArray*)images { 
    // reset image
    for (KalTileView *v in self.subviews) {
        if (v.images.count > 0) {
            [v resetImages];
            [v setNeedsDisplay];
        }
    }
    
    for (PermModel *perm in images) {
        NSDate *date = [self.dateFormat dateFromString:perm.permDate];
        if (date) {
            KalTileView *tile = [self tileForDate:[KalDate dateFromNSDate:date]];
            [tile addImageUrlString:perm.permImage];
        }
    }
    
}

- (void)dealloc {
    [dateFormat release];
    [super dealloc];
}

@end
