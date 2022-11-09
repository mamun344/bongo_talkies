//
//  Bongo_TalkiesApp.swift
//  Bongo Talkies
//
//  Created by Admin on 4/11/22.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let device = Device()


    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        setupApp()
        
        if let windowScene = scene as? UIWindowScene {
            device.isLandscape = (windowScene.interfaceOrientation.isLandscape == true)
        }
        
        device.checkConnection()
        
        Router.navigate(device: device)
    }
    
    func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
        device.isLandscape = windowScene.interfaceOrientation.isLandscape
    }
    
    private func setupApp(){        
        let navBG = UIColor(.viewBG)
        let navTint = UIColor(.textRegular) 
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = navBG
        coloredAppearance.titleTextAttributes = [.foregroundColor: navTint]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: navTint]
        coloredAppearance.shadowColor = .clear // remove the bottom border line
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = navTint
        
        
        if #available(iOS 15, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
        if #available(iOS 14.0, *) { } else {
            UITableView.appearance().tableFooterView = UIView()
        }
        
        UITableView.appearance().separatorStyle = .none
    }
}

