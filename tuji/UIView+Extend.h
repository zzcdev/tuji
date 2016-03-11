//
//  VSView+Extend.h
//  VSCommonLib
//
//  Created by Huang on 2/12/11.
//  Copyright 2011 Vita Stone Corp. All rights reserved.
//
// Permission is hereby granted to staffs of Vita Stone Ltd.
// Any person obtaining a copy of this software and associated documentation 
// files (the "Software") should not use, copy, modify, merge, publish, distribute, 
// sublicense, and/or sell copies of the Software without permission granted by 
// Vita Stone Ltd.
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIView (Extend)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGSize  size;
@property (nonatomic) CGPoint origin;

@end
