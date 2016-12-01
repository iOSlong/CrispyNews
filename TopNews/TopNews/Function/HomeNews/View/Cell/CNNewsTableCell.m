//
//  CNNewsTableCell.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/19.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNNewsTableCell.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "CNImageView+CN.h"

@implementation CNCellCaculate

+ (instancetype)shareCellCaculate {
    static CNCellCaculate *thisObj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thisObj = [[CNCellCaculate alloc] init];
        thisObj.label.text = @"";
        
    });
    return thisObj;
}

- (UILabel *)label{
    if (!_label) {
        _label =  [UILabel labelFrame:CGRectMake(k_SpanLeft, k_SpanIn, 10, 10) fontSize:[CNUtils fontSizePreference:16] textColor:CNCOLOR_TEXT_TITLE];
        _label.font = [CNUtils fontPreference:FONT_Helvetica size:16];
    }
    return _label;
}

@end


@implementation CNNewsTableCell

CGFloat cellBarH() {
    return 28 * kRATIO;
}
CGFloat cellContentW() {
    return SCREENW - 2 * k_SpanLeft;
}

CGFloat cellTextW(CNNewsCellType type) {
    if (type == CNNewsCellTypeImgvSideR) {
        return cellContentW() - cellImgvW(type) - k_SpanLeft;
    }
    return cellContentW();
}

CGFloat cellImgvH(CNNewsCellType type) {
    if (type == CNNewsCellTypeImgvFull) {
        return cellContentW() * (328.0/690.0);
    }else if (type == CNNewsCellTypeImgvParts) {
        return cellImgvW(type) * (148.0/226.0);
    }
    return cellImgvW(type) * (148.0/226.0);
}

CGFloat cellImgvW(CNNewsCellType type) {
    if (type == CNNewsCellTypeImgvFull) {
        return cellContentW();
    }else if (type == CNNewsCellTypeImgvSideR) {
        return ((cellContentW() - k_SpanIn)/3);
    }else if (type == CNNewsCellTypeImgvParts) {
        return (cellContentW() - k_SpanIn)/3;
    }
    return 0;
}

- (UIView *)viewBase {
    if (!_viewBase) {
        _viewBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 50)];
    }
    return _viewBase;
}

