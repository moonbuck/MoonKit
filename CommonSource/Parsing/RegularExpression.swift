//
//  RegularExpression.swift
//  MoonKit
//
//  Created by Jason Cardwell on 9/15/17.
//  Copyright (c) 2017 Moondeer Studios. All rights reserved.
//
import Foundation

// MARK: - RegularExpression

public struct RegularExpression {
  /// The foundation object being wrapped.
  private let regex: NSRegularExpression

  /// The index of named capture groups.
  public let namedCaptureGroups: [String: Int]

  /// A regular expression for matching named capture groups in a pattern.
  private static let namedCapturesExpression =
    RegularExpression(
      regex: try! NSRegularExpression(
        pattern: #"(?<![\\\[])[(](?:\?<([^>]+)>)?(?![?]:)"#),
      namedCaptureGroups: [:])

  /// The regular expression's pattern.
  public var pattern: String { regex.pattern }

  public typealias Options = NSRegularExpression.Options

  /// The regular expression's options.
  public var options: Options { regex.options }

  /// The number of capture groups in the regular expression.
  public var numberOfCaptureGroups: Int { regex.numberOfCaptureGroups }

  /// Initializing with an existing foundation type and named capture groups.
  ///
  /// - Parameters:
  ///   - regex: The `NSRegularExpression` to wrap.
  ///   - namedCaptureGroups: The dictionary of named capture groups.
  public init(regex: NSRegularExpression, namedCaptureGroups: [String: Int]) {
    self.regex = regex
    self.namedCaptureGroups = namedCaptureGroups
  }

  /// Initializing with an existing foundation type. This initializer parses the existing
  /// pattern for named capture groups.
  ///
  /// - Parameter regex: The `NSRegularExpression` to wrap.
  public init(regex: NSRegularExpression) {
    // Initialize the wrapped regular expression.
    self.regex = regex

    // Get any matches for named capture groups in `regex.pattern`.
    let matches = RegularExpression.namedCapturesExpression.match(string: regex.pattern)

    // Get the enumerated captures.
    let captures = matches.map { $0.captures[1] }.enumerated().compactMap {
      $1 != nil ? (String($1!.substring), $0 + 1) : nil
    }

    // Initialize the named capture groups.
    namedCaptureGroups = Dictionary(uniqueKeysWithValues: captures)
  }

  /// Intializing with a pattern and options.
  ///
  /// - Parameters:
  ///   - pattern: The pattern for the regular expression.
  ///   - options: The options for the regular expression.
  /// - Throws: Any error thrown by `NSRegularExpression.init(pattern:options:)`
  public init(pattern: String, options: Options = []) throws {
    self.init(regex: try NSRegularExpression(pattern: pattern, options: options))
  }

  /// Calculates the number of matches within a specified range of a string.
  ///
  /// - Parameters:
  ///   - string: The string to match.
  ///   - anchored: Whether the matching should be anchored.
  ///   - range: The range within which to match or `nil` for the full range of `string`.
  /// - Returns: The number of matches.
  public func numberOfMatches(in string: String,
                              anchored: Bool = false,
                              range: Range<String.Index>? = nil) -> Int
  {
    // Return the number of matches returned by `regex`.
    regex.numberOfMatches(in: string,
                          options: anchored ? .anchored : [],
                          range: NSRange(range ?? string.startIndex..<string.endIndex,
                                         in: string))
  }

  /// Returns the matches in a string within the specified range.
  ///
  /// - Parameters:
  ///   - string: The string to match.
  ///   - anchored: Whether the matching should be anchored.
  ///   - range: The range within `string` to match or `nil` for the full the string.
  /// - Returns: An array containing any matches found.
  public func match(string: String,
                    anchored: Bool = false,
                    range: Range<String.Index>? = nil) -> [Match]
  {
    // Return the matches returned by `regex` flat-mapped to `Match` instances.
    regex.matches(in: string,
                  options: anchored ? .anchored : [],
                  range: NSRange(range ?? string.startIndex..<string.endIndex,
                                 in: string)).compactMap {
      Match(result: $0,
            string: string,
            namedCaptureGroups: namedCaptureGroups)
    }
  }

  /// Returns the first match in a string within the specified range.
  ///
  /// - Parameters:
  ///   - string: The string to match.
  ///   - anchored: Whether the matching should be anchored.
  ///   - range: The range within `string` to match or `nil` for the full the string.
  /// - Returns: The first match or `nil`.
  public func firstMatch(in string: String,
                         anchored: Bool = false,
                         range: Range<String.Index>? = nil) -> Match?
  {
    // Create a variable to store the first match.
    var result: Match?

    // Enumerate matches to retrieve the first match and then stop enumerating.
    enumerateMatches(in: string, anchored: anchored, range: range) {
      result = $0
      $1 = true
    }

    return result
  }

  /// Returns the ranges of the matches for the specified string.
  /// - Parameters:
  ///   - string: The string to match.
  ///   - anchored: Whether the matching should be anchored.
  ///   - range: The range within `string` to match or `nil` for the full the string.
  /// - Returns: An Array of the ranges for the matches in `string`.
  public func matchRanges(in string: String,
                          anchored: Bool = false,
                          range: Range<String.Index>? = nil) -> [NSRange]
  {
    return match(string: string, anchored: anchored, range: range).map(\Match.range)
  }

  /// Enumerates the matches in a string allowing the block provided to handle each match.
  ///
  /// - Parameters:
  ///   - string: The string to match.
  ///   - anchored: Whether the matching should be anchored.
  ///   - range: The range within string to match or `nil` for the full string.
  ///   - block: The block invoked for each match.
  ///   - match: The current match
  ///   - stop: A flag which can be set to `true` to halt enumeration.
  public func enumerateMatches(in string: String,
                               anchored: Bool = false,
                               range: Range<String.Index>? = nil,
                               usingBlock block: (_ match: Match,
                                                  _ stop: inout Bool) -> Void)
  {
    // Create an `NSRange` for range to match.
    let range = NSRange(range ?? string.startIndex..<string.endIndex, in: string)

    // Enumerate matches using `regex`.
    regex.enumerateMatches(in: string, options: anchored ? .anchored : [], range: range) {
      result, _, stop in

      // Return if there is no result.
      guard let result = result else { return }

      // Create a stop flag to pass to `block`.
      var shouldStop = false

      // Try creating a new match using the text checking result.
      if let match = Match(result: result,
                           string: string,
                           namedCaptureGroups: namedCaptureGroups)
      {
        // Invoke the block passing the match and the stop flag.
        block(match, &shouldStop)
      }

      // Update the outer stop pointer if the stop flag was set to `true` by the block.
      if shouldStop { stop.pointee = true }
    }
  }

  /// Performs substitutions for matches in the specified string using the specified
  /// template.
  ///
  /// - Parameters:
  ///   - string: The string to manipulate.
  ///   - template: The template for substitutions.
  /// - Returns: The result of replacing matches in `string` using `template`.
  public func substitute(matchesIn string: String, using template: String) -> String {
    regex.stringByReplacingMatches(in: string,
                                   range: NSRange(string.startIndex..<string.endIndex,
                                                  in: string),
                                   withTemplate: template)
  }

  /// Performs substitutions for matches in the specified string using the specified
  /// block to generate replacements.
  ///
  /// - Parameters:
  ///   - string: The string to manipulate.
  ///   - block: The block to use to generate replacements.
  /// - Returns: The result of replacing matches in `string` using `block`.
  public func substitute(matchesIn string: String,
                         using block: (Match) -> String) -> String
  {
    var result = string
    var offset = 0

    enumerateMatches(in: string) {
      (match: Match, stop: inout Bool) in

      let beforeCount = result.count

      let current = result

      let matchStart = current.index(current.startIndex,
                                     offsetBy: match.range.location + offset)

      let lhs = current[..<matchStart]

      let matchEnd = current.index(matchStart, offsetBy: match.range.length)
      let rhs = current[matchEnd...]

      let middle = block(match)

      result = "\(lhs)\(middle)\(rhs)"

      let afterCount = result.count

      let delta = afterCount - beforeCount

      offset += delta

    }

    return result

  }

  /// A structure for holding the details for a regular expression match.
  public struct Match: CustomStringConvertible {
    public let range: NSRange

    /// The collection of captures of which the match is composed.
    public let captures: [Capture?]

    /// The matched substring.
    public var substring: Substring

    /// The named capture groups for the matched regular expression.
    public let namedCaptureGroups: [String: Int]

    /// Accessor for a named capture.
    ///
    /// - Parameter name: The name of the capture group.
    public subscript(name: String) -> Capture? {
      // Try getting the index and unwrapping the `captures[index]`.
      guard let index = namedCaptureGroups[name],
            let capture = captures[index]
      else {
        return nil
      }

      return capture
    }

    /// Accessor for the capture at a specifified position within `captures`.
    ///
    /// - Parameter position: The position within `captures` of the capture.
    public subscript(position: Int) -> Capture? {
      return captures[position]
    }

    /// Initialize by converting a text checking result given the string it checked.
    ///
    /// - Parameters:
    ///   - result: The text checking result.
    ///   - string: The string checked by `result`.
    ///   - namedCaptureGroups: The named capture groups within the associated
    ///                         regular expression.
    public init?(result: NSTextCheckingResult,
                 string: String,
                 namedCaptureGroups: [String: Int])
    {
      // Ensure the result specifies a match while converting the range into a
      // range suitable for subscripting `string`.
      guard let range = Range(result.range, in: string) else { return nil }
      self.range = result.range

      // Initialize the substring property.
      substring = string[range]

      // Initialize the named capture groups property.
      self.namedCaptureGroups = namedCaptureGroups

      // Initialize the captures property by mapping the ranges held by `result`.
      captures = (0..<result.numberOfRanges).map {
        Capture(group: $0, range: result.range(at: $0), string: string)
      }
    }

    /// A brief description of the match.
    public var description: String {
      return "{\(captures.compactMap { $0?.description }.joined(separator: ", "))}"
    }
  }

  /// A structure composed of the number of a capture group within a regular
  /// expression and the corresponding substring within the string matched by
  /// that regular expression.
  public struct Capture: CustomStringConvertible {
    /// The index of the capture group within the associated regular expression.
    public let group: Int

    /// The content of the capture.
    public let substring: Substring

    public let range: Range<String.Index>

    /// Initialize with a group, a string and the range of a substring within the string.
    /// The initializer will return `nil` when `range.location == NSNotFound`.
    ///
    /// - Parameters:
    ///   - group: The index of the capture group within the associated regular
    ///            expression.
    ///   - range: The range of the captured substring.
    ///   - string: The full string within which a substring has been captured.
    public init?(group: Int, range: NSRange, string: String) {
      // Ensure that `range` specifies a match or return `nil`.
      guard let range = Range(range, in: string) else { return nil }

      self.range = range

      // Initialize the group property.
      self.group = group

      // Initialize the substring property.
      substring = string[range]
    }

    /// A brief description of the capture.
    public var description: String { "{group: \(group); substring: \"\(substring)\"}" }
  }
}

// MARK: ExpressibleByStringLiteral

extension RegularExpression: ExpressibleByStringLiteral {
  /// Initializing from a string literal.
  ///
  /// - Parameter value: The pattern for the regular expression.
  public init(stringLiteral value: String) {
    do {
      self = try RegularExpression(pattern: value, options: [])

    } catch {
      fatalError("\(#function) Failed to create regex for '\(value)': \(error)")
    }
  }
}

/// Extending `RegularExpression` for pattern matching.
public extension RegularExpression {
  static func ~=(lhs: RegularExpression, rhs: String) -> Bool {
    return lhs.numberOfMatches(in: rhs) > 0
  }

  static func ~=(lhs: String, rhs: RegularExpression) -> Bool { return rhs ~= lhs }
}

// MARK: Equatable

extension RegularExpression: Equatable {
  public static func ==(lhs: RegularExpression, rhs: RegularExpression) -> Bool {
    return lhs.pattern == rhs.pattern
  }
}

// MARK: Hashable

extension RegularExpression: Hashable {
  public func hash(into hasher: inout Hasher) {
    pattern.hash(into: &hasher)
  }

  public var hashValue: Int { return pattern.hashValue }
}

/// Operator for creating regular expressions from a string.
prefix operator ~/

public prefix func ~/(pattern: String) -> RegularExpression {
  return RegularExpression(stringLiteral: pattern)
}
