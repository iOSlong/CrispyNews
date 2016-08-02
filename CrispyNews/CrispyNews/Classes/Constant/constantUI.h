//
//  constantUI.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/2.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#ifndef constantUI_h
#define constantUI_h


// Color helpers
#define RGBCOLOR(r,g,b)                                     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)                                  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define RGBCOLOR_HEX(h)                                     RGBCOLOR((((h)>>16)&0xFF), (((h)>>8)&0xFF), ((h)&0xFF))
#define RGBACOLOR_HEX(h,a)                                  RGBACOLOR((((h)>>16)&0xFF), (((h)>>8)&0xFF), ((h)&0xFF), (a))
#define RGBPureColor(h)                                     RGBCOLOR(h, h, h)
#define HSVCOLOR(h,s,v)                                     [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
#define HSVACOLOR(h,s,v,a)                                  [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]
#define RGBA(r,g,b,a)                                       (r)/255.0f, (g)/255.0f, (b)/255.0f, (a)




#endif /* constantUI_h */
