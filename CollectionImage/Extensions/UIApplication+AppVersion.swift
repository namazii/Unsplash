//
//  UIApplication+AppVersion.swift
//  vk-base
//
//  Created by Artur Igberdin on 05.06.2022.
//

import UIKit

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}


/*
if let appVersion = UIApplication.appVersion {
    versionLabel.text = "Версия приложения: \(appVersion)"
}
 */
