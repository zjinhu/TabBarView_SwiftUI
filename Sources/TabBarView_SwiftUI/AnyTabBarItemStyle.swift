//
//  SwiftUIView.swift
//
//
//  Created by iOS on 2024/8/20.
//

import SwiftUI

public struct AnyTabBarItemStyle: TabBarItemStyle {
    private let _makeTabBarItem: (Image, Image, String, Color, Bool) -> AnyView
    
    public init<TabBarItem: TabBarItemStyle>(itemStyle: TabBarItem) {
        self._makeTabBarItem = itemStyle.tabBarItemErased(icon:selectedIcon:title:color:isSelected:)
    }
    
    public func tabBarItem(icon: Image, selectedIcon: Image, title: String, color: Color, isSelected: Bool) -> some View {
        return self._makeTabBarItem(icon, selectedIcon, title, color, isSelected)
    }
}

public protocol TabBarItemStyle {
    associatedtype Content : View
    
    func tabBarItem(icon: Image, title: String, color: Color, isSelected: Bool) -> Content
    func tabBarItem(icon: Image, selectedIcon: Image, title: String, color: Color, isSelected: Bool) -> Content
}

extension TabBarItemStyle {
    public func tabBarItem(icon: Image, title: String, color: Color, isSelected: Bool) -> Content {
        return self.tabBarItem(icon: icon, selectedIcon: icon, title: title ,color: color, isSelected: isSelected)
    }
    
    public func tabBarItem(icon: Image, selectedIcon: Image, title: String, color: Color, isSelected: Bool) -> Content {
        return self.tabBarItem(icon: icon, title: title, color: color, isSelected: isSelected)
    }
    
    func tabBarItemErased(icon: Image, selectedIcon: Image, title: String, color: Color, isSelected: Bool) -> AnyView {
        return .init(self.tabBarItem(icon: icon, selectedIcon: selectedIcon, title: title ,color: color, isSelected: isSelected))
    }
}

public struct DefaultTabBarItemStyle: TabBarItemStyle {
    
    public init(){}
    
    public func tabBarItem(icon: Image, selectedIcon: Image, title: String, color: Color, isSelected: Bool) -> some View {
        VStack(spacing: 5.0) {
            if isSelected{
                selectedIcon
                    .renderingMode(.template)
            }else{
                icon
                    .renderingMode(.template)
            }
            
            Text(title)
                .font(.system(size: 10.0, weight: .medium))
        }
        .foregroundColor(isSelected ? .accentColor : .gray)
    }
}
