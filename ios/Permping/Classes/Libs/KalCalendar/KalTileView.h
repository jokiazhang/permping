/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

enum {
  KalTileTypeRegular   = 0,
  KalTileTypeAdjacent  = 1 << 0,
  KalTileTypeToday     = 1 << 1,
};
typedef char KalTileType;

@class KalDate;

@interface KalTileView : UIView <SDWebImageManagerDelegate>
{
  KalDate *date;
  CGPoint origin;
  struct {
    unsigned int selected : 1;
    unsigned int highlighted : 1;
    unsigned int marked : 1;
    unsigned int type : 2;
  } flags;
    
    
    // Tuan added
    NSUInteger _requestedCount;
}

@property (nonatomic, retain) KalDate *date;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isMarked) BOOL marked;
@property (nonatomic) KalTileType type;

- (void)resetState;
- (BOOL)isToday;
- (BOOL)belongsToAdjacentMonth;

// Tuan added
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSArray *imageUrls;

- (void)addImageUrlString:(NSString*)urlString;

- (void)resetImages;
@end
