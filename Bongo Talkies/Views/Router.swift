//
//  Router.swift
//  OSS Salesforce
//
//  Created by Admin on 30/8/22.
//

import Foundation
import UIKit
import SwiftUI


class Router {
    
    class private var window: UIWindow? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let sceneDelegate = scene.delegate as? SceneDelegate {
                let window = UIWindow(windowScene: scene)
                sceneDelegate.window = window
                window.makeKeyAndVisible()
                return window
            }
        }
        return nil
    }
    
    static func navigate(device: Device) {
        showMainScreen(device: device)
    }
    
    static func showMainScreen(device: Device) {
        guard let window = window else { return }
    
        let contentView = MovieListView().environmentObject(device)
        
        window.rootViewController = UIHostingController(rootView: contentView)
    }
 
    class var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .map {$0 as? UIWindowScene}
            .compactMap({$0})
            .first?.windows
            .filter {$0.isKeyWindow}
            .first
    }
    
    class var safeAreaTop: CGFloat {
        keyWindow?.safeAreaInsets.top ?? 0
    }
    
    class var safeAreaBottom: CGFloat {
       return keyWindow?.safeAreaInsets.bottom ?? 0
    }
      
    class func endEditing(){
        keyWindow?.endEditing(true)
    }
        
}
