# SKFloatingTextField

[![CI Status](https://img.shields.io/travis/coderode/SKFloatingTextField.svg?style=flat)](https://travis-ci.org/coderode/SKFloatingTextField)
[![Version](https://img.shields.io/cocoapods/v/SKFloatingTextField.svg?style=flat)](https://cocoapods.org/pods/SKFloatingTextField)
[![License](https://img.shields.io/cocoapods/l/SKFloatingTextField.svg?style=flat)](https://cocoapods.org/pods/SKFloatingTextField)
[![Platform](https://img.shields.io/cocoapods/p/SKFloatingTextField.svg?style=flat)](https://cocoapods.org/pods/SKFloatingTextField)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SKFloatingTextField is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SKFloatingTextField'
```
### Podfile Installation

```
use_frameworks!

platform :ios, '13.0'

target 'SKFloatingTextField_Example' do
  pod 'SKFloatingTextField'
  end
end
```
### Properties
```
1. isValidInput : Bool 
2. rightView : UIView
3. keyBoardType : UIKeyboardType
4. isSecureTextInput : Bool
5. text : String
6. textColor : UIColor
7. placeholder : String?
8. delegate : UITextFieldDelegate?
9. floatingLabelText : String?
10. floatingLabelColor : UIColor?
11. errorLabelText : String?
12. errorLabelColor : UIColor
13. borderColor : UIColor
14. activeBorderColor : UIColor
15. floatingLabelFont : UIFont
16. textFieldFont : UIFont
17. errorLabelFont : UIFont
18. bgColor : UIColor
19. borderWidth : CGFloat
20. cornerRadius : CGFloat
21. textAlignment : NSTextAlignment

```
### Methods
```
1. func setRoundTFUI()
2. func setOnlyBottomBorderTFUI()
3. func setCircularTFUI()
4. func setRectTFUI()
5. func setDroppable()
6. func setLeftImage(image : UIImage,tintColor : UIColor)
7. func setRightView(image : UIImage, tintColor : UIColor,action: ( (UIButton) -> () )?)
8. func showTitle()
9. func hideTitle()
10. func showError()
11. func hideError()

```

### Delegate 
```
@objc public protocol SKFlaotingTextFieldDelegate: UITextFieldDelegate {
    /// it is a delegte method to write a handler for tap on right view, or on the textField if it is set as droppable
    @objc optional func didTapOnRightView(textField: SKFloatingTextField)
    @objc optional func textFieldDidEndEditing(textField : SKFloatingTextField)
    @objc optional func textFieldDidChangeSelection(textField: SKFloatingTextField)
    @objc optional func textFieldDidBeginEditing(textField: SKFloatingTextField)
}

```

## Demo Images
![image1](https://github.com/Coderode/Images/blob/master/iOS/floating-textfield/tuto1.png)
![image1](https://github.com/Coderode/Images/blob/master/iOS/floating-textfield/tuto2.png)
![image1](https://github.com/Coderode/Images/blob/master/iOS/floating-textfield/tuto3.png)
![image1](https://github.com/Coderode/Images/blob/master/iOS/floating-textfield/tuto4.png)
![image1](https://github.com/Coderode/Images/blob/master/iOS/floating-textfield/screen1.png)
![image1](https://github.com/Coderode/Images/blob/master/iOS/floating-textfield/screen2.png)
![image1](https://github.com/Coderode/Images/blob/master/iOS/floating-textfield/screen3.png)
![image1](https://github.com/Coderode/Images/blob/master/iOS/floating-textfield/screen4.png)
![image1](https://github.com/Coderode/Images/blob/master/iOS/floating-textfield/screen5.png)
![image1](https://github.com/Coderode/Images/blob/master/iOS/floating-textfield/screen6.png)
![image1](https://github.com/Coderode/Images/blob/master/iOS/floating-textfield/screen7.png)
![image1](https://github.com/Coderode/Images/blob/master/iOS/floating-textfield/screen8.png)




## Author

coderode, sk9958814616@gmail.com

## License

SKFloatingTextField is available under the MIT license. See the LICENSE file for more info.
