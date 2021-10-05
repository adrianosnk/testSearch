//
//  Styles.swift
//
//  Kambista
//
//  Created by MacAdrian on 10/4/21.
//  Copyright © 2021 Siri. All rights reserved.
//

import UIKit
class Styles {
    static let titleColor = UIColor.myAppGreen
    static let lightTitleColor = UIColor.lightGray
    static let darkTitleColor = UIColor.darkGray
    static let subtitleColor = UIColor.myAppBlue
    
    static let bodyColor = UIColor.black
    static let lightBodyColor = UIColor.white
    static let textFieldTextColor = UIColor.darkGray
    static let textFieldBackgroundColor = UIColor.lightGray
    
    static let backgroundColor = UIColor.white
    static let secondaryBackgroundColor = UIColor.myAppBlue
    static let bodyBackgroundColor = UIColor.white
    static let tableviewBackgroundColor = UIColor.lightGray
    static let tableviewCellBackgroundColor = UIColor.myAppGreen
    static let tableviewCellActionColor = UIColor.myAppRed
    
    static let actionColor = UIColor.myAppRed
    static let secondaryActionColor = UIColor.orange
    static let accentColor = UIColor.myAppGreen
    static let disabledColor = UIColor.gray
    static let purpleColor = UIColor.purple
    
}
class Style {
    enum TextStyle {
        case navigationBar
        case title
        case titleService
        case subtitle
        case subtitleDoctor
        case body
        case button
    }
    
    struct TextAttributes {
        let font: UIFont
        let color: UIColor
        let backgroundColor: UIColor?
        
        init(font: UIFont, color: UIColor, backgroundColor: UIColor? = nil) {
            self.font = font
            self.color = color
            self.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - General Properties
    let backgroundColor: UIColor
    let preferredStatusBarStyle: UIStatusBarStyle
    
    let attributesForStyle: (_ style: TextStyle) -> TextAttributes
    
    init(backgroundColor: UIColor,
         preferredStatusBarStyle: UIStatusBarStyle = .default,
         attributesForStyle: @escaping (_ style: TextStyle) -> TextAttributes)
    {
        self.backgroundColor = backgroundColor
        self.preferredStatusBarStyle = preferredStatusBarStyle
        self.attributesForStyle = attributesForStyle
    }
    
    // MARK: - Convenience Getters
    func font(for style: TextStyle) -> UIFont {
        return attributesForStyle(style).font
    }
    
    func color(for style: TextStyle) -> UIColor {
        return attributesForStyle(style).color
    }
    
    func backgroundColor(for style: TextStyle) -> UIColor? {
        return attributesForStyle(style).backgroundColor
    }
 
    func apply(textStyle: TextStyle, to label: UILabel) {
        let attributes = attributesForStyle(textStyle)
        label.font = attributes.font
        label.textColor = attributes.color
        label.backgroundColor = attributes.backgroundColor
    }
    
    func apply(textStyle: TextStyle = .button, to button: UIButton) {
        let attributes = attributesForStyle(textStyle)
        button.setTitleColor(attributes.color, for: .normal)
        button.titleLabel?.font = attributes.font
        button.backgroundColor = attributes.backgroundColor
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = attributes.backgroundColor?.cgColor
        button.layer.cornerRadius = 5
    }
    
    func apply(textStyle: TextStyle = .navigationBar, to navigationBar: UINavigationBar) {
        let attributes = attributesForStyle(textStyle)
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: attributes.font,
            NSAttributedString.Key.foregroundColor: attributes.color
        ]
        
        if let color = attributes.backgroundColor {
            navigationBar.barTintColor = color
        }
        
        navigationBar.tintColor = attributes.color
        navigationBar.barStyle = preferredStatusBarStyle == .default ? .default : .black
    }
}
extension UIColor {
    static var myAppRed: UIColor {
        return UIColor(red: 1, green: 0.1, blue: 0.1, alpha: 1)
    }
    static var myAppGreen: UIColor {
        return UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    }
    static var myAppBlue: UIColor {
        return UIColor(red: 0, green: 0.2, blue: 0.9, alpha: 1)
    }
    static var myAppBlack: UIColor {
        return .black
    }
    
    
    convenience init(_ hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
    
    
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
}

extension UIFont {
    static let GraphikBold:String = "Graphik-Bold"
    static let GraphikSemiBold = "Graphik-Semibold"
    static let GraphikMedium = "Graphik-Medium"
    static let GraphikLight = "Graphik-Light"
    static let GraphikRegular = "Graphik-Regular"
    static var myAppTitle: UIFont {
        return  UIFont(name: GraphikMedium, size: 18)!
    }
    static var myTitleService: UIFont {
        return  UIFont(name: GraphikMedium, size: 14)!
    }
    static var myAppSubtitle: UIFont {
        
        return  UIFont(name: GraphikRegular, size: 14)!
    }
    static var myAppBody: UIFont {
        return UIFont(name: GraphikMedium, size: 14)!
    }
    static var myDoctorSubtitle: UIFont {
        return UIFont(name: GraphikBold, size: 13)!
    }
}
extension Style {
    static var myApp: Style {
        return Style(
            backgroundColor: .white,
            preferredStatusBarStyle: .lightContent,
            attributesForStyle: { $0.myAppAttributes }
        )
    }
}

private extension Style.TextStyle {
    var myAppAttributes: Style.TextAttributes {
        switch self {
        case .navigationBar:
            return Style.TextAttributes(font: .myAppTitle, color: .myAppBlack, backgroundColor: .white)
        case .title:
            return Style.TextAttributes(font: .myAppTitle, color: .myAppBlack)
        case .titleService:
            return Style.TextAttributes(font: .myTitleService, color: .myAppBlack)
        case .subtitle:
            return Style.TextAttributes(font: .myAppSubtitle, color: .myAppBlack)
        case .subtitleDoctor:
            return Style.TextAttributes(font: .myDoctorSubtitle, color: .myAppBlack)
        case .body:
            return Style.TextAttributes(font: .myAppBody, color: .white, backgroundColor: .white)
        case .button:
            return Style.TextAttributes(font: .myAppSubtitle, color: .white, backgroundColor: .myAppBlack)
        }
    }
}
