//
//  MBProgressHUD+Addition.m
//  JZT_ZDDS
//
//  Created by ash on 2018/1/17.
//  Copyright © 2018年 jiuzhoutong. All rights reserved.
//

#import "MBProgressHUD+Addition.h"

#define TIP_NETWORK_ERROR @"网络错误"

#define TIP_NETWORK_TIMEOUT @"请求超时"

#define TIP_NETWORK_DATA @"数据错误"

#define TIP_UNKNOWN_ERROR @"未知错误"

@implementation UIImage (CCNamed)

+ (nullable UIImage *)cc_imageNamed:(NSString *)name {
    
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"CCEmptyDataSet")];
    NSString *bundlePath = [bundle.resourcePath stringByAppendingString:@"/Frameworks/CCEmptyDataSet.framework/CCEmptyDataSet.bundle"];
    NSBundle *bundle1 = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle1 compatibleWithTraitCollection:nil];
    
    if (image == nil) {
        NSString *bundlePath = [bundle.resourcePath stringByAppendingString:@"/CCEmptyDataSet.bundle"];
        NSBundle *bundle1 = [NSBundle bundleWithPath:bundlePath];
        image = [UIImage imageNamed:name inBundle:bundle1 compatibleWithTraitCollection:nil];
    }
    
    if (image == nil) {
        image = [UIImage imageNamed:name];
    }
    
    return image;
}


- (nullable UIImage *)cc_imageScale:(CGFloat)scale originSize:(CGSize)originSize {
    NSParameterAssert(scale > 0);
    if (scale >= 1) {
        return self;
    }
    
    CGFloat width = originSize.width * scale;
    CGFloat height = originSize.height * scale;
    
    UIGraphicsBeginImageContext(originSize);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@interface MBLoadingView: UIView

@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong, readonly) UIImageView *centerImageView;
@property (nonatomic, strong, readonly) UIImageView *animateImageView;

- (void)startAnimation;

@end

@implementation MBLoadingView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self startAnimation];
}

- (void)startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat: 0];
    animation.toValue = [NSNumber numberWithFloat:2.0* M_PI];
    animation.duration = 1.0f;
    animation.repeatCount = ULLONG_MAX;
    [_animateImageView.layer addAnimation:animation forKey:@"rotationAnimation"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _shadowView = [[UIView alloc] initWithFrame:frame];
        _shadowView.backgroundColor = UIColor.whiteColor;
        _shadowView.layer.masksToBounds = YES;
        _shadowView.layer.cornerRadius = frame.size.height/2;
        //_shadowView.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
        //_shadowView.layer.borderWidth = 1.f;
        [self addSubview:self.shadowView];
        
        UIImage *centerImage = [UIImage cc_imageNamed:@"cc_loading_logo"];
        UIImage *animateImage = [UIImage cc_imageNamed:@"cc_loading"];
        
        if (centerImage && animateImage) {
            _centerImageView = [[UIImageView alloc] initWithImage:[UIImage cc_imageNamed:@"cc_loading_logo"]];
            _animateImageView = [[UIImageView alloc] initWithImage:[UIImage cc_imageNamed:@"cc_loading"]];
        }
        
        
        CGSize size1 = CGSizeMake(_centerImageView.intrinsicContentSize.width*0.8, _centerImageView.intrinsicContentSize.height*0.8);

        CGSize size2 = CGSizeMake(_animateImageView.intrinsicContentSize.width*0.8, _animateImageView.intrinsicContentSize.height*0.8);
        
        _centerImageView.frame = CGRectMake(0, 0, size1.width, size1.height);
        _animateImageView.frame = CGRectMake(0, 0, size2.width, size2.height);
        
        if (_centerImageView && _animateImageView) {
            _centerImageView.center = self.center;
            _animateImageView.center = self.center;
        }
        
        [self addSubview:_centerImageView];
        [self addSubview:_animateImageView];
        
//        self.layer.shadowOpacity = 0.5;
//        self.layer.shadowOffset = CGSizeMake(0, 3);
//        self.layer.shadowRadius = frame.size.height/2;
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return self.bounds.size;
}

@end

//static MBProgressHUD *_hud = nil;

//@interface MBProgressHUD (Addition)
//
//+ ( MBProgressHUD * _Nonnull )showMessage:( NSString * _Nonnull)message;
//
//+ ( MBProgressHUD * _Nonnull )showMessage:( NSString * _Nonnull)message View:(UIView *_Nullable)view;
//
//+ ( MBProgressHUD * _Nullable )showErrorAdded:(NSString * _Nonnull)message imageName:(NSString *_Nullable)imageName to:(UIView * _Nullable)view;
//
//+ ( MBProgressHUD * _Nullable )showErrorAdded:(NSString * _Nonnull)message to:(UIView * _Nullable)view;
//
//@end

