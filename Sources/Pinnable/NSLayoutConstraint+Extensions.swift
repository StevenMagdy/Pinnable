#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension NSLayoutConstraint {
  /// Set `isActive` to true.
  ///
  /// - Returns: self
  @discardableResult
  public func activate() -> Self {
    isActive = true
    return self
  }

  /// Set `isActive` to false.
  ///
  /// - Returns: self
  @discardableResult
  public func deactivate() -> Self {
    isActive = false
    return self
  }

  /// Set the priority on the constraint.
  ///
  /// - Parameter priority: The value of the priority.
  /// - Returns: self
  @discardableResult
  public func prioritize(_ priority: Priority) -> Self {
    self.priority = priority
    return self
  }

  internal func setUp() -> NSLayoutConstraint {
    (firstItem as? View)?.translatesAutoresizingMaskIntoConstraints = false
    return activate()
  }

  public func copyWith(multiplier: CGFloat) -> Self {
    return .init(
      item: firstItem as Any,
      attribute: firstAttribute,
      relatedBy: relation,
      toItem: secondItem,
      attribute: secondAttribute,
      multiplier: multiplier,
      constant: constant
    ).prioritize(priority)
  }
}
