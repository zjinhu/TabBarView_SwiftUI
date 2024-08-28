import SwiftUI

public class TabBarObservable: ObservableObject {
    @Published public var size: CGSize = .zero
    @Published public var axis: CGFloat = 0.0
    
    @Published public var isShowTabbar: Bool = true
    public init() {}
    
    public func showTabbar(){
        withAnimation(.easeInOut) {
            isShowTabbar = true
        }
    }
    
    public func hideTabbar(){
        withAnimation(.easeInOut) {
            isShowTabbar = false
        }
    }
}

struct TabBarItemSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func updateTabGeoSize(_ size: CGSize) -> some View {
        preference(key: TabBarItemSizePreferenceKey.self, value: size)
    }
}

struct TabBarPreferenceKey<TabBarItem: TabBarItemable>: PreferenceKey {
    static var defaultValue: [TabBarItem] {
        return .init()
    }
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value.append(contentsOf: nextValue())
    }
}

class TabBarSelection<TabBarItem: TabBarItemable>: ObservableObject {
    @Binding var selection: TabBarItem
    
    init(selection: Binding<TabBarItem>) {
        self._selection = selection
    }
}