- (UIButton *)btnCheck {
    if (!_btnCheck) {
        _btnCheck = [UIButton buttonFrame:CGRectMake(0, 0, 38, 38) imgSelected:@"ic_cirRed" imgNormal:@"ic_cirGray" target:self action:@selector(checkBtnClick:) mode:UIViewContentModeScaleAspectFill ContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _btnCheck;
}

- (void)checkBtnClick:(UIButton *)btnCeck {
    btnCeck.selected = !btnCeck.selected;
    self.news.marked = btnCeck.selected;
    _marked = self.news.marked;
    CNNewsCellEvent event = CNNewsCellEventMark;
    if (btnCeck.selected == NO) {
        event = CNNewsCellEventMarkNess;
    }
    if ([self.delegate respondsToSelector:@selector(cellNews:event:info:)]) {
        [self.delegate cellNews:_news event:event info:@{@"event":@"longPress"}];
    }
}

- (void)setMarked:(BOOL)marked {
    _marked = marked;
    _btnCheck.selected  = marked;
    self.news.marked    = marked;
    CNNewsCellEvent event = CNNewsCellEventMark;
    if (_btnCheck.selected == NO) {
        event = CNNewsCellEventMarkNess;
    }
    if ([self.delegate respondsToSelector:@selector(cellNews:event:info:)]) {
        [self.delegate cellNews:_news event:event info:@{@"event":@"longPress"}];
    }
}



- (instancetype)initWithStyle:(CNNewsCellType)type reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = RGBCOLOR_HEX(0x543223);
        [self.contentView addSubview:self.viewBase];
        /// 添加删除check按钮
        [self.contentView addSubview:self.btnCheck];
        self.btnCheck.alpha = 0;
        
        /// 0. celll类型 type
        _type = type;
        
        /// 1. 正文Info  labelContent
        _labelTitle = [UILabel labelFrame:CGRectMake(k_SpanLeft, k_SpanIn, cellTextW(type), 10) fontSize:[CNUtils fontSizePreference:16] textColor:CNCOLOR_TEXT_TITLE];
        _labelTitle.font = [CNUtils fontPreference:FONT_Helvetica size:15];
        _labelTitle.numberOfLines = 3;
        _labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
        /// 2. 附注信息条 infBar ？
        _cellBar = [[CNCellBar alloc] initWithFrame:CGRectMake(k_SpanLeft, 0, cellTextW(type), cellBarH())];
        
        /// 3. 图片imgv  可能多种尺寸
        if (type == CNNewsCellTypeImgvFull)
        {
            CGRect fullImgFrame = CGRectMake(k_SpanLeft, _labelTitle.bottom, cellContentW(), cellImgvH(type));
            _imgvFull = [[CNImageView alloc] initWithFrame:fullImgFrame];
            [_imgvFull setContentMode:UIViewContentModeScaleAspectFill];
            _imgvFull.clipsToBounds = YES;
            [self.viewBase addSubview:_imgvFull];
        }
        else if (type == CNNewsCellTypeImgvParts)
        {
            CGSize partImgSize  = CGSizeMake(cellImgvW(type), cellImgvH(type));
            NSMutableArray *muArr = [NSMutableArray array];
            for (int i = 0; i < 3; i ++ ) {
                CNImageView *imgv = [[CNImageView alloc] initWithFrame:CGRectMake(k_SpanLeft + i * (cellImgvW(type)+k_SpanIn/2), 0, partImgSize.width, partImgSize.height)];
                [imgv setContentMode:UIViewContentModeScaleAspectFill];
                imgv.clipsToBounds = YES;
                [self.viewBase addSubview:imgv];
                [muArr addObject:imgv];
            }
            self.imgvArray = [NSArray arrayWithArray:muArr];
        }
        else if (type == CNNewsCellTypeImgvSideR)
        {
            CGRect sideImgFrame = CGRectMake(SCREENW - k_SpanLeft - cellImgvW(type), k_SpanIn, cellImgvW(type), cellImgvH(type));
            _imgvSideR = [[CNImageView alloc] initWithFrame:sideImgFrame];
            [_imgvSideR setContentMode:UIViewContentModeScaleAspectFill];
            _imgvSideR.clipsToBounds = YES;

            [self.viewBase addSubview:_imgvSideR];
            
        }
        else if (type == CNNewsCellTypeImgvNone)
        {
            
        }
        [self.viewBase addSubview:_labelTitle];
        [self.viewBase addSubview:_cellBar];
    
        
        
        
        UILongPressGestureRecognizer *_longPGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        _longPGR.minimumPressDuration = 1.2f;
        [self addGestureRecognizer:_longPGR];
    }
    return self;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPGR {
    switch (longPGR.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.news && BUILD_MODE == 0) {
                NSLog(@"news.ID = %@",self.news.ID);
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = [NSString stringWithFormat:@"newsId:%@ | uiid:%@",_news.ID,[CNUtils getDeviceUIID]];
                if ([self.delegate respondsToSelector:@selector(cellNews:event:info:)]) {
                    [self.delegate cellNews:_news event:CNNewsCellEventLongPress info:@{@"event":@"longPress"}];
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
           
        }
            break;
        default:
            break;
    }
}

- (void)setNews:(CNNews *)news {
    _news = news;
    _labelTitle.text    = news.title;
    _cellBar.offline    = news.offline;
    _cellBar.title      = news.source.length? news.source:@"";
    _cellBar.time       = [CNUtils newsTimeFormat:news.publishTime.longLongValue];

    _labelTitle.width   = cellTextW(_type);
    _labelTitle.textColor = [news.readState integerValue]? RGBCOLOR_HEX(0x777777):CNCOLOR_TEXT_TITLE;

    [_labelTitle sizeToFit];

    if (_type == CNNewsCellTypeImgvFull)
    {
    
        _imgvFull.top   = _labelTitle.bottom + k_SpanIn;
        _cellBar.top    = _imgvFull.bottom;
        
        [_imgvFull cn_setImageWithURL:[NSURL URLWithString:[news.imgUrls firstObject]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"get ImageOver");
        }];
        _news.letvImgUrl    = [self.imgvFull CNletvImgFromOriginUrl:[NSURL URLWithString:[_news.imgUrls firstObject]]].absoluteString;

    }
    else if (_type == CNNewsCellTypeImgvParts)
    {
        
        for (NSInteger i = 0; i < self.imgvArray.count; i ++)
        {
            CNImageView *partImgv = self.imgvArray[i];
            if (news.imgUrls.count > i) {
                [partImgv cn_setImageWithURL:[NSURL URLWithString:[news.imgUrls objectAtIndex:i]] placeholderImage:nil];
            }else{
                [partImgv cn_setImageWithURL:[NSURL URLWithString:[news.imgUrls lastObject]] placeholderImage:nil];
            }

            partImgv.top    = _labelTitle.bottom + k_SpanIn;
        }
        _news.letvImgUrl    = [self.imgvArray[0] CNletvImgFromOriginUrl:[NSURL URLWithString:[_news.imgUrls firstObject]]].absoluteString;
        _cellBar.top    = [self.imgvArray lastObject].bottom;
    }
    else if (_type == CNNewsCellTypeImgvSideR)
    {

        if (_labelTitle.height > _imgvSideR.height - cellBarH() + k_SpanIn) {
//            _labelTitle.height = _imgvSideR.height;
//            _cellBar.frame = CGRectMake(k_SpanLeft, _imgvSideR.bottom, cellContentW(), cellBarH());
            _labelTitle.height = _imgvSideR.height + k_SpanIn - cellBarH();
            _cellBar.frame = CGRectMake(k_SpanLeft, _imgvSideR.bottom - (cellBarH() - k_SpanIn), cellTextW(_type), cellBarH());

            [_cellBar reloadFrame];
        }else {
            _cellBar.frame = CGRectMake(k_SpanLeft, _imgvSideR.bottom - (cellBarH() - k_SpanIn), cellTextW(_type), cellBarH());
            [_cellBar reloadFrame];
        }
        _news.letvImgUrl    = [self.imgvSideR CNletvImgFromOriginUrl:[NSURL URLWithString:[_news.imgUrls firstObject]]].absoluteString;
        [_imgvSideR cn_setImageWithURL:[NSURL URLWithString:[news.imgUrls firstObject]] placeholderImage:nil];
    }
    else if (_type == CNNewsCellTypeImgvNone)
    {
        _cellBar.top = _labelTitle.bottom + k_SpanIn;
    }
    
    // 调整默认占位图片颜色。
    if (self.showIndexPath.row % 2 == 0) {
        _imgvSideR.backgroundColor  = RGBCOLOR_HEX(0xFFEAE3);
        _imgvFull.backgroundColor   = RGBCOLOR_HEX(0xFFEAE3);
    }else{
        _imgvSideR.backgroundColor = RGBCOLOR_HEX(0xFFEEE3);
        _imgvFull.backgroundColor   = RGBCOLOR_HEX(0xFFEEE3);
    }
    for (int i =0; i < _imgvArray.count; i++) {
        UIImageView *subImgv = _imgvArray[i];
        if (i % 2 == 0) {
            subImgv.backgroundColor  = RGBCOLOR_HEX(0xFFEAE3);
        }else{
            subImgv.backgroundColor   = RGBCOLOR_HEX(0xFFEEE3);
        }
    }

    self.viewBase.height = _cellBar.bottom;
    self.btnCheck.left   = 15;
    self.btnCheck.selected = news.marked;
    self.btnCheck.centerY= self.viewBase.height * 0.5;
}


