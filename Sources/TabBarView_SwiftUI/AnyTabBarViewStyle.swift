//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2024/8/20.
//

import SwiftUI

public struct AnyTabBarViewStyle: TabBarViewStyle {
    private let _makeTabBarView: (GeometryProxy, @escaping () -> AnyView) -> AnyView
    
    public init<TabStyle: TabBarViewStyle>(tabStyle: TabStyle) {
        self._makeTabBarView = tabStyle.tabBarViewErased
    }
    
    public func tabBarView(with geometry: GeometryProxy, container: @escaping () -> AnyView) -> some View {
        return self._makeTabBarView(geometry, container)
    }
}

public protocol TabBarViewStyle {
    associatedtype Content: View
    func tabBarView(with geometry: GeometryProxy, container: @escaping () -> AnyView) -> Content
}

extension TabBarViewStyle {
    func tabBarViewErased(with geometry: GeometryProxy, container: @escaping () -> AnyView) -> AnyView {
        return .init(self.tabBarView(with: geometry, container: container))
    }
}

public struct DefaultTabBarViewStyle: TabBarViewStyle {
    
    public init(){}
    
    public func tabBarView(with geometry: GeometryProxy, container: @escaping () -> AnyView) -> some View {
        VStack(spacing: 0.0) {
            Divider()
                .edgesIgnoringSafeArea(.horizontal)
            
            VStack {
                container()
                    .frame(height: 50.0)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .background(
                Color(
                    red:   249 / 255,
                    green: 249 / 255,
                    blue:  249 / 255,
                    opacity: 0.94
                )
            )
            .frame(height: 50.0 + geometry.safeAreaInsets.bottom)
        }
    }
}