@implementation MBProgressHUD (Addition)


+ (MBProgressHUD * _Nonnull )showMessage:( NSString * _Nonnull)message {
    return [MBProgressHUD showMessage:message View:nil];
}

+ (MBProgressHUD * _Nonnull )showMessage:( NSString * _Nonnull)message View:(UIView *_Nullable)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.activityIndicatorColor = [UIColor whiteColor];
    hud.tintColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor colorWithWhite:0.1 alpha:0.5];
    hud.bezelView.style =  MBProgressHUDBackgroundStyleSolidColor;
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = true;
    if ([message isEqualToString:@"NSURLErrorDomain"] || [message hasSuffix:@"NSURLErrorDomain"] || [message hasPrefix:@"NSURLErrorDomain"]) {
        message = TIP_NETWORK_ERROR;
    }
    if (message.length > 10) {
        hud.label.text = @"";
        hud.detailsLabel.text = message;
        hud.detailsLabel.textColor = [UIColor whiteColor];
        hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    }
    return hud;
}

+ (MBProgressHUD * _Nullable )showErrorAdded:(NSString * _Nonnull)message imageName:(NSString *_Nullable)imageName to:(UIView * _Nullable)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.color = [UIColor colorWithWhite:0.1 alpha:0.5];
    hud.bezelView.style =  MBProgressHUDBackgroundStyleSolidColor;
    hud.activityIndicatorColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = true;
    
    if ([message isEqualToString:@"NSURLErrorDomain"] || [message hasSuffix:@"NSURLErrorDomain"] || [message hasPrefix:@"NSURLErrorDomain"] || [message containsString:@"ErrorDomain"]) {
        message = TIP_NETWORK_ERROR;
    }
    
    if (imageName != nil) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            hud.customView = [[UIImageView alloc] initWithImage:image];
        }
    }
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    [hud hideAnimated:YES afterDelay:2];
    
    if (message.length > 10) {
        hud.label.text = @"";
        hud.detailsLabel.text = message;
        hud.detailsLabel.textColor = [UIColor whiteColor];
        hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    }
    return hud;
}

+ (MBProgressHUD * _Nullable )showErrorAdded:(NSString * _Nonnull)message to:(UIView * _Nullable)view {
    return [MBProgressHUD showErrorAdded:message imageName:nil to:view];
}

+ (MBProgressHUD *_Nullable)promptMessage:(NSString *_Nullable)message View:(UIView *_Nullable)view {
    return [MBProgressHUD promptMessage:message View:view Completion:nil];
}

+ (MBProgressHUD *_Nullable)promptError:(NSString *_Nullable)message View:(UIView *_Nullable)view {
    if (message == nil) {
        message = TIP_NETWORK_ERROR;
    }
    return [MBProgressHUD showErrorAdded:message to:view];
}

+ (MBProgressHUD *_Nullable)promptMessage:(NSString *_Nullable)message View:(UIView *_Nullable)view Completion:(MBProgressHUDCompletionBlock _Nullable )completion {
    NSString *new_message = message;
    if (new_message == nil) {
        new_message = TIP_NETWORK_ERROR;
    }
    MBProgressHUD *hud = [MBProgressHUD showErrorAdded:new_message to:view];
    hud.completionBlock = completion;
    return hud;
    return nil;
}


+ (MBProgressHUD *_Nullable)promptLoading:(NSString *_Nullable)message View:(UIView *_Nullable)view Completion:(MBProgressHUDCompletionBlock _Nullable)completion {
    
    if (message == nil) {
        if (view == nil) {
            view = [UIApplication sharedApplication].keyWindow;
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        
        MBLoadingView *loadingView = [[MBLoadingView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        if (loadingView.subviews.count > 1) {
            hud.label.text = nil;
            hud.detailsLabel.text = nil;
            hud.mode = MBProgressHUDModeCustomView;
            hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.bezelView.backgroundColor = [UIColor clearColor];
            hud.customView = loadingView;
            hud.completionBlock = completion;
            hud.removeFromSuperViewOnHide = true;
        }else {
            MBProgressHUD *hud = [MBProgressHUD showMessage:message View:view];
            hud.bezelView.color = [UIColor colorWithWhite:0.1 alpha:0.5];
            hud.bezelView.style =  MBProgressHUDBackgroundStyleSolidColor;
            hud.completionBlock = completion;
            return hud;
        }
        return hud;
    }else {
        MBProgressHUD *hud = [MBProgressHUD showMessage:message View:view];
        hud.completionBlock = completion;
        return hud;
    }
}

+ (MBProgressHUD *_Nullable)promptLoading:(NSString *_Nullable)message View:(UIView *_Nullable)view {
    return [MBProgressHUD promptLoading:message View:view Completion:nil];
}



@end
