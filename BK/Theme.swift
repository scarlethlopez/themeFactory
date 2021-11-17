//
//  Theme.swift
//  BK
//
//  Created by Aylwing Olivas on 11/16/21.
//
import UIKit
import Foundation

class Theme: NSObject {
    //let colorPrimary: UIColor
    let colorBackground: UIColor
    let colorText: UIColor
    let fontBody: UIFont
    let fontTitle: UIFont
    init(colorBackground: UIColor, colorText: UIColor, fontBody: UIFont, fontTitle: UIFont) {
        //self.colorPrimary =    colorPrimary
        self.colorBackground = colorBackground
        self.colorText =       colorText
        self.fontBody =        fontBody
        self.fontTitle =       fontTitle
    }
    static let light = Theme(
        colorBackground: .white,
        colorText:       .darkText,
        fontBody:        .preferredFont(forTextStyle: .body),
        fontTitle:       .boldSystemFont(ofSize: 32)
        )
    static let dark = Theme(
        colorBackground: .red,
        colorText:       .lightText,
        fontBody:        .preferredFont(forTextStyle: .body),
        fontTitle:       .boldSystemFont(ofSize: 32)
        )
}
struct ThemeManager {
    // Register different Themes
    static let themes: [(title: String, theme: Theme)] = [
        ("Light", .light),
        ("Dark", .dark)
    ]
    // User Defaults key to store the selected theme
    static let udKey = "Theme"
    // Get the selected Theme title from UserDefaults
    static var themeTitle: String {
        return UserDefaults.standard.string(forKey: udKey) ?? "Light"
    }
    // Get the theme with that title
    // Update UserDefaults if ThemeManager.theme changes
    static var theme = themes.first(where: { $0.title == themeTitle })?.theme ?? Theme.light {
        didSet {
            let themeName =
                themes.first(where: { $0.theme == theme })?.title
            UserDefaults.standard.set(themeName, forKey: udKey)
        }
    }
}
