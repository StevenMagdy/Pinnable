#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension LayoutGuide: Pinnable {
  /// Equivalent to `bottomAnchor`.
  public var firstBaselineAnchor: NSLayoutYAxisAnchor {
    bottomAnchor
  }

  /// Equivalent to `bottomAnchor`.
  public var lastBaselineAnchor: NSLayoutYAxisAnchor {
    bottomAnchor
  }
}
