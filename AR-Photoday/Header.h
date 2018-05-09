//
//  Header.h
//  AR-Photoday
//
//  Created by Vincent Au on 8/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

#ifndef Header_h
#define Header_h
#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
    blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
    alpha:1.0]


#define AD_SIZE CGSizeMake(320, 50)
+ (CGSize)adSize;

#endif /* Header_h */
