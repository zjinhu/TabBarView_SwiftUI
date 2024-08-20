import SwiftUI

public class TabBarItemSize: ObservableObject {
    @Published public var size: CGSize = .zero
    @Published public var axis: CGFloat = 0.0
    
    public init() {}
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

