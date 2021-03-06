//
//  CGPoint+MoonKitAdditions.swift
//  MoonKit
//
//  Created by Jason Cardwell on 10/8/15.
//  Copyright © 2015 Jason Cardwell. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {

  public init?(_ string: String?) {
    if let s = string {
      self = NSCoder.cgPoint(for: s)
    } else { return nil }
  }
  public var string: String { return NSCoder.string(for: self) }
  public static var null: CGPoint = CGPoint(x: CGFloat.nan, y: CGFloat.nan)
  public var isNull: Bool { return x.isNaN || y.isNaN }
  public func xDelta(_ point: CGPoint) -> CGFloat { return point.isNull ? x : x - point.x }
  public func yDelta(_ point: CGPoint) -> CGFloat { return point.isNull ? y : y - point.y }
  public func delta(_ point: CGPoint) -> CGPoint { return self - point }
  public func absXDelta(_ point: CGPoint) -> CGFloat { return abs(xDelta(point)) }
  public func absYDelta(_ point: CGPoint) -> CGFloat { return abs(yDelta(point)) }
  public func absDelta(_ point: CGPoint) -> CGPoint { return (self - point).absolute }
  public mutating func transform(_ transform: CGAffineTransform) { self = pointByApplyingTransform(transform) }
  public var absolute: CGPoint { return self.isNull ? self :  CGPoint(x: abs(x), y: abs(y)) }
  public func pointByApplyingTransform(_ transform: CGAffineTransform) -> CGPoint {
    return self.applying(transform)
  }
  public func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint { return CGPoint(x: x + dx, y: y + dy) }
  public func distanceTo(_ point: CGPoint) -> CGFloat {
    guard !point.isNull else { return CGFloat.nan }
    return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
  }

  public func description(_ precision: Int) -> String {
    return precision >= 0 ? "(\(x.rounded(precision)), \(y.rounded(precision)))" : description
  }

  public var max: CGFloat { return y > x ? y : x }
  public var min: CGFloat { return y < x ? y : x }
  public init(_ vector: CGVector) { self.init(x: vector.dx, y: vector.dy) }
}

//extension CGPoint: ExpressibleByNilLiteral {
//  public init(nilLiteral: ()) { self = CGPoint.null }
//}

extension CGPoint: Hashable {
  public func hash(into hasher: inout Hasher) {
    x.hash(into: &hasher)
    y.hash(into: &hasher)
  }
}

extension CGPoint: Unpackable2 {
  public var unpack: (CGFloat, CGFloat) { return (x, y) }
}

extension CGPoint: Packable2 {
  public init(_ elements: (CGFloat, CGFloat)) { self.init(x: elements.0, y: elements.1) }
}
extension CGPoint: CustomStringConvertible {
  public var description: String { return "(\(x), \(y))" }
}
//extension CGPoint: CustomDebugStringConvertible {
//  public var debugDescription: String { var result = ""; dump(self, &result); return result }
//}

public func +(lhs: CGPoint, rhs: (CGFloat, CGFloat)) -> CGPoint {
  return lhs.isNull ? CGPoint(x: rhs.0, y: rhs.1) : CGPoint(x: lhs.x + rhs.0, y: lhs.y + rhs.1)
}

public func +=(lhs: inout CGPoint, rhs: (CGFloat, CGFloat)) {
  lhs = lhs + rhs
}

public func -(lhs: CGPoint, rhs: (CGFloat, CGFloat)) -> CGPoint {
  return lhs.isNull ? CGPoint(x: rhs.0, y: rhs.1) : CGPoint(x: lhs.x - rhs.0, y: lhs.y - rhs.1)
}

public func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return lhs.isNull ? CGPoint(x: rhs.x, y: rhs.y) : rhs.isNull ? lhs : CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

//public func +(lhs: CGPoint, rhs: (CGFloatable, CGFloatable)) -> CGPoint {
//  return lhs.isNull
//    ? CGPoint(x: rhs.0.CGFloatValue, y: rhs.1.CGFloatValue)
//    : CGPoint(x: lhs.x + rhs.0.CGFloatValue, y: lhs.y + rhs.1.CGFloatValue)
//}
//public func +=(lhs: inout CGPoint, rhs: (CGFloatable, CGFloatable)) {
//  lhs = lhs + rhs
//}

public func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint { return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs) }
//public func /(lhs: CGPoint, rhs: CGFloatable) -> CGPoint {
//  return CGPoint(x: lhs.x / rhs.CGFloatValue, y: lhs.y / rhs.CGFloatValue)
//}

//public func /(lhs: CGFloatable, rhs: CGPoint) -> CGPoint {
//  let floatable = lhs.CGFloatValue
//  return CGPoint(x: floatable / rhs.x, y: floatable / rhs.y)
//}

public func /=(lhs: CGPoint, rhs: CGFloat) { var lhs = lhs; lhs = lhs / rhs }
//public func /=(lhs: CGPoint, rhs: CGFloatable) { var lhs = lhs; lhs = lhs / rhs }

public func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint { return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs) }
//public func *(lhs: CGPoint, rhs: CGFloatable) -> CGPoint {
//  return CGPoint(x: lhs.x * rhs.CGFloatValue, y: lhs.y * rhs.CGFloatValue)
//}
public func *(lhs: CGPoint, rhs: (CGFloat, CGFloat)) -> CGPoint { return CGPoint(x: lhs.x * rhs.0, y: lhs.y * rhs.1) }
//public func *(lhs: CGPoint, rhs: (CGFloatable, CGFloatable)) -> CGPoint {
//  return CGPoint(x: lhs.x * rhs.0.CGFloatValue, y: lhs.y * rhs.1.CGFloatValue)
//}


public func *=(lhs: CGPoint, rhs: CGFloat) { var lhs = lhs; lhs = lhs * rhs }
//public func *=(lhs: CGPoint, rhs: CGFloatable) { var lhs = lhs; lhs = lhs * rhs }
public func *=(lhs: CGPoint, rhs: (CGFloat, CGFloat)) { var lhs = lhs; lhs = lhs * rhs }
//public func *=(lhs: CGPoint, rhs: (CGFloatable, CGFloatable)) { var lhs = lhs; lhs = lhs * rhs }

extension CGPoint: JSONValueConvertible {
  public var jsonValue: JSONValue {
    return ObjectJSONValue(["x": x.jsonValue, "y": y.jsonValue]).jsonValue
  }
}

extension CGPoint: JSONValueInitializable {
  public init?(_ jsonValue: JSONValue?) {
    guard let dict = ObjectJSONValue(jsonValue), let x = CGFloat(dict["x"]), let y = CGFloat(dict["y"]) else { return nil }
    self.init(x: x, y: y)
  }
}
