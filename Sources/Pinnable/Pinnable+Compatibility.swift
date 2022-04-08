#if canImport(UIKit)
import UIKit

public typealias Priority = UILayoutPriority

internal typealias LayoutGuide = UILayoutGuide
internal typealias LegacyEdgeInsets = UIEdgeInsets
internal typealias LegacyRectEdge = UIRectEdge
internal typealias View = UIView

#elseif canImport(AppKit)
import AppKit

public typealias Priority = NSLayoutConstraint.Priority

internal typealias LayoutGuide = NSLayoutGuide
internal typealias LegacyEdgeInsets = NSEdgeInsets
internal typealias LegacyRectEdge = Set<NSRectEdge>
internal typealias View = NSView
extension NSRectEdge {
  internal static var top: Self { .minY }
  internal static var bottom: Self { .maxY }
  internal static var left: Self { .minX }
  internal static var right: Self { .maxX }
}
#endif
