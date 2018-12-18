//
//  LMConst.h
//  LMSX
//
//  Created by sunshine on 2018/4/2.
//  Copyright © 2018年 DW-Z-MacBook. All rights reserved.
//

#ifndef LMConst_h
#define LMConst_h











/*--------------------------  颜色  --------------------------*/
#define LMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
/** 十六进制颜色值 */
#define LMHexColor(strValue) [UIColor colorWithHexString:(strValue)]

#define kAppGreenColor  LMHexColor(@"00af58")













/** /*-------------------------- 尺寸相关 --------------------------*/

/** 设备宽 */
#define ZC_Screen_W [UIScreen mainScreen].bounds.size.width

/** 设备高 */
#define ZC_Screen_H [UIScreen mainScreen].bounds.size.height
/****屏幕宽高****/
#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height
#define kScreenFrame [UIScreen mainScreen].bounds
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenSize [UIScreen mainScreen].bounds.size
/****常用颜色设置****/
#define ProfileThemeColor SLHexColor(#1aa488)
#define rgb(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define SLHexColor(colorV) [UIColor hexStringToColor:(colorV)]
#define SLhexColorAlpha(colorV,a) [UIColor colorWithHexColorString:(colorV) alpha:a]

#define kWidth(R) (R)*(kScreenW)/375
#define SLhexColorAlpha(colorV,a) [UIColor colorWithHexColorString:(colorV) alpha:a]
#define font(R) (R)*(kScreenW)/375.0
#define kfont(R)            [UIFont systemFontOfSize:font(R)] // 便捷字体
#define SL_iPhoneX        (SL_IS_PORTRAIT ? kScreenH == 812 : kScreenW == 812)

/** 是否是竖屏 */
#define ZC_IS_PORTRAIT (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown))

#define ZC_IS_LANDSCAPE (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight))

#define ZC_IS_LANDSCAPE_LEFT ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)

#define ZC_IS_LANDSCAPE_RIGHT ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)

#define ZC_iPhone_4x      ZC_Screen_W == 320 && ZC_Screen_H == 480

#define ZC_iPhone_5x      ZC_Screen_W == 320 && ZC_Screen_H == 568

#define ZC_iPhone_6x      ZC_Screen_W == 375 && ZC_Screen_H == 667

#define ZC_iPhone_6x_plus ZC_Screen_W == 414 && ZC_Screen_H == 736

#define ZC_iPhoneX        (ZC_IS_PORTRAIT ? ZC_Screen_H == 812 : ZC_Screen_W == 812)

#define IPHONE_Xs (@available(iOS 11.0, *) ? [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0 : NO )
//#define IPHONE_Xs ({\
//int tmp = 0;\
//if (@available(iOS 11.0, *)) {\
//if (!UIEdgeInsetsEqualToEdgeInsets([UIApplication sharedApplication].delegate.window.safeAreaInsets, UIEdgeInsetsZero)) {\
//tmp = 1;\
//}else{\
//tmp = 0;\
//}\
//}else{\
//tmp = 0;\
//}\
//tmp;\
//})


//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0

#define IOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0

#define IOS9 [[[UIDevice currentDevice]systemVersion] floatValue] >= 9.0

#define IOS10 [[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0

#define IOS11 [[[UIDevice currentDevice]systemVersion] floatValue] >= 11.0















/* -------------------------   导航栏和Tabbar --------------------------*/
// 导航栏高度
#define ZCNav_topH (ZC_iPhoneX ? 88 : 64)

// 标签栏高度
#define ZCTab_H (ZC_iPhoneX ? 83 : 49)

// iPhone X 导航栏增加的高度
#define ZCNavMustAdd (ZC_iPhoneX ? (ZC_IS_PORTRAIT ? 24 : (ZC_IS_LANDSCAPE_RIGHT?30:24)) : 0)

// iPhone X 标签栏增加的高度
#define ZCTabMustAdd (ZC_iPhoneX ? 20 : 0)

// iPhone X 标签栏安全高度
#define ZCTabMustAddSafe (ZC_iPhoneX ? (ZC_IS_PORTRAIT ? 34 : 0) : 0)

// iPhone X 状态栏安全高度
#define ZCStatus_H  (ZC_iPhoneX ? 44 : 20)

