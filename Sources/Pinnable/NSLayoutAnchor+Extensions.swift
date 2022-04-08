#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension NSLayoutAnchor {
  /// Create an equal-to constraint between the receiver and the provided layout anchor.  The constraint is automatically activated.
  ///
  /// If the receiver is an anchor on a `UIView`, this method disables `translatesAutoresizingMaskIntoConstraints` on that view.
  ///
  /// - Parameters:
  ///   - anchor: The anchor to constrain the receiver to.
  ///   - multiplier: An optional multiplier for the constraint. Defaults to 1.
  ///   - constant: An optional constant for the constraint. Defaults to 0.
  ///   - priority: An optional priority for the constraint. Defaults to `.required`.
  /// - Returns: The constraint that was created.
  @objc
  @discardableResult
  public func pin(
    to anchor: NSLayoutAnchor<AnchorType>,
    multiplier: CGFloat = 1,
    constant: CGFloat = 0,
    priority: Priority = .required
  ) -> NSLayoutConstraint {
    return constraint(equalTo: anchor, constant: constant)
      .copyWith(multiplier: multiplier)
      .prioritize(priority)
      .setUp()
  }

  /// Create a greater-than-or-equal-to constraint between the receiver and the provided layout anchor.  The constraint is automatically activated.
  ///
  /// If the receiver is an anchor on a `UIView`, this method disables `translatesAutoresizingMaskIntoConstraints` on that view.
  ///
  /// - Parameters:
  ///   - anchor: The anchor to constrain the receiver to.
  ///   - multiplier: An optional multiplier for the constraint. Defaults to 1.
  ///   - constant: An optional constant for the constraint. Defaults to 0.
  ///   - priority: An optional priority for the constraint. Defaults to `.required`.
  /// - Returns: The constraint that was created.
  @objc
  @discardableResult
  public func pin(
    greaterThan anchor: NSLayoutAnchor<AnchorType>,
    multiplier: CGFloat = 1,
    constant: CGFloat = 0,
    priority: Priority = .required
  ) -> NSLayoutConstraint {
    return constraint(greaterThanOrEqualTo: anchor, constant: constant)
      .copyWith(multiplier: multiplier)
      .prioritize(priority)
      .setUp()
  }

  /// Create a less-than-or-equal-to constraint between the receiver and the provided layout anchor.  The constraint is automatically activated.
  ///
  /// If the receiver is an anchor on a `UIView`, this method disables `translatesAutoresizingMaskIntoConstraints` on that view.
  ///
  /// - Parameters:
  ///   - anchor: The anchor to constrain the receiver to.
  ///   - multiplier: An optional multiplier for the constraint. Defaults to 1.
  ///   - constant: An optional constant for the constraint. Defaults to 0.
  ///   - priority: An optional priority for the constraint. Defaults to `.required`.
  /// - Returns: The constraint that was created.
  @objc
  @discardableResult
  public func pin(
    lessThan anchor: NSLayoutAnchor<AnchorType>,
    multiplier: CGFloat = 1,
    constant: CGFloat = 0,
    priority: Priority = .required
  ) -> NSLayoutConstraint {
    return constraint(lessThanOrEqualTo: anchor, constant: constant)
      .copyWith(multiplier: multiplier)
      .prioritize(priority)
      .setUp()
  }
}
