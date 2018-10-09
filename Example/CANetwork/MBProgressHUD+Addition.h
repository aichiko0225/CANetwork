//
//  MBProgressHUD+Addition.h
//  JZT_ZDDS
//
//  Created by ash on 2018/1/17.
//  Copyright © 2018年 jiuzhoutong. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Addition)

+ (MBProgressHUD *_Nullable)promptMessage:(NSString *_Nullable)message View:(UIView *_Nullable)view;

+ (MBProgressHUD *_Nullable)promptMessage:(NSString *_Nullable)message View:(UIView *_Nullable)view Completion:(MBProgressHUDCompletionBlock _Nullable )completion;

+ (MBProgressHUD *_Nullable)promptError:(NSString *_Nullable)message View:(UIView *_Nullable)view;


+ (MBProgressHUD *_Nullable)promptLoading:(NSString *_Nullable)message View:(UIView *_Nullable)view;

+ (MBProgressHUD *_Nullable)promptLoading:(NSString *_Nullable)message View:(UIView *_Nullable)view Completion:(MBProgressHUDCompletionBlock _Nullable)completion;

@end