#define ZCNavigationItem_H   44

/** 控件缩放比例，按照宽度计算 */
#define ZC_SCALE_WIDTH(w) (ZC_IS_PORTRAIT ? round((ZC_Screen_W/375.0*(w))) : round((ZC_Screen_W/667.0*(w))))

/** 控件缩放比例，按照宽度计算  不会进行四舍五入*/
#define ZC_SCALE_ORIGINAL_WIDTH(w) (ZC_IS_PORTRAIT ? (ZC_Screen_W/375.0*(w)) : (ZC_Screen_W/667.0*(w)))

/** 控件缩放比例，按照高度计算 */
#define ZC_SCALE_HEIGHT(h) (ZC_IS_PORTRAIT ? round((ZC_Screen_H/667.0*(h))) : round((ZC_Screen_H/375.0*(h))))

/** 控件缩放比例，按照高度计算  不会进行四舍五入*/
#define ZC_SCALE_ORIGINAL_HEIGHT(h) (ZC_IS_PORTRAIT ? (ZC_Screen_H/667.0*(h)) : (ZC_Screen_H/375.0*(h)))

#define VIEWHEIGHT  ZC_Screen_H - ZCNav_topH - ZCTab_H


// iPhone X顶部多出的高度
#define SL_X_Top  (SL_iPhoneX ? 44.f : 0.f)
// iPhone X底部多出的高度
#define SL_X_Bottom  (SL_iPhoneX ? 34.f : 0.f)

#define SL_IS_PORTRAIT (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown))






/* -------------------------    常用配置   --------------------------*/
#define  kLMMargin                10

#define  LMImage(a)               [UIImage imageNamed:a]

#define  LMTXTCOLOR               LMHexColor(@"4a4a4a")

#define  kVIEWBACKCOLOR           LMHexColor(@"eceef3")

#define  kMsgAvatarWID            ZC_SCALE_WIDTH(48)

#define  LMColorAlpha(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define  LMNAVBARCOLOR              [UIColor colorWithHexString:@"c62d32"]

#define WeakSelf(type)  __weak typeof(type) weakSelf = type;

#define StrongSelf __typeof(&*weakSelf) strongSelf = weakSelf;

#define LMCOOKIE                     @"LMCOOKIE"

#define LMCOOKIENOTIFICATION         @"LMCOOKIENOTIFICATION"

/** 访问网络错误 */
#define kRequetError @"网络出错啦"
/** 访问网络超时 */
#define kRequetTimeOut @"请求超时,请稍后重试"
/** 访问服务器错误 */
#define kRequetFail @"请求失败,请稍后重试"









/* -------------------------    容错处理   --------------------------*/
#define isEmpty(a) ((a) == nil || [(a) isEqual:@""] || [(a) isEqual:@" "] || ((NSNull *)a) == [NSNull null])

#define isStrEmpty(string) ([string isEqualToString:@"(null)"] || string == nil || string == NULL || (![string isKindOfClass:[NSString class]]) || ([string isEqual:@""]) || [string isEqualToString:@""] || [string isEqualToString:@" "] || ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) || ([string respondsToSelector:@selector(length)] && [(NSData *)string length] == 0))

#define isArrEmpty(array) (array == nil || array == NULL || (![array isKindOfClass:[NSArray class]]) || array.count == 0)

#define isDictEmpty(dict) (dict == nil || dict == NULL || (![dict isKindOfClass:[NSDictionary class]]) || dict.count == 0)

#define isUrlEmpty(url) (url == nil || url == NULL || [url isEqual:[NSNull null]] || (![url isKindOfClass:[NSURL class]]) || url.absoluteString.length == 0)




/* -------------------------   字体 --------------------------*/
#define kFontSizeWith(value) [UIFont systemFontOfSize:[UIFont ZC_FontSize:value]] // 字体大小设置
#define kFontblodSizeWith(value) [UIFont boldSystemFontOfSize:[UIFont ZC_FontSize:value]] // 加粗字体设置




//色值转换 (0xFFFFFF)
#define RGB_VALUE(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]















/* -------------------------   TIMSDK --------------------------*/

// 正式服
//#define TIMSDKAPPID          (1400091169)
//#define TIMACCOUNTTYPE       @"26501"
// 测试服
#define TIMSDKAPPID          (1400098288) //1400098288    1400077532
#define TIMACCOUNTTYPE       @"28396" //28396 26422



