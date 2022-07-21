//
//  AppDelegate.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 21/07/2022.
//

import SwiftUI
import os
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    @AppStorage("aniTripDeviceToken") var deviceToken: String = ""
    @AppStorage("aniTripStartWithNotification") var startWithNotification: Bool = false
    @AppStorage("aniTripPushNotificationTitle") var notificationTitle: String = ""
    @AppStorage("aniTripPushNotificationBody") var notificationBody: String = ""
    
    override init() {
        super.init()
        self.startWithNotification = false
        self.notificationBody = ""
        self.notificationTitle = ""
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    //No callback in simulator -- must use device to get valid push token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        self.deviceToken = token
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notificationName = Notification.AniTrip.showActivateAccount.notificationName
        NotificationCenter.default.post(Notification(name: notificationName, object: self, userInfo: ["name": notificationName, "message": response.notification.request.content.subtitle]))
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
}

extension UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully registered for notifications!")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
}
//class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    @AppStorage("aniTripDeviceToken") var deviceToken: String = ""
//    @AppStorage("aniTripStartWithNotification") var startWithNotification: Bool = false
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        // Override point for customization after application launch.
//        startWithNotification = false
//        UNUserNotificationCenter.current().delegate = self
//
//        getNotificationSettings()
//
//        if let launchOptions = launchOptions {
//            startWithNotification = true
//            if(launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] != nil){
//
//            }
//        }
//
//        return true
//    }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//        let token = tokenParts.joined()
//        self.deviceToken = token
//        print("Device Token: \(token)")
//    }
//
//    func getNotificationSettings() {
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            print("Notification settings: \(settings)")
//            guard settings.authorizationStatus == .authorized else { return }
//            DispatchQueue.main.async {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
//    }
//
//    // This method will be called when app received push notifications in foreground
//    func userNotificationCenter(_ center: UNUserNotificationCenter
//                                , willPresent notification: UNNotification
//                                , withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
//    {
//        completionHandler([.alert, .badge, .sound])
//    }
//
//    // This function will be called right after user tap on the notification
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let application = UIApplication.shared
//
//        if(application.applicationState == .active){
//            print("user tapped the notification bar when the app is in foreground")
//
//        }
//
//        if(application.applicationState == .inactive)
//        {
//            print("user tapped the notification bar when the app is in background")
//        }
//
//        completionHandler()
//    }
//}
