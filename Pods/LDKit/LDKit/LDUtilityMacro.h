//
//  LDUtilityMacro.h
//  Pods
//
//  Created by wuxu on 16/6/29.
//
//

#ifndef LDUtilityMacro_h
#define LDUtilityMacro_h


////////////////////////////Color
#ifndef rgb
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#endif

#ifndef rgba
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#endif

#ifndef hexColor
#define hexColor(colorV) [UIColor colorWithHexColorString:@#colorV]
#endif

#ifndef hexColorAlpha
#define hexColorAlpha(colorV,a) [UIColor colorWithHexColorString:@#colorV alpha:a]
#endif

////////////////////////////
#ifndef WeakSelf
#define WeakSelf __weak typeof(self) weakSelf = self;
#endif

#ifndef StrongSelf
#define StrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;
#endif

#endif /* LDUtilityMacro_h */