- (void)setCellState:(CNNewsCellState)cellState {
    _cellState = cellState;
    if (cellState == CNNewsCellStateNormal) {
//        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.btnCheck.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.viewBase.left  = 0;
            self.btnCheck.alpha = 0;
        }];
    }else if (cellState == CNNewsCellStateEditing) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [UIView animateWithDuration:0.25 animations:^{
            self.btnCheck.alpha = 1;
            self.viewBase.left  = self.btnCheck.right;
        }];
    }
}



#pragma mark - 计算Cell 代理返回的高度值
+ (CGFloat)cellHeightWithModel:(CNNews *)news {
    if (!news) {
        return 44;
    }
    CNNewsCellType type = CNNewsCellTypeImgvNone;
    if ([news.imgShowControl integerValue] == 1) {
        type = CNNewsCellTypeImgvFull;
    }else if ([news.imgShowControl integerValue] == 2) {
        type = CNNewsCellTypeImgvSideR;
    }else if ([news.imgShowControl integerValue] == 3) {
        type = CNNewsCellTypeImgvParts;
    }
    
    CNCellCaculate *caculate = [CNCellCaculate shareCellCaculate];
    caculate.label.width = cellTextW(type);
    caculate.label.text  = news.title;
    [caculate.label sizeToFit];
    
    if (caculate.label.height > cellImgvH(type) - cellBarH() + k_SpanIn && type == CNNewsCellTypeImgvSideR) {
//        return cellImgvH(type) + cellBarH() + k_SpanIn;
        return 2 * k_SpanIn + cellImgvH(type);
    }else if(type == CNNewsCellTypeImgvSideR){
        return 2 * k_SpanIn + cellImgvH(type);
    }
    
    if (type == CNNewsCellTypeImgvNone) {
        return caculate.label.height + cellBarH() + k_SpanIn * 2;
    }

    
    CGFloat fitH = caculate.label.height + cellImgvH(type) + cellBarH() + 2 * k_SpanIn;
    
    return fitH;
}

@end
