//
//  AppDelegate.swift
//  Example
//
//  Created by Luong Van Lam on 6/11/18.
//  Copyright © 2018 lamlv. All rights reserved.
//

import AzCall
import AzCore
import UIKit
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        AzStackManager.shared.appId = "26870527d2ac628002dda81be54217cf"
        AzStackManager.shared.publicKey = [
            "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAq9s407QkMiZkXF0juCGjti6iWUDzqEmP",
            "+Urs3+g2zOf+rbIAZVZItS5a4BZlv3Dux3Xnmhrz240OZMBO1cNc poEQNij1duZlpJY8BJiptlr",
            "j3C+K/PSp0ijllnckwvYYpApm3RxC8ITvpmY3IZTrRKloC/XoRe39p68ARtxXKKW5I/YYxFucY91",
            "b6AEOUNaqMFEdLzpO/Dgccaxoc+N1SMfZOKue7aH0ZQIksLN7OQGVoiuf9wR2iSz3+FA+mMzRIP+",
            "lDxI4JE42Vvn1sYmMCY1GkkWUSzdQsfgnAIvnbepM2E4/95yMdRPP/k2Qdq9ja/mwEMTfA0yPUZ7LiywoZwIDAQAB"
        ].joined()

        AzCallManager.shared.settings.sdpSemantics = .planB

        let notificationSetting = UIUserNotificationSettings(
            types: [.alert, .badge, .sound],
            categories: nil
        )

        UIApplication.shared.registerUserNotificationSettings(notificationSetting)
        UIApplication.shared.registerForRemoteNotifications()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AzCallManager.shared.pushHandler.application(application, didRegisterWith: deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        AzCallManager.shared.pushHandler.application(application, didReceive: userInfo)
    }
}
