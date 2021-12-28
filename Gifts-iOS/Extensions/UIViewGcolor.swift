//
//  UIViewGcolor.swift
//  Yellow Kitchens
//
//  Created by angrej singh on 14/09/20.
//  Copyright © 2020 com.agency55. All rights reserved.
//
import UIKit
import Foundation
@IBDesignable
class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map {$0.cgColor}
    }
}

//@IBInspectable var isHorizontal: Bool = true {
//   didSet {
//      updateView1()
//   }
//}
//func updateView1() {
// let layer = self.layer as! CAGradientLayer
// layer.colors = [firstColor, secondColor].map{$0.cgColor}
// if (self.isHorizontal) {
//    layer.startPoint = CGPoint(x: 0, y: 0.5)
//    layer.endPoint = CGPoint (x: 1, y: 0.5)
// } else {
//    layer.startPoint = CGPoint(x: 0.5, y: 0)
//    layer.endPoint = CGPoint (x: 0.5, y: 1)
// }
//}
