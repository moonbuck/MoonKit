//
//  Strings.swift
//  SignalProcessing
//
//  Created by Jason Cardwell on 9/22/17.
//  Copyright © 2017 Moondeer Studios. All rights reserved.
//
import Foundation
#if os(iOS)
  import UIKit
#endif

extension Character {

  /// Operator providing a more convenient way to create a string by characeter repetition.
  ///
  /// - Parameters:
  ///   - lhs: The character to repeat.
  ///   - rhs: The number of times to repeat `lhs`.
  /// - Returns: A string composed of `lhs` repeated `rhs` times.
  public static func *(lhs: Character, rhs: Int) -> String {
    return String(repeating: lhs, count: rhs)
  }

}

extension String {

  /// Replaces all characters in the string that belong to the specified character set with the
  /// specified character.
  ///
  /// - Parameters:
  ///   - characterSet: The set of characters to replace.
  ///   - replacement: The Unicode scalar value with which to replace each occurence.
  /// - Returns: The string formed by replacing characters in `characterSet` with `replacement`.
  public func replacingCharacters(in characterSet: CharacterSet,
                                  with replacement: String) -> String
  {
    let scalarʹ = Unicode.Scalar(replacement)

    var scalars: [Unicode.Scalar] = []

    for scalar in unicodeScalars {
      if !characterSet.contains(scalar) { scalars.append(scalar) }
      else if let scalarʹ = scalarʹ { scalars.append(scalarʹ) }
    }

    return String(String.UnicodeScalarView(scalars))

  }

  /// Operator providing a more convenient way to create a string of a repeated characeter
  /// sequence.
  ///
  /// - Parameters:
  ///   - lhs: The character sequence to repeat.
  ///   - rhs: The number of times to repeat `lhs`.
  /// - Returns: A string composed of `lhs` repeated `rhs` times.
  public static func *(lhs: String, rhs: Int) -> String {
    return String(repeating: lhs, count: rhs)
  }

  /// An enumeration for specifying the location of a string's content within a padded string.
  public enum PadAlignment {

    /// The padding follows the content.
    case left

    /// Half the padding precedes the content and half the padding follows the content.
    case center

    /// The padding precedes the content.
    case right

  }

  /// Pads the string to create a new string.
  ///
  /// - Parameters:
  ///   - length: The length to which the string will be padded.
  ///   - alignment: The location of the string's content within the padded string.
  ///                Defaults to `left` alignment.
  ///   - padCharacter: The character used to pad the string to `length`.
  ///                   Defaults to `" "`.
  /// - Returns: The string padded to `length` using `padCharacter` and aligned via `alignment`.
  public func padded(to length: Int,
                     alignment: PadAlignment = .left,
                     padCharacter: Character = " ") -> String
  {

    // Check that the string does not satisfy `length`. If it does, just return the string.
    guard count < length else { return self }

    // Switch on the specified pad alignment.
    switch alignment {

      case .left:
        // Add the string's content. Add the padding.

        let pad = length - count
        return self + padCharacter * pad

      case .center:
        // Add half the padding. Add the string's content. Add the remaing padding.

        let leftPad = (length - count) / 2
        let rightPad = length - count - leftPad
        return padCharacter * leftPad + self + padCharacter * rightPad

      case .right:
        // Add the padding. Add the string's content.

        let pad = length - count
        return padCharacter * pad + self

    }

  }

  /// Intialzing with a description of a floating point number given a specified precision.
  ///
  /// - Parameters:
  ///   - value: The floating point value to describe.
  ///   - maxPrecision: The maximum number of decimals to include.
  ///   - minPrecision: The minimum number of decimals to include. Trailing zeros are removed
  ///                   until this threshold is reached. If this value is less than `1` and
  ///                   the fractional part is all zeros, the decimal will also be removed.
  public init<F>(describing value: F, maxPrecision: Int, minPrecision: Int)
    where F:FloatingPoint, F:CVarArg
  {

    guard minPrecision <= maxPrecision else {
      fatalError("\(#function) `minPrecision` must be ≤ `maxPrecision`.")
    }

    let pattern: String

    switch value {
      case is Float:
        pattern = "%.*f"
      case is Double,
           is CGFloat:
        pattern = "%.*lf"
      default:
        fatalError("\(#function) Unsupported floating point type: \(F.self)")
    }

    let string = String(format: pattern, value, maxPrecision)

    guard let decimal = string.index(of: ".") else { self = string; return }

    var end = string.endIndex
    while end > string.startIndex
      && (string[string.index(before: end)] == "0" || string[string.index(before: end)] == ".")
      && string.distance(from: decimal, to: end) > (minPrecision + 1)
    {
      end = string.index(before: end)
    }

    if string.index(before: end) == decimal { end = decimal }

    self = String(string[..<end])
  }

  public init<T:FixedWidthInteger>(_ v: T,
                                   radix: Int,
                                   uppercase: Bool = false,
                                   pad: Int,
                                   group: Int = 0,
                                   separator: String = " ")
  {
    self = String(v, radix: radix, uppercase: uppercase)
    var pad = pad
    guard pad > 0 else { return }
    pad -= utf16.count
    if pad > 0 { self = String(repeating: "0", count: pad) + self }
    guard group > 0 && count > group else { return }
    let characterGroups: [String] = segment(group, options: .padFirstGroup(Character("0")))
                                      .flatMap({String($0)})
    self = characterGroups.joined(separator: separator)
  }

  public init<S:Sequence>(hexBytes: S) where S.Iterator.Element == UInt8 {
    self = hexBytes.map({String($0, radix: 16, uppercase: true, pad: 2)}).joined(separator: " ")
  }

}

