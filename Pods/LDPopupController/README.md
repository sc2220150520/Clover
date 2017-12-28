# LDPopupController
A simple popup display tool for iOS App.

### Getting Started
First, include `LDPopupInterface.h` in your project.  
Second, when you need to popup a view, you can do like this:  
If the popup is a kind of UIView (except UIWindow):  
```objc
LDView *view = [[LDView allc] initWithFrame:CGRectMake(x, y, width, height)];
[view displayPopup];
```
Or a kind of UIViewController:  
```objc
UIViewController *viewController = [[UIViewController alloc] init];
[viewController displayPopup];
```
And then when you need to dismiss the popup, you should tell `LDPopupController` to dismiss the popup:  
```objc
[view dismissPopup];
[viewController dismissPopup];
```
0.1.0  
First version of LDPopupController.
Import `LDPopupInterface.h` to use.

0.1.1
Add parameter to control the interval bewteen popups.

0.1.2
Add query function for LDPopupController.
Add logsSwitch to control logs for debug.
Close Autorotate of containerViewController.

0.1.3
Set PopupBasedWindow to keyWindow.
Add PopupLevel enum for windowLevel control.  

0.1.4
Add global dismiss method for LDPopupController.
Create a protocol used to custom global dismiss operation.  

0.1.5
Add interface for priority setting.
Add error info to PopupCompletion.