#pragma mark ---------   企业版   --------------
//#define kWeixinAppID         @"wx8ec0953c14435e3c"
//#define  kfilePath            @"Pandora/apps/com.enterprise.lmsx/www/"



#pragma mark ---------   App Store 版  --------------
#define  kfilePath           @"Pandora/apps/com.dongwei.LMSX/www/"
#define kWeixinAppID         @"wx5412dd10bfa90670"
#define kWeixinAppSecret         @"758dde4111f339f9becefc0e6a15b533"



#define TIMTOKEN             @"TIMTOKEN"


//换新客服
#define HD_APPKEY @"1103181113084803#huanxinkefu-lmsx-ceshi"
#define HD_TENANTID @"60351"
















/* -------------------------    Log    --------------------------*/
#ifdef DEBUG
#define LMLog(format, ...) printf("class: < %s:(%d) > method: %s \n%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define LMLog(format, ...)
#endif


#define   LMCenter      [NSNotificationCenter defaultCenter]
#define   LMDefaults    [NSUserDefaults standardUserDefaults]

#define   kShareBack    @"kShareBack"
#define   kShareGroup   @"kShareGroup"
#define   kShareGroupFninsh  @"kShareGroupFninsh"









/** 二级界面加载一文本 */
#define ZCRequestLoadText @"努力加载中..."
/** 无网络统一文本 */
#define ZCNoNetworkText @"网络繁忙，请稍后再试"
#define ZCSearchPlaceholderStr @"请输入搜索内容"



#define KUserRequestTimeOut 30


#define TIMSessionIgnoreList (@[@"admin",@"",])









#define LM_LIVE_IDS_KEY      @"LM_LIVE_IDS_KEY"
#define LMUSER_ID_KEY        @"LMUSER_IDKEY"
#define LMUSER_SIG_KEY       @"LMUSER_SIGKEY"
#define LMUSER_AVATAR_KEY    @"LMUSER_AVATARKEY"
#define LMUSER_GENDER_KEY    @"LMUSER_GENDERKEY"
#define LMUSER_NAME_KEY      @"LMUSER_NAMEKEY"
#define LM_LOGIN_KEY         @"LM_LOGIN_KEY"
#define LM_MOBILE_KEY        @"LM_MOBILE_KEY"
#define LM_TO_USER_ID_KEY    @"LM_TO_USER_ID_KEY"


#define LM_NOTI_SOUND        @"LM_NOTI_SOUND"
#define LM_MSG_PAGE          @"LM_MSG_PAGE"



/** user_id = 35 */
#define TO_USER_ID        [[NSUserDefaults standardUserDefaults] objectForKey:LM_TO_USER_ID_KEY]
/** 用户ID */
#define USER_ID           [[NSUserDefaults standardUserDefaults] objectForKey:LMUSER_ID_KEY]
/** sig */
#define USER_SIG          [[NSUserDefaults standardUserDefaults] objectForKey:LMUSER_SIG_KEY]
/** 头像 */
#define USER_AVATAR       [[NSUserDefaults standardUserDefaults] objectForKey:LMUSER_AVATAR_KEY]
/** 性别 */
#define USER_GENDER       [[NSUserDefaults standardUserDefaults] objectForKey:LMUSER_GENDER_KEY]
/** 昵称 */
#define USER_NAME         [[NSUserDefaults standardUserDefaults] objectForKey:LMUSER_NAME_KEY]
/** 是否登录 */
#define IS_LOGIN          [[NSUserDefaults standardUserDefaults] objectForKey:LM_LOGIN_KEY]
/** 是否登录 */
#define USER_MOBILE       [[NSUserDefaults standardUserDefaults] objectForKey:LM_MOBILE_KEY]




#define  DELETEMSGNOTI      @"DELETEMSGNOTI"   // 删除消息
#define  DELELIVEMSGNOTI    @"DELELIVEMSGNOTI" // 删除直播消息
#define  LIVEPUSHFAIL       @"LIVEPUSHFAIL"    // 推流失败
#define  LIVEPUSHSUCCESS    @"LIVEPUSHSUCCESS" // 推流成功


#endif /* LMConst_h */









