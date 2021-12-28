//
//  UIViewController.swift
//

import UIKit
import Foundation

extension UIViewController {
    public func setNavShadow(shadowRadius: CGFloat, shadowOpacity: Float, shadowColor: CGColor) {
        setNavigationBarImage(for: UIImage(), color: .white)
        self.navigationController?.navigationBar.layer.shadowColor = shadowColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = shadowRadius
        self.navigationController?.navigationBar.layer.shadowOpacity = shadowOpacity
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    public func setNavigationBarImage(for image: UIImage? = nil, color: UIColor = .white) {
        if let image = image {
            self.navigationController?.navigationBar.shadowImage = image
            self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        } else {
            self.navigationController?.navigationBar.shadowImage = nil
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        }
        self.navigationController?.navigationBar.tintColor = color
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : color]
        self.navigationController?.navigationBar.isTranslucent = false
    }
    public func setNavigationbarThemeGradientColor() {
        var colors = [UIColor]()
        let leftColor = #colorLiteral(red: 0.1803921569, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        let rightColor = #colorLiteral(red: 0.462745098, green: 0.2352941176, blue: 0.9333333333, alpha: 1)
        colors.append(leftColor)
        colors.append(rightColor)
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
    // MARK: BackButton
    public func setBackButton(tintColor: UIColor = .white, isImage: Bool = false, _ image: UIImage =  #imageLiteral(resourceName: "BackArrow") ) {
        let btn1 = UIButton(type: .custom)
        if isImage {
            btn1.setImage(image.imageWithColor(color: tintColor), for: .normal)
            btn1.imageView?.contentMode = .scaleAspectFit
            btn1.frame = CGRect(x: 0, y: 0, width: 25, height: 24)
        } else {
            btn1.setTitle("Retour", for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        }
        btn1.contentHorizontalAlignment = .left
        btn1.setTitleColor(tintColor, for: .normal)
        btn1.addTarget(self, action: #selector(self.backBtnTapAction), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        let negativeSpacer:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -16
        self.navigationItem.leftBarButtonItems = [negativeSpacer, item1]
    }
    // MARK: Like Button
    public func setRightButton(tintColor: UIColor = .black, isImage: Bool = false, image: UIImage =  #imageLiteral(resourceName: "radioBtnFill"), title: String) {
        let btn1 = UIButton(type: .custom)
        if isImage {
            btn1.setImage(image.imageWithColor(color: tintColor), for: .normal)
            btn1.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
            btn1.imageView?.contentMode = .scaleAspectFit
            btn1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        } else {
            btn1.titleLabel!.font =  UIFont(name: "Poppins-Medium", size: 16)
            btn1.setTitle(title, for: .normal)
            btn1.tintColor = tintColor
            btn1.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        }
        btn1.addTarget(self, action: #selector(self.rightBtnTapAction(sender:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.leftBarButtonItem = item1
    }
    // MARK: - Two botton add Navigatio bar
    func setMoreButtonNav(Leftimage1: UIImage, Rightimage1: UIImage,rightBtn2ndTitle: String, isRightImage: Bool = false) {
        if isRightImage {
            //left button 1
            let button = UIButton(type: .custom)
            button.setImage(Leftimage1.imageWithOrignal(), for: .normal)
            // button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -18, bottom: 0, right: 0)
            button.imageView?.contentMode = .scaleAspectFit
            button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
            button.addTarget(self, action: #selector(self.navFirstLeftButtonAction(sender:)), for: .touchUpInside)
            let barButtonItem = UIBarButtonItem(customView: button)
            //Right button 1
            let button2 = UIButton(type: .custom)
            button2.setImage(Rightimage1.imageWithOrignal(), for: .normal)
            button2.imageView?.contentMode = .scaleAspectFit
            button2.frame = CGRect(x: 0.0, y: 0.0, width: 90, height: 44.0)
            button2.titleLabel!.font =  UIFont(name: "Poppins-Medium", size: 12)
            button2.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            button2.setTitleColor(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
            button2.setTitle(rightBtn2ndTitle, for: .normal)
            //  button2.addTarget(self, action:  #selector(self.navFirstButtonAction(sender:)), for: .touchUpInside)
            let barButtonItem2 = UIBarButtonItem(customView: button2)
            self.navigationItem.leftBarButtonItem = barButtonItem
            self.navigationItem.rightBarButtonItems = [barButtonItem2]
        } else {
            //left button 1
            let button = UIButton(type: .custom)
            button.setImage(Leftimage1.imageWithOrignal(), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -18, bottom: 0, right: 0)
            button.imageView?.contentMode = .scaleAspectFit
            button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            button.addTarget(self, action: #selector(self.navFirstLeftButtonAction(sender:)), for: .touchUpInside)
            let barButtonItem = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem = barButtonItem
        }
    }
    @objc func navFirstLeftButtonAction(sender: UIButton) {}
    @objc func navRightButtonAction(sender: UIButton) {}
    @objc func rightBtnTapAction(sender: UIButton) {}
    @objc func backBtnTapAction() {}
    //    public func setBlueGradientColor(){
    //        self.view.applyGradient(withColours: [#colorLiteral(red: 0.7294117647, green: 0.8980392157, blue: 0.8078431373, alpha: 1),#colorLiteral(red: 0.1098039216, green: 0.6392156863, blue: 0.6352941176, alpha: 1)], gradientOrientation: .topLeftBottomRight)
    //    }
    //    public func setRedGradientColor() {
    //        self.view.applyGradient(withColours: [#colorLiteral(red: 0.9176470588, green: 0.4549019608, blue: 0.4274509804, alpha: 1),#colorLiteral(red: 0.6235294118, green: 0.01568627451, blue: 0.1058823529, alpha: 1)], gradientOrientation: .topLeftBottomRight)
    //    }
    //    public func setYellowGradientColor(){
    //        self.view.applyGradient(withColours: [#colorLiteral(red: 1, green: 0.8588235294, blue: 0.337254902, alpha: 1),#colorLiteral(red: 0.9568627451, green: 0.5215686275, blue: 0.231372549, alpha: 1)], gradientOrientation: .topLeftBottomRight)
    //    }
    //    public func setTutorialGradientColor() {
    //        let topColor = #colorLiteral(red: 0.4352941176, green: 0.7450980392, blue: 0.7960784314, alpha: 1)
    //        let bottomColor = #colorLiteral(red: 0.2352941176, green: 0.537254902, blue: 0.6078431373, alpha: 1)
    //        self.view.applyGradient(withColours: [topColor,bottomColor], gradientOrientation: .vertical)
    //    }
    //    public func setNavigationbarYellowGradientColor(){
    //        var colors = [UIColor]()
    //        let leftColor = UIColor(red: 247/255, green: 107/255, blue: 28/255, alpha: 1)
    //        let rightColor = UIColor(red: 255/255, green: 200/255, blue: 0/255, alpha: 1)
    //        colors.append(leftColor)
    //        colors.append(rightColor)
    //        navigationController?.navigationBar.setGradientBackground(colors: colors)
    //    }
    //
    //    public func setNavigationbarRedGradientColor(){
    //        var colors = [UIColor]()
    //        let leftColor = UIColor(red: 255/255, green: 0/255, blue: 23/255, alpha: 1)
    //        let rightColor = UIColor(red: 159/255, green: 4/255, blue: 27/255, alpha: 1)
    //        colors.append(leftColor)
    //        colors.append(rightColor)
    //        navigationController?.navigationBar.setGradientBackground(colors: colors)
    //    }
    public var topDistance : CGFloat {
        get {
            if self.navigationController != nil && !self.navigationController!.navigationBar.isTranslucent {
                return 0
            } else {
                let barHeight = self.navigationController?.navigationBar.frame.height ?? 0
                var statusBarHeight = CGFloat(0)
                if #available(iOS 13.0, *) {
                    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                    statusBarHeight = (window?.windowScene?.statusBarManager?.isStatusBarHidden ?? true) ? CGFloat(0) : window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                } else {
                    statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
                }
                return barHeight + statusBarHeight
            }
        }
    }
}

extension CAGradientLayer {
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }
    func createGradientImage() -> UIImage? {
        var image: UIImage?
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UINavigationBar {
    func setGradientBackground(colors: [UIColor]) {
        let getLayer = self.getGradientLayer(withColours: colors, gradientOrientation: .horizontal)
        //        var updatedFrame = bounds
        //        updatedFrame.size.height += self.frame.origin.y
        //        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        setBackgroundImage(getLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func addLeftImageTo(txtField: UITextField, andImage img: UIImage) {
        let leftImageView = UIImageView(frame: CGRect(x: 5, y: 8, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        let iconContainerView: UIView = UIView(frame:CGRect(x: 0, y: 0, width: 20, height: 20))
        // iconContainerView.backgroundColor = UIColor(rgb: 0xCD5C5C)
        iconContainerView.addSubview(leftImageView)
        txtField.leftView = iconContainerView
        txtField.leftViewMode = .always
    }
}

extension UINavigationController {
    func pushViewControllerFromLeft(controller:UIViewController) {
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
    func pushViewControllerFromRight(controller:UIViewController) {
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
    func popviewControllerToLeft() {
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
    func popviewControllerToRight() {
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
}

// MARK: DateFormetter 24 Nov 2019
func convertDateFormaterNew(_ date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "dd MMM yyyy"
    return  dateFormatter.string(from: date!)
}

// MARK: DateFormetter 1997-04-19
func convertDateFormaterNew1(_ date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return  dateFormatter.string(from: date!)
}
