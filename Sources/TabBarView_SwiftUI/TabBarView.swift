import SwiftUI
public struct TabBarView<TabItem: TabBarItemable, Content: View>: View {
    @EnvironmentObject var tabItem: TabBarObservable
    
    private let selectedItem: TabBarSelection<TabItem>
    private let animation: Binding<Animation>
    private let content: Content
    
    private var tabBarItemStyle: AnyTabBarItemStyle
    private var tabBarViewStyle: AnyTabBarViewStyle
    
    @State private var tabs: [TabItem]
    
    public init(selection: Binding<TabItem>,
                animation: Binding<Animation> = .constant(.easeInOut),
                @ViewBuilder content: () -> Content) {
        self.selectedItem = .init(selection: selection)
        self.animation = animation
        self.content = content()
        
        self.tabBarItemStyle = .init(itemStyle: DefaultTabBarItemStyle())
        self.tabBarViewStyle = .init(tabStyle: DefaultTabBarViewStyle())
        
        self._tabs = .init(initialValue: .init())
    }
    
    public var body: some View {
        ZStack {
            self.content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environmentObject(self.selectedItem)
            
            GeometryReader { geo in
                VStack {
                    Spacer()
                    
                    if tabItem.isShowTabbar{
                        self.tabBarViewStyle.tabBarView(with: geo) {
                            .init(self.tabItems)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .onPreferenceChange(TabBarPreferenceKey.self) { value in
            self.tabs = value
        }
    }

}

extension TabBarView {
    private var tabItems: some View {
        HStack {
            ForEach(self.tabs, id: \.self) { item in
                GeometryReader { geo in
                    self.tabBarItemStyle.tabBarItem(
                        icon: item.icon,
                        selectedIcon: item.selectedIcon,
                        title: item.title,
                        color: item.color,
                        isSelected: self.selectedItem.selection == item)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .updateTabGeoSize(geo.size)
                    .onAppear {
                        if item == self.tabs.first {
                            tabItem.axis = geo.frame(in: .global).midX - 16
                        }
                    }
                    .onTapGesture {
                        self.selectedItem.selection = item
                        self.selectedItem.objectWillChange.send()
                        withAnimation(animation.wrappedValue) {
                            tabItem.axis = geo.frame(in: .global).midX - 16
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .onPreferenceChange(TabBarItemSizePreferenceKey.self, perform: { value in
            tabItem.size = value
        })
    }

    public func tabBarItem<ItemStyle: TabBarItemStyle>(style: ItemStyle) -> Self {
        var _self = self
        _self.tabBarItemStyle = .init(itemStyle: style)
        return _self
    }

    public func tabBarView<TabStyle: TabBarViewStyle>(style: TabStyle) -> Self {
        var _self = self
        _self.tabBarViewStyle = .init(tabStyle: style)
        return _self
    }
}


struct TabBarViewModifier<TabItem: TabBarItemable>: ViewModifier {
    @EnvironmentObject private var selectionObject: TabBarSelection<TabItem>
    
    let item: TabItem
    
    func body(content: Content) -> some View {
        Group {
            if self.item == self.selectionObject.selection {
                content
            } else {
                Color.clear
            }
        }
        .preference(key: TabBarPreferenceKey.self, value: [self.item])
    }
}

extension View{
    public func tabItem<TabItem: TabBarItemable>(for item: TabItem) -> some View {
        return self.modifier(TabBarViewModifier(item: item))
    }
}
