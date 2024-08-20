import SwiftUI
public protocol TabBarItemable: Hashable {

    var icon: Image { get }
    var selectedIcon: Image { get }

    var title: String { get }
    var color: Color { get }
}

public extension TabBarItemable {
    var selectedIcon: Image {
        return self.icon
    }

    static func isItemSelected(selector: Self, icon: Image, title: String, color: Color) -> Bool {
        return selector.icon == icon && selector.title == title && selector.color == color
    }
}

