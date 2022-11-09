//
//  NavigationBarModifier.swift
//  OSS Salesforce
//
//  Created by Admin on 22/8/22.
//

import Foundation
import SwiftUI

struct NavigationBarModifier: ViewModifier {
    
    private let title: String
    private let hasBack: Bool
    private let onBack : (()->())?
    
    @Environment(\.presentationMode) private var presentation
    
    
    public init(title: String, hasBack: Bool = true, onBack: (()->())? = nil) {
        self.title = title
        self.hasBack = hasBack
        self.onBack = onBack
    }

    
    
    func body(content: Content) -> some View {
        content
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: barItemsView)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())

            
    }
    
    @ViewBuilder
    private var barItemsView: some View {
        if hasBack {
            Button(action: {
                if let onBack = onBack {
                    onBack()
                }
                else {
                    self.presentation.wrappedValue.dismiss()
                }
            }) {
                HStack(alignment: .center, spacing: 12) {
                    backButtonView
                    titleView
                }
            }
        }
        else {
            titleView
        }
    }
    
    @ViewBuilder
    private var backButtonView: some View {
        Image(.navBack)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 15)
            .foregroundColor(.navTitle)

    }
    
    @ViewBuilder
    private var titleView: some View {
        Text(title)
            .font(Font.system(size: 19)).fontWeight(.medium)
            .foregroundColor(.navTitle)
    }
}

extension View {
    func navigationBar(title: String, hasBack: Bool = true, onBack: (()->())? = nil) -> some View {
        return self.modifier(NavigationBarModifier(title: title, hasBack: hasBack, onBack: onBack))
    }
}
