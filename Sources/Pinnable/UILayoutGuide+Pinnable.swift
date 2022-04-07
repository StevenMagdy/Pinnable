import UIKit

extension UILayoutGuide: Pinnable {
  /// Equivalent to `bottomAnchor`.
  public var firstBaselineAnchor: NSLayoutYAxisAnchor {
    bottomAnchor
  }
  
  /// Equivalent to `bottomAnchor`.
  public var lastBaselineAnchor: NSLayoutYAxisAnchor {
    bottomAnchor
  }
}
