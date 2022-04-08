#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// A shared interface for the pinnable properties of `UIView` and `UILayoutGuide`.
public protocol Pinnable: AnyObject {
  var topAnchor: NSLayoutYAxisAnchor { get }
  var bottomAnchor: NSLayoutYAxisAnchor { get }

  var leftAnchor: NSLayoutXAxisAnchor { get }
  var rightAnchor: NSLayoutXAxisAnchor { get }

  var leadingAnchor: NSLayoutXAxisAnchor { get }
  var trailingAnchor: NSLayoutXAxisAnchor { get }

  var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
  var lastBaselineAnchor: NSLayoutYAxisAnchor { get }

  var centerXAnchor: NSLayoutXAxisAnchor { get }
  var centerYAnchor: NSLayoutYAxisAnchor { get }

  var widthAnchor: NSLayoutDimension { get }
  var heightAnchor: NSLayoutDimension { get }
}

extension Pinnable {
  /// Constrain the edges of the receiver to the corresponding edges of the provided view or layout guide.
  ///
  /// - Parameters:
  ///   - edges: The edges to constrain. Defaults to `.all`.
  ///   - object: The object to constrain the receiver to.
  ///   - insets: Optional insets to apply to the constraints. Defaults to `.zero`.
  ///   - priority: An optional priority for the constraints. Defaults to `.required`.
  /// - Returns: A named tuple of the created constraints. The properties are optional, as edges not specified will not have constraints.
  @available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
  @discardableResult
  public func pinEdges<P: Pinnable>(
    _ edges: NSDirectionalRectEdge = .all,
    to object: P,
    insets: NSDirectionalEdgeInsets = .init(),
    priority: Priority = .required
  ) -> (top: NSLayoutConstraint?, leading: NSLayoutConstraint?, bottom: NSLayoutConstraint?, trailing: NSLayoutConstraint?) {
    let insets = LegacyEdgeInsets(top: insets.top, left: insets.leading, bottom: insets.bottom, right: insets.trailing)
#if canImport(UIKit)
    let oldEdges = UIRectEdge(rawValue: edges.rawValue)
#elseif canImport(AppKit)
    var oldEdges: Set<NSRectEdge> = []
    if edges.contains(.top) { oldEdges.insert(.top) }
    if edges.contains(.leading) { oldEdges.insert(.left) }
    if edges.contains(.bottom) { oldEdges.insert(.bottom) }
    if edges.contains(.trailing) { oldEdges.insert(.right) }
#endif
    return _pinEdges(oldEdges, to: object, insets: insets, priority: priority)
  }

#if canImport(UIKit)

  /// Constrain the edges of the receiver to the corresponding edges of the provided view or layout guide.
  ///
  /// - Parameters:
  ///   - edges: The edges to constrain. The `left` and `right` edge will constrain the `leading` and `trailing` anchors, respectively. Defaults to `.all`.
  ///   - object: The object to constrain the receiver to.
  ///   - insets: Optional insets to apply to the constraints. The top, left, bottom, and right constants will be applied to the top, leading, bottom, and trailing edges, respectively. Defaults to `.zero`.
  ///   - priority: An optional priority for the constraints. Defaults to `.required`.
  /// - Returns: A named tuple of the created constraints. The properties are optional, as edges not specified will not have constraints.
  @available(iOS, deprecated: 13.0, message: "Use leading and trailing instead of left and right, respectively.")
  @available(macOS, deprecated: 10.15, message: "Use leading and trailing instead of left and right, respectively.")
  @available(tvOS, deprecated: 10.15, message: "Use leading and trailing instead of left and right, respectively.")
  @_disfavoredOverload
  @discardableResult
  public func pinEdges<P: Pinnable>(
    _ edges: UIRectEdge = .all,
    to object: P,
    insets: UIEdgeInsets = .zero,
    priority: Priority = .required
  ) -> (top: NSLayoutConstraint?, leading: NSLayoutConstraint?, bottom: NSLayoutConstraint?, trailing: NSLayoutConstraint?) {
    return _pinEdges(edges, to: object, insets: insets, priority: priority)
  }

#elseif canImport(AppKit)

  /// Constrain the edges of the receiver to the corresponding edges of the provided view or layout guide.
  ///
  /// - Parameters:
  ///   - edges: The edges to constrain. The `minX` and `maxX` edge will constrain the `leading` and `trailing` anchors, respectively. Defaults to all four edges.
  ///   - object: The object to constrain the receiver to.
  ///   - insets: Optional insets to apply to the constraints. The top, left, bottom, and right constants will be applied to the top, leading, bottom, and trailing edges, respectively. Defaults to `NSEdgeInsetsZero`.
  ///   - priority: An optional priority for the constraints. Defaults to `.required`.
  /// - Returns: A named tuple of the created constraints. The properties are optional, as edges not specified will not have constraints.
  @available(iOS, deprecated: 13.0, message: "Use leading and trailing instead of left and right, respectively.")
  @available(macOS, deprecated: 10.15, message: "Use leading and trailing instead of left and right, respectively.")
  @available(tvOS, deprecated: 10.15, message: "Use leading and trailing instead of left and right, respectively.")
  @_disfavoredOverload
  @discardableResult
  public func pinEdges<P: Pinnable>(
    _ edges: Set<NSRectEdge> = [.minY, .minX, .maxY, .maxX],
    to object: P,
    insets: NSEdgeInsets = NSEdgeInsetsZero,
    priority: Priority = .required
  ) -> (top: NSLayoutConstraint?, leading: NSLayoutConstraint?, bottom: NSLayoutConstraint?, trailing: NSLayoutConstraint?) {
    return _pinEdges(edges, to: object, insets: insets, priority: priority)
  }
#endif

  private func _pinEdges<P: Pinnable>(
    _ edges: LegacyRectEdge,
    to object: P,
    insets: LegacyEdgeInsets,
    priority: Priority
  ) -> (NSLayoutConstraint?, NSLayoutConstraint?, NSLayoutConstraint?, NSLayoutConstraint?) {
    let top = edges.contains(.top) ? topAnchor.constraint(equalTo: object.topAnchor, constant: insets.top) : nil
    let leading = edges.contains(.left) ? leadingAnchor.constraint(equalTo: object.leadingAnchor, constant: insets.left) : nil
    let bottom = edges.contains(.bottom) ? bottomAnchor.constraint(equalTo: object.bottomAnchor, constant: -insets.bottom) : nil
    let trailing = edges.contains(.right) ? trailingAnchor.constraint(equalTo: object.trailingAnchor, constant: -insets.right) : nil

    (self as? View)?.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([top, leading, bottom, trailing].compactMap { $0?.prioritize(priority) })

    return (top, leading, bottom, trailing)
  }

  /// Constrain the center of the receiver to the center of the provided view or layout guide.
  ///
  /// - Parameters:
  ///   - object: The object to constrain the receiver to.
  ///   - offset: An optional offset for the constraints. The horizontal offset will be applied to the center X anchor, and the vertical offset will be applied to the center Y anchor. Defaults to `.zero`.
  /// - Returns: A named tuple of the created constraints.
  @discardableResult
  public func pinCenter<P: Pinnable>(
    to object: P,
    offset: CGPoint = .zero
  ) -> (x: NSLayoutConstraint, y: NSLayoutConstraint) {
    let centerX = centerXAnchor.constraint(equalTo: object.centerXAnchor, constant: offset.x)
    let centerY = centerYAnchor.constraint(equalTo: object.centerYAnchor, constant: offset.y)

    (self as? View)?.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([centerX, centerY])

    return (x: centerX, y: centerY)
  }

  /// Constrain the size of the receiver to the size of the provided view or layout guide.
  ///
  /// Note: to constrain a view or layout guide in a single dimension, pin the desired layout anchors directly, e.g.:
  ///
  ///     a.widthAnchor.pin(to: b.widthAnchor)
  ///
  /// - Parameters:
  ///   - object: The object to constrain the receiver to.
  /// - Returns: A named tuple of the created constraints.
  @discardableResult
  public func pinSize<P: Pinnable>(
    to object: P
  ) -> (width: NSLayoutConstraint, height: NSLayoutConstraint) {
    let height = heightAnchor.constraint(equalTo: object.heightAnchor)
    let width = widthAnchor.constraint(equalTo: object.widthAnchor)

    (self as? View)?.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([height, width])

    return (width: width, height: height)
  }

  /// Constrain the size of the receiver to the provided constant size.
  ///
  /// Note: to constrain a view or layout guide in a single dimension, pin the desired layout anchor directly, e.g.:
  ///
  ///     a.widthAnchor.pin(to: 100)
  ///
  /// - Parameters:
  ///   - object: The size to constrain the receiver to.
  /// - Returns: A named tuple of the created constraints.
  @discardableResult
  public func pinSize(
    to size: CGSize
  ) -> (width: NSLayoutConstraint, height: NSLayoutConstraint) {
    let height = heightAnchor.constraint(equalToConstant: size.height)
    let width = widthAnchor.constraint(equalToConstant: size.width)

    (self as? View)?.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([height, width])

    return (width: width, height: height)
  }
}
