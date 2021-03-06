//
//  FractionTests.swift
//  FractionTests
//
//  Created by Jason Cardwell on 8/5/16.
//  Copyright © 2016 Jason Cardwell. All rights reserved.
//
import XCTest
import Nimble
@testable import MoonKit

private func pow10(_ exponent: Int) -> UInt128 {
  power(value: 10, exponent: exponent, identity: 1, operation: *)
}

final class FractionTests: XCTestCase {

  func testParts() {
    // 4/5 = 0.8
    expect((4÷5).integerPart) == 0
    expect((4÷5).fractionalPart) == 4÷5
    expect((4÷5).parts.nonrepeating) == [8]
    expect((4÷5).parts.repeating) == []
    // 3/4 = 0.75
    expect((3÷4).integerPart) == 0
    expect((3÷4).fractionalPart) == 3÷4
    expect((3÷4).parts.nonrepeating) == [7, 5]
    expect((3÷4).parts.repeating) == []
    // 0/64 = 0.0
    expect((0÷64).integerPart) == 0
    expect((0÷64).fractionalPart) == 0÷64
    expect((0÷64).parts.nonrepeating) == [0]
    expect((0÷64).parts.repeating) == []
    // 1/4 = 0.25
    expect((1÷4).integerPart) == 0
    expect((1÷4).fractionalPart) == 1÷4
    expect((1÷4).parts.nonrepeating) == [2, 5]
    expect((1÷4).parts.repeating) == []
    // 3/8 = 0.375
    expect((3÷8).integerPart) == 0
    expect((3÷8).fractionalPart) == 3÷8
    expect((3÷8).parts.nonrepeating) == [3, 7, 5]
    expect((3÷8).parts.repeating) == []
    // 9/11 = 0.8̅1̅
    expect((9÷11).integerPart) == 0
    expect((9÷11).fractionalPart) == 9÷11
    expect((9÷11).parts.nonrepeating) == []
    expect((9÷11).parts.repeating) == [8, 1]
    // 1/24 = 0.0416̅
    expect((1÷24).integerPart) == 0
    expect((1÷24).fractionalPart) == 1÷24
    expect((1÷24).parts.nonrepeating) == [0, 4, 1]
    expect((1÷24).parts.repeating) == [6]
    // 8/3 = 2.6̅
    expect((8÷3).integerPart) == 2
    expect((8÷3).fractionalPart) == 2÷3
    expect((8÷3).parts.nonrepeating) == []
    expect((8÷3).parts.repeating) == [6]
    // 46/11 = 4.1̅8̅
    expect((46÷11).integerPart) == 4
    expect((46÷11).fractionalPart) == 2÷11
    expect((46÷11).parts.nonrepeating) == []
    expect((46÷11).parts.repeating) == [1, 8]
    // 1002331/24 = 41763.7916̅
    expect((1002331÷24).integerPart) == 41763
    expect((1002331÷24).fractionalPart) == 19÷24
    expect((1002331÷24).parts.nonrepeating) == [7, 9, 1]
    expect((1002331÷24).parts.repeating) == [6]
    // 22/5 = 4.4
    expect((22÷5).integerPart) == 4
    expect((22÷5).fractionalPart) == 2÷5
    expect((22÷5).parts.nonrepeating) == [4]
    expect((22÷5).parts.repeating) == []
    // 98/4 = 24.5
    expect((98÷4).integerPart) == 24
    expect((98÷4).fractionalPart) == 1÷2
    expect((98÷4).parts.nonrepeating) == [5]
    expect((98÷4).parts.repeating) == []
    // 63/8 = 7.875
    expect((63÷8).integerPart) == 7
    expect((63÷8).fractionalPart) == 7÷8
    expect((63÷8).parts.nonrepeating) == [8, 7, 5]
    expect((63÷8).parts.repeating) == []
    // 17.1̅2̅ = 565/33
    expect((565÷33).integerPart) == 17
    expect((565÷33).fractionalPart) == 12÷99
    expect((565÷33).parts.nonrepeating) == []
    expect((565÷33).parts.repeating) == [1, 2]
    // 312.137̅8̅ = 206011/660
    expect((206011÷660).integerPart) == 312
    expect((206011÷660).fractionalPart) == 1365÷9900
    expect((206011÷660).parts.nonrepeating) == [1, 3]
    expect((206011÷660).parts.repeating) == [7, 8]
  }
   

  func testDecimalForm() {
    expect(Fraction.infinity.decimalForm) == Fraction.infinity
    expect((-Fraction.infinity).decimalForm) == -Fraction.infinity
    expect(Fraction.nan.decimalForm).to(beNaN())
    expect(Fraction.signalingNaN.decimalForm).to(beSignalingNaN())
    expect((3÷4).decimalForm.sign) == FloatingPointSign.plus
    expect((-3÷4).decimalForm.sign) == FloatingPointSign.minus
    expect((0÷64).decimalForm.numerator) == 0
    expect((0÷64).decimalForm.denominator) == 1
    expect((4÷5).decimalForm.numerator) == 8
    expect((4÷5).decimalForm.denominator) == 10
    expect((1÷3).decimalForm.numerator) == UInt128(low: 0xadd8b61555555555, high: 0x1913c4381e2cec28)
    expect((1÷3).decimalForm.denominator) == pow10(38)
    expect((1÷4).decimalForm.numerator) == 25
    expect((1÷4).decimalForm.denominator) == 100
    expect((3÷8).decimalForm.numerator) == 375
    expect((3÷8).decimalForm.denominator) == 1000
    expect((9÷11).decimalForm.numerator) == UInt128(low: 0xf0884a91745d1745, high: 0x3d8d9bcf8fe2a0c0)
    expect((9÷11).decimalForm.denominator) == pow10(38)
    expect((1÷24).decimalForm.numerator) == UInt128(low: 0x15bb16c2aaaaaaaa, high: 0x322788703c59d85)
    expect((1÷24).decimalForm.denominator) == pow10(38)
    expect((8÷3).decimalForm.numerator) == UInt128(low: 0x57e091aaaaaaaaaa, high: 0x140fd02ce4f0bced)
    expect((8÷3).decimalForm.denominator) == pow10(37)
    expect((46÷11).decimalForm.numerator) == UInt128(low: 0xecb77011745d1745, high: 0x1f75e38c3879855c)
    expect((46÷11).decimalForm.denominator) == pow10(37)
    expect((1002331÷24).decimalForm.numerator) == UInt128(low: 0xc1aa8dc5eaaaaaaa, high: 0x1f6b69e7fe7a5dad)
    expect((1002331÷24).decimalForm.denominator) == pow10(33)
    expect((22÷5).decimalForm.numerator) == 44
    expect((22÷5).decimalForm.denominator) == 10
    expect((98÷4).decimalForm.numerator) == 245
    expect((98÷4).decimalForm.denominator) == 10
    expect((63÷8).decimalForm.numerator) == 7875
    expect((63÷8).decimalForm.denominator) == 1000
  }

  func testExponent() {
    expect((5÷10).exponent) == -1
    expect((5÷100).exponent) == -2
    expect((5÷1000).exponent) == -3
    expect((5÷10000).exponent) == -4
    expect((5÷100000).exponent) == -5
    expect((5÷1000000).exponent) == -6
    expect((5÷10000000).exponent) == -7
    expect((5÷100000000).exponent) == -8
    expect((4÷5).exponent) == -1
    expect((3÷4).exponent) == -2
    expect((0÷64).exponent) == 0
    expect((1÷4).exponent) == -2
    expect((3÷8).exponent) == -3
    expect((9÷11).exponent) == -38
    expect((1÷24).exponent) == -38
    expect((8÷3).exponent) == -37
    expect((46÷11).exponent) == -37
    expect((1002331÷24).exponent) == -33
    expect((22÷5).exponent) == -1
    expect((98÷4).exponent) == -1
    expect((63÷8).exponent) == -3
    expect(Fraction.infinity.exponent) == Int.max
    expect((-Fraction.infinity).exponent) == Int.max
    expect(Fraction.nan.exponent) == Int.max
    expect(Fraction.signalingNaN.exponent) == Int.max
  }

  func testSignificand() {
    expect((4÷5).significand) == 8÷1
    expect((3÷4).significand) == 75÷1
    expect((0÷64).significand) == .zero
    expect((1÷4).significand) == 25÷1
    expect((3÷8).significand) == 375÷1
    expect((9÷11).significand) == UInt128(low: 0xf0884a91745d1745, high: 0x3d8d9bcf8fe2a0c0)÷1
    expect((1÷24).significand) == UInt128(low: 0x15bb16c2aaaaaaaa, high: 0x322788703c59d85)÷1
    expect((8÷3).significand) == UInt128(low: 0x57e091aaaaaaaaaa, high: 0x140fd02ce4f0bced)÷1
    expect((46÷11).significand) == UInt128(low: 0xecb77011745d1745, high: 0x1f75e38c3879855c)÷1
    expect((1002331÷24).significand) == UInt128(low: 0xc1aa8dc5eaaaaaaa, high: 0x1f6b69e7fe7a5dad)÷1
    expect((22÷5).significand) == 44÷1
    expect((98÷4).significand) == 245÷1
    expect((63÷8).significand) == 7875÷1
    expect(Fraction.infinity.significand) == .infinity
    expect((-Fraction.infinity).significand) == .infinity
    expect(Fraction.nan.significand).to(beNaN())
    expect(Fraction.signalingNaN.significand).to(beNaN())
  }

  func testAdd() {
    expect(1÷4 + 2÷4) == 3÷4
    expect(1÷8 + 2÷5) == 21÷40
    expect(Fraction.pi + -Fraction.pi) == .zero
    expect(1÷4 + Fraction.nan).to(beNaN())
    expect(-1÷4 + Fraction.nan).to(beNaN())
    expect(1÷4 + Fraction.zero) == 1÷4
    expect(1÷4 + -Fraction.zero) == 1÷4
    expect(-1÷4 + Fraction.zero) == -1÷4
    expect(-1÷4 + -Fraction.zero) == -1÷4
    expect(Fraction.zero + Fraction.nan).to(beNaN())
    expect(-Fraction.zero + Fraction.nan).to(beNaN())
    expect(Fraction.nan + Fraction.nan).to(beNaN())
    expect(Fraction.signalingNaN + Fraction.nan).to(beNaN())
    expect(1÷4 + Fraction.infinity) == .infinity
    expect(1÷4 + -Fraction.infinity) == -.infinity
    expect(Fraction.infinity + Fraction.infinity) == .infinity
    expect((-Fraction.infinity) + (-Fraction.infinity)) == -.infinity
    expect(-Fraction.infinity + Fraction.infinity).to(beNaN())
    expect(Fraction.infinity + -Fraction.infinity).to(beNaN())
  }

  func testSubtract() {
    expect(1÷4 - 2÷4) == -1÷4
    expect(1÷8 - 2÷5) == -11÷40
    expect(Fraction.pi - -Fraction.pi) == (Fraction.pi.numerator * 2)÷Fraction.pi.denominator
    expect(1÷2 - Fraction.nan).to(beNaN())
    expect(1÷4 - Fraction.nan).to(beNaN())
    expect(-1÷4 - Fraction.nan).to(beNaN())
    expect(1÷4 - Fraction.zero) == 1÷4
    expect(1÷4 - -Fraction.zero) == 1÷4
    expect(-1÷4 - Fraction.zero) == -1÷4
    expect(-1÷4 - -Fraction.zero) == -1÷4
    expect(Fraction.zero - Fraction.nan).to(beNaN())
    expect(-Fraction.zero - Fraction.nan).to(beNaN())
    expect(Fraction.nan - Fraction.nan).to(beNaN())
    expect(Fraction.signalingNaN - Fraction.nan).to(beNaN())
    expect(1÷4 - Fraction.infinity) == -Fraction.infinity
    expect(1÷4 - -Fraction.infinity) == Fraction.infinity
    expect(Fraction.infinity - -Fraction.infinity) == Fraction.infinity
    expect(-Fraction.infinity - Fraction.infinity) == -Fraction.infinity
    expect(-Fraction.infinity - -Fraction.infinity).to(beNaN())
    expect(Fraction.infinity - Fraction.infinity).to(beNaN())
  }

  func testMultiply() {
    expect(11÷22 * 1÷1) == 11÷22
    expect(5÷7 * 1÷2) == 5÷14
    expect(4÷2 * Fraction.zero) == Fraction.zero
    expect(Fraction.zero * 9÷32) == Fraction.zero
    expect(Fraction.zero * Fraction.nan).to(beNaN())
    expect(Fraction.nan * 1÷16).to(beNaN())
    expect(Fraction.zero * Fraction.infinity).to(beNaN())
    expect(Fraction.zero * -Fraction.infinity).to(beNaN())
    expect(-Fraction.zero * Fraction.infinity).to(beNaN())
    expect(-Fraction.zero * -Fraction.infinity).to(beNaN())
    expect(1÷2 * Fraction.infinity) == Fraction.infinity
    expect(1÷2 * -Fraction.infinity) == -Fraction.infinity
    expect(-1÷2 * Fraction.infinity) == -Fraction.infinity
    expect(-1÷2 * -Fraction.infinity) == Fraction.infinity
    expect(Fraction.zero * Fraction.zero) == Fraction.zero
    expect(Fraction.zero * -Fraction.zero) == -Fraction.zero
    expect(-Fraction.zero * Fraction.zero) == -Fraction.zero
    expect(-Fraction.zero * -Fraction.zero) == Fraction.zero
  }

  func testAddProduct() {
    expect((11÷22).addingProduct(1÷4, 2÷3)) == 2÷3
    expect((4÷14).addingProduct(4÷2, Fraction.zero)) == 4÷14
    expect((Fraction.zero).addingProduct(-1÷2, 4÷5)) == -2÷5
    expect((2÷3).addingProduct(Fraction.zero, 9÷32)) == 2÷3
    expect((5÷7).addingProduct(Fraction.infinity, 1÷2)) == Fraction.infinity
    expect((5÷7).addingProduct(Fraction.infinity, -1÷2)) == -Fraction.infinity
    expect((5÷7).addingProduct((-Fraction.infinity), 1÷2)) == -Fraction.infinity
    expect((-5÷7).addingProduct(Fraction.infinity, 1÷2)) == Fraction.infinity
    expect((1÷2).addingProduct(Fraction.nan, Fraction.zero)).to(beNaN())
    expect((1÷2).addingProduct(Fraction.zero, Fraction.nan)).to(beNaN())
    expect(Fraction.nan.addingProduct(2÷3, 1÷4)).to(beNaN())
    expect((1÷2).addingProduct(Fraction.zero, Fraction.infinity)).to(beNaN())
  }

  func testDivide() {
    expect(11÷22 / 1÷1) == 11÷22
    expect(5÷7 / 1÷2) == 10÷7
    expect(4÷2 / Fraction.zero) == Fraction.infinity
    expect(4÷2 / -Fraction.zero) == -Fraction.infinity
    expect(-4÷2 / Fraction.zero) == -Fraction.infinity
    expect(-4÷2 / -Fraction.zero) == Fraction.infinity
    expect(Fraction.zero / 9÷32) == Fraction.zero
    expect(Fraction.zero / -9÷32) == -Fraction.zero
    expect(-Fraction.zero / 9÷32) == -Fraction.zero
    expect(-Fraction.zero / -9÷32) == Fraction.zero
    expect(Fraction.zero / Fraction.nan).to(beNaN())
    expect(Fraction.nan / 1÷16).to(beNaN())
    expect(Fraction.zero / Fraction.infinity) == Fraction.zero
    expect(Fraction.zero / -Fraction.infinity) == -Fraction.zero
    expect(-Fraction.zero / Fraction.infinity) == -Fraction.zero
    expect(-Fraction.zero / -Fraction.infinity) == Fraction.zero
    expect(1÷2 / Fraction.infinity) == Fraction.zero
    expect(1÷2 / -Fraction.infinity) == -Fraction.zero
    expect(-1÷2 / Fraction.infinity) == -Fraction.zero
    expect(-1÷2 / -Fraction.infinity) == Fraction.zero
    expect(Fraction.zero / Fraction.zero).to(beNaN())
    expect(Fraction.zero / -Fraction.zero).to(beNaN())
    expect(-Fraction.zero / Fraction.zero).to(beNaN())
    expect(-Fraction.zero / -Fraction.zero).to(beNaN())
  }

  func testRemainder() {
    expect((3÷7).remainder(dividingBy: Fraction.infinity)) == 3÷7
    expect((3÷7).remainder(dividingBy: -Fraction.infinity)) == 3÷7
    expect((-3÷7).remainder(dividingBy: Fraction.infinity)) == -3÷7
    expect((-3÷7).remainder(dividingBy: -Fraction.infinity)) == -3÷7
    expect(Fraction.infinity.remainder(dividingBy: 1÷4)).to(beNaN())
    expect(Fraction.infinity.remainder(dividingBy: Fraction.infinity)).to(beNaN())
    expect(Fraction.infinity.remainder(dividingBy: -Fraction.infinity)).to(beNaN())
    expect((-Fraction.infinity).remainder(dividingBy: 1÷4)).to(beNaN())
    expect((-Fraction.infinity).remainder(dividingBy: Fraction.infinity)).to(beNaN())
    expect((-Fraction.infinity).remainder(dividingBy: -Fraction.infinity)).to(beNaN())
    expect(Fraction.infinity.remainder(dividingBy: Fraction.zero)).to(beNaN())
    expect(Fraction.infinity.remainder(dividingBy: -Fraction.zero)).to(beNaN())
    expect((-Fraction.infinity).remainder(dividingBy: Fraction.zero)).to(beNaN())
    expect((-Fraction.infinity).remainder(dividingBy: -Fraction.zero)).to(beNaN())
    expect(Fraction.zero.remainder(dividingBy: 1÷4)) == Fraction.zero
    expect((-Fraction.zero).remainder(dividingBy: 1÷4)) == -Fraction.zero
    expect(Fraction.zero.remainder(dividingBy: Fraction.infinity)) == Fraction.zero
    expect((-Fraction.zero).remainder(dividingBy: Fraction.infinity)) == -Fraction.zero
    expect(Fraction.zero.remainder(dividingBy: -Fraction.infinity)) == Fraction.zero
    expect((-Fraction.zero).remainder(dividingBy: -Fraction.infinity)) == -Fraction.zero
    expect(Fraction.zero.remainder(dividingBy: Fraction.zero)).to(beNaN())
    expect((-Fraction.zero).remainder(dividingBy: Fraction.zero)).to(beNaN())
    expect(Fraction.zero.remainder(dividingBy: -Fraction.zero)).to(beNaN())
    expect((-Fraction.zero).remainder(dividingBy: -Fraction.zero)).to(beNaN())
    expect((18÷5).remainder(dividingBy: 3÷5)) == Fraction.zero
    expect((911÷100).remainder(dividingBy: 1÷10)) == 1÷100
    expect((13÷4).remainder(dividingBy: 3÷2)) == 1÷4
    expect((69÷8).remainder(dividingBy: 3÷4)) == 3÷8
  }

  func testTruncatingRemainder() {
    expect((3÷7).truncatingRemainder(dividingBy: Fraction.infinity)) == 3÷7
    expect((3÷7).truncatingRemainder(dividingBy: -Fraction.infinity)) == 3÷7
    expect((-3÷7).truncatingRemainder(dividingBy: Fraction.infinity)) == -3÷7
    expect((-3÷7).truncatingRemainder(dividingBy: -Fraction.infinity)) == -3÷7
    expect(Fraction.infinity.truncatingRemainder(dividingBy: 1÷4)).to(beNaN())
    expect(Fraction.infinity.truncatingRemainder(dividingBy: Fraction.infinity)).to(beNaN())
    expect(Fraction.infinity.truncatingRemainder(dividingBy: -Fraction.infinity)).to(beNaN())
    expect((-Fraction.infinity).truncatingRemainder(dividingBy: 1÷4)).to(beNaN())
    expect((-Fraction.infinity).truncatingRemainder(dividingBy: Fraction.infinity)).to(beNaN())
    expect((-Fraction.infinity).truncatingRemainder(dividingBy: -Fraction.infinity)).to(beNaN())
    expect(Fraction.infinity.truncatingRemainder(dividingBy: Fraction.zero)).to(beNaN())
    expect(Fraction.infinity.truncatingRemainder(dividingBy: -Fraction.zero)).to(beNaN())
    expect((-Fraction.infinity).truncatingRemainder(dividingBy: Fraction.zero)).to(beNaN())
    expect((-Fraction.infinity).truncatingRemainder(dividingBy: -Fraction.zero)).to(beNaN())
    expect(Fraction.zero.truncatingRemainder(dividingBy: 1÷4)) == Fraction.zero
    expect((-Fraction.zero).truncatingRemainder(dividingBy: 1÷4)) == -Fraction.zero
    expect(Fraction.zero.truncatingRemainder(dividingBy: Fraction.infinity)) == Fraction.zero
    expect((-Fraction.zero).truncatingRemainder(dividingBy: Fraction.infinity)) == -Fraction.zero
    expect(Fraction.zero.truncatingRemainder(dividingBy: -Fraction.infinity)) == Fraction.zero
    expect((-Fraction.zero).truncatingRemainder(dividingBy: -Fraction.infinity)) == -Fraction.zero
    expect(Fraction.zero.truncatingRemainder(dividingBy: Fraction.zero)).to(beNaN())
    expect((-Fraction.zero).truncatingRemainder(dividingBy: Fraction.zero)).to(beNaN())
    expect(Fraction.zero.truncatingRemainder(dividingBy: -Fraction.zero)).to(beNaN())
    expect((-Fraction.zero).truncatingRemainder(dividingBy: -Fraction.zero)).to(beNaN())
    expect((18÷5).truncatingRemainder(dividingBy: 3÷5)) == Fraction.zero
    expect((911÷100).truncatingRemainder(dividingBy: 1÷10)) == 1÷100
    expect((13÷4).truncatingRemainder(dividingBy: 3÷2)) == 1÷4
    expect((69÷8).truncatingRemainder(dividingBy: 3÷4)) == 3÷8
  }

  func testSquareRoot() {
    expect(Fraction.infinity.squareRoot()) == Fraction.infinity
    expect((-Fraction.infinity).squareRoot()).to(beNaN())
    expect(Fraction.zero.squareRoot()) == Fraction.zero
    expect((-Fraction.zero).squareRoot()) == -Fraction.zero
    expect(Fraction.nan.squareRoot()).to(beNaN())
    expect(Fraction.signalingNaN.squareRoot()).to(beNaN())
    expect(Double((12÷10).squareRoot())).to(equalWithAccuracy(Double(1.2).squareRoot(), 0.1e-14))
//    expect(Double((-12÷10).squareRoot())).to(equalWithAccuracy(Double(-1.2).squareRoot(), 0.1e-14))
    expect(Double((12525÷100).squareRoot())).to(equalWithAccuracy(Double(125.25).squareRoot(), 0.1e-13))
    expect(Double((4÷9).squareRoot())).to(equalWithAccuracy(Double(4.0/9.0).squareRoot(), 0.1e-14))
  }

  func testRounding() {
    expect((1÷2).rounded(.awayFromZero)) == 1
    expect((1÷2).rounded(.down)) == 0
    expect((1÷2).rounded(.toNearestOrAwayFromZero)) == 1
    expect((1÷2).rounded(.toNearestOrEven)) == 0
    expect((1÷2).rounded(.towardZero)) == 0
    expect((1÷2).rounded(.up)) == 1
    expect((-1÷2).rounded(.awayFromZero)) == -1
    expect((-1÷2).rounded(.down)) == -1
    expect((-1÷2).rounded(.toNearestOrAwayFromZero)) == -1
    expect((-1÷2).rounded(.toNearestOrEven)) == -Fraction.zero
    expect((-1÷2).rounded(.towardZero)) == -Fraction.zero
    expect((-1÷2).rounded(.up)) == -Fraction.zero
    expect((3÷2).rounded(.awayFromZero)) == 2
    expect((3÷2).rounded(.down)) == 1
    expect((3÷2).rounded(.toNearestOrAwayFromZero)) == 2
    expect((3÷2).rounded(.toNearestOrEven)) == 2
    expect((3÷2).rounded(.towardZero)) == 1
    expect((3÷2).rounded(.up)) == 2
    expect((-3÷2).rounded(.awayFromZero)) == -2
    expect((-3÷2).rounded(.down)) == -2
    expect((-3÷2).rounded(.toNearestOrAwayFromZero)) == -2
    expect((-3÷2).rounded(.toNearestOrEven)) == -2
    expect((-3÷2).rounded(.towardZero)) == -1
    expect((-3÷2).rounded(.up)) == -1
    expect((1÷3).rounded(.awayFromZero)) == 1
    expect((1÷3).rounded(.down)) == 0
    expect((1÷3).rounded(.toNearestOrAwayFromZero)) == 0
    expect((1÷3).rounded(.toNearestOrEven)) == 0
    expect((1÷3).rounded(.towardZero)) == 0
    expect((1÷3).rounded(.up)) == 1
    expect((-1÷3).rounded(.awayFromZero)) == -1
    expect((-1÷3).rounded(.down)) == -1
    expect((-1÷3).rounded(.toNearestOrAwayFromZero)) == -Fraction.zero
    expect((-1÷3).rounded(.toNearestOrEven)) == -Fraction.zero
    expect((-1÷3).rounded(.towardZero)) == -Fraction.zero
    expect((-1÷3).rounded(.up)) == -Fraction.zero
    expect((4÷5).rounded(.awayFromZero)) == 1
    expect((4÷5).rounded(.down)) == 0
    expect((4÷5).rounded(.toNearestOrAwayFromZero)) == 1
    expect((4÷5).rounded(.toNearestOrEven)) == 1
    expect((4÷5).rounded(.towardZero)) == 0
    expect((4÷5).rounded(.up)) == 1
    expect((-4÷5).rounded(.awayFromZero)) == -1
    expect((-4÷5).rounded(.down)) == -1
    expect((-4÷5).rounded(.toNearestOrAwayFromZero)) == -1
    expect((-4÷5).rounded(.toNearestOrEven)) == -1
    expect((-4÷5).rounded(.towardZero)) == -Fraction.zero
    expect((-4÷5).rounded(.up)) == -Fraction.zero
    expect(Fraction.zero.rounded(.awayFromZero)) == 0
    expect(Fraction.zero.rounded(.down)) == 0
    expect(Fraction.zero.rounded(.toNearestOrAwayFromZero)) == 0
    expect(Fraction.zero.rounded(.toNearestOrEven)) == 0
    expect(Fraction.zero.rounded(.towardZero)) == 0
    expect(Fraction.zero.rounded(.up)) == 0
    expect((-Fraction.zero).rounded(.awayFromZero)) == -Fraction.zero
    expect((-Fraction.zero).rounded(.down)) == -Fraction.zero
    expect((-Fraction.zero).rounded(.toNearestOrAwayFromZero)) == -Fraction.zero
    expect((-Fraction.zero).rounded(.toNearestOrEven)) == -Fraction.zero
    expect((-Fraction.zero).rounded(.towardZero)) == -Fraction.zero
    expect((-Fraction.zero).rounded(.up)) == -Fraction.zero
    expect(Fraction.infinity.rounded(.awayFromZero)) == Fraction.infinity
    expect(Fraction.infinity.rounded(.down)) == Fraction.infinity
    expect(Fraction.infinity.rounded(.toNearestOrAwayFromZero)) == Fraction.infinity
    expect(Fraction.infinity.rounded(.toNearestOrEven)) == Fraction.infinity
    expect(Fraction.infinity.rounded(.towardZero)) == Fraction.infinity
    expect(Fraction.infinity.rounded(.up)) == Fraction.infinity
    expect((-Fraction.infinity).rounded(.awayFromZero)) == -Fraction.infinity
    expect((-Fraction.infinity).rounded(.down)) == -Fraction.infinity
    expect((-Fraction.infinity).rounded(.toNearestOrAwayFromZero)) == -Fraction.infinity
    expect((-Fraction.infinity).rounded(.toNearestOrEven)) == -Fraction.infinity
    expect((-Fraction.infinity).rounded(.towardZero)) == -Fraction.infinity
    expect((-Fraction.infinity).rounded(.up)) == -Fraction.infinity
  }

  func testFloatingPointClass() {
    expect(Fraction.nan.floatingPointClass) == FloatingPointClassification.quietNaN
    expect(Fraction.signalingNaN.floatingPointClass) == FloatingPointClassification.signalingNaN
    expect(Fraction.zero.floatingPointClass) == FloatingPointClassification.positiveZero
    expect((-Fraction.zero).floatingPointClass) == FloatingPointClassification.negativeZero
    expect(Fraction.infinity.floatingPointClass) == FloatingPointClassification.positiveInfinity
    expect((-Fraction.infinity).floatingPointClass) == FloatingPointClassification.negativeInfinity
    expect(Fraction(numerator: 1, denominator: 34, sign: .plus).floatingPointClass) == FloatingPointClassification.positiveNormal
    expect(Fraction(numerator: 1, denominator: 34, sign: .minus).floatingPointClass) == FloatingPointClassification.negativeNormal
  }

  func testInitializeWithSignExponentSignificand() {
    expect(Fraction(sign: .plus, exponent:  -1, significand: 8÷1)) == 4÷5
    expect(Fraction(sign: .plus, exponent:  -2, significand: 75÷1)) == 3÷4
    expect(Fraction(sign: .plus, exponent:   0, significand: Fraction.zero)) == 0÷64
    expect(Fraction(sign: .plus, exponent:  -2, significand: 25÷1)) == 1÷4
    expect(Fraction(sign: .plus, exponent:  -3, significand: 375÷1)) == 3÷8
    // 81818181818181818181818181818181818181
    expect(Fraction(sign: .plus, exponent: -38, significand: UInt128(low: 0xf0884a91745d1745, high: 0x3d8d9bcf8fe2a0c0)÷1)) == UInt128(low: 0xf0884a91745d1745, high: 0x3d8d9bcf8fe2a0c0)÷pow10(38)
    // 4166666666666666666666666666666666666
    expect(Fraction(sign: .plus, exponent: -38, significand: UInt128(low: 0x15bb16c2aaaaaaaa, high: 0x322788703c59d85)÷1)) == UInt128(low: 0x15bb16c2aaaaaaaa, high: 0x322788703c59d85)÷pow10(38)
    // 26666666666666666666666666666666666666
    expect(Fraction(sign: .plus, exponent: -37, significand: UInt128(low: 0x57e091aaaaaaaaaa, high: 0x140fd02ce4f0bced)÷1)) == UInt128(low: 0x57e091aaaaaaaaaa, high: 0x140fd02ce4f0bced)÷pow10(37)
    // 41818181818181818181818181818181818181
    expect(Fraction(sign: .plus, exponent: -37, significand: UInt128(low: 0xecb77011745d1745, high: 0x1f75e38c3879855c)÷1)) == UInt128(low: 0xecb77011745d1745, high: 0x1f75e38c3879855c)÷pow10(37)
    // 41763791666666666666666666666666666666
    expect(Fraction(sign: .plus, exponent: -33, significand: UInt128(low: 0xc1aa8dc5eaaaaaaa, high: 0x1f6b69e7fe7a5dad)÷1)) == UInt128(low: 0xc1aa8dc5eaaaaaaa, high: 0x1f6b69e7fe7a5dad)÷pow10(33)
    expect(Fraction(sign: .plus, exponent:  -1, significand: 44÷1)) == 22÷5
    expect(Fraction(sign: .plus, exponent:  -1, significand: 245÷1)) == 98÷4
    expect(Fraction(sign: .plus, exponent:  -3, significand: 7875÷1)) == 63÷8
    expect(Fraction(sign: .minus, exponent:  -1, significand: 8÷1)) == -(4÷5)
    expect(Fraction(sign: .minus, exponent:  -2, significand: 75÷1)) == -(3÷4)
    expect(Fraction(sign: .minus, exponent:   0, significand: Fraction.zero)) == -(0÷64)
    expect(Fraction(sign: .minus, exponent:  -2, significand: 25÷1)) == -(1÷4)
    expect(Fraction(sign: .minus, exponent:  -3, significand: 375÷1)) == -(3÷8)
    // 81818181818181818181818181818181818181
    expect(Fraction(sign: .minus, exponent: -38, significand: UInt128(low: 0xf0884a91745d1745, high: 0x3d8d9bcf8fe2a0c0)÷1)) == -(UInt128(low: 0xf0884a91745d1745, high: 0x3d8d9bcf8fe2a0c0)÷pow10(38))
    // 4166666666666666666666666666666666666
    expect(Fraction(sign: .minus, exponent: -38, significand: UInt128(low: 0x15bb16c2aaaaaaaa, high: 0x322788703c59d85)÷1)) == -(UInt128(low: 0x15bb16c2aaaaaaaa, high: 0x322788703c59d85)÷pow10(38))
    // 26666666666666666666666666666666666666
    expect(Fraction(sign: .minus, exponent: -37, significand: UInt128(low: 0x57e091aaaaaaaaaa, high: 0x140fd02ce4f0bced)÷1)) == -(UInt128(low: 0x57e091aaaaaaaaaa, high: 0x140fd02ce4f0bced)÷pow10(37))
    // 41818181818181818181818181818181818181
    expect(Fraction(sign: .minus, exponent: -37, significand: UInt128(low: 0xecb77011745d1745, high: 0x1f75e38c3879855c)÷1)) == -(UInt128(low: 0xecb77011745d1745, high: 0x1f75e38c3879855c)÷pow10(37))
    // 41763791666666666666666666666666666666
    expect(Fraction(sign: .minus, exponent: -33, significand: UInt128(low: 0xc1aa8dc5eaaaaaaa, high: 0x1f6b69e7fe7a5dad)÷1)) == -(UInt128(low: 0xc1aa8dc5eaaaaaaa, high: 0x1f6b69e7fe7a5dad)÷pow10(33))
    expect(Fraction(sign: .minus, exponent:  -1, significand: 44÷1)) == -(22÷5)
    expect(Fraction(sign: .minus, exponent:  -1, significand: 245÷1)) == -(98÷4)
    expect(Fraction(sign: .minus, exponent:  -3, significand: 7875÷1)) == -(63÷8)
    expect(Fraction(sign: .plus, exponent: 1, significand: Fraction.infinity)) == Fraction.infinity
    expect(Fraction(sign: .minus, exponent: 1, significand: Fraction.infinity)) == -Fraction.infinity
    expect(Fraction(sign: .plus, exponent: 1, significand: Fraction.nan)).to(beNaN())
    expect(Fraction(sign: .minus, exponent: 1, significand: Fraction.nan)).to(beNaN())
  }

  func testInitializeWithSignMagnitude() {
    expect(Fraction(signOf: 1÷1, magnitudeOf: 1÷3)) == 1÷3
    expect(Fraction(signOf: -1÷1, magnitudeOf: 1÷3)) == -1÷3
    expect(Fraction(signOf: 1÷1, magnitudeOf: -1÷3)) == 1÷3
    expect(Fraction(signOf: -1÷1, magnitudeOf: -1÷3)) == -1÷3
    expect(Fraction(signOf: 1÷1, magnitudeOf: .infinity)) == .infinity
    expect(Fraction(signOf: -1÷1, magnitudeOf: .infinity)) == -.infinity
    expect(Fraction(signOf: 1÷1, magnitudeOf: -.infinity)) == .infinity
    expect(Fraction(signOf: -1÷1, magnitudeOf: -.infinity)) == -.infinity
    expect(Fraction(signOf: 1÷1, magnitudeOf: .zero)) == .zero
    expect(Fraction(signOf: -1÷1, magnitudeOf: .zero)) == -.zero
    expect(Fraction(signOf: 1÷1, magnitudeOf: -.zero)) == .zero
    expect(Fraction(signOf: -1÷1, magnitudeOf: -.zero)) == -.zero
    expect(Fraction(signOf: 1÷1, magnitudeOf: .nan)).to(beNaN())
    expect(Fraction(signOf: -1÷1, magnitudeOf: .nan)).to(beNaN())
    expect(Fraction(signOf: 1÷1, magnitudeOf: .signalingNaN)).to(beNaN())
    expect(Fraction(signOf: -1÷1, magnitudeOf: .signalingNaN)).to(beNaN())
  }

  func testReduce() {
    // Test edge cases.
    expect(Fraction.zero.reduced()) == .zero
    expect((-Fraction.zero).reduced()) == -.zero
    expect(Fraction.infinity.reduced()) == .infinity
    expect((-Fraction.infinity).reduced()) == -.infinity
    expect(Fraction.nan.reduced()).to(beNaN())
    expect(Fraction.signalingNaN.reduced()).to(beSignalingNaN())

    // Test some clear reductions.
    expect((42824÷99900).reduced()) == 10706÷24975
    expect((-2÷8).reduced()) == -1÷4

    // Test some nontrivial reductions.

    // 4166666666666666666666666666666666666
    let numerator = UInt128(low: 0x15bb16c2aaaaaaaa, high: 0x322788703c59d85)
    expect((1÷24).decimalForm.numerator) == numerator

    // 100000000000000000000000000000000000000
    let denominator = UInt128(low: 0x98a224000000000, high: 0x4b3b4ca85a86c47a)
    expect((1÷24).decimalForm.denominator) == denominator

    expect((numerator÷denominator)) == (1÷24).decimalForm

    expect((numerator÷denominator).reduced()) == (1÷24).decimalForm.reduced()

    expect((numerator÷denominator).reduced()) == 1÷24


  }

  func testDecimalFormRoundTrip() {
    /*

        1        4166666666666666666666666666666666666
     ────── =   ─────────────────────────────────────── = 0.416̅
       24       100000000000000000000000000000000000000

     */

    // Create a variety of fractions to test.
    let fractions = [4÷5, 3÷4, 0÷64, 1÷4, 3÷8, 9÷11, 1÷24,
                     8÷3, 46÷11, 1002331÷24, 22÷5, 98÷4, 63÷8]

    // Iterate `fractions` testing whether each fraction may be recreated
    // by reducing its decimal form.
    for fraction in fractions {
      expect(fraction.decimalForm.reduced()) == fraction
    }

  }

  func testEqualities() {
    // Create fractions to test comparisons.
    let a = -Fraction.nan // -nan
    let b = -Fraction.signalingNaN // -snan
    let c = -Fraction.infinity // -inf
    let d = -2÷3 // -⅔
    let e = -1÷3 // -⅓
    let f = -Fraction.zero // -0
    let g = Fraction.zero // 0
    let h = 1÷3 // ⅓
    let i = 2÷3 // ⅔
    let j = Fraction.infinity // inf
    let k = Fraction.signalingNaN // snan
    let l = Fraction.nan // nan

    // Create an array with the fractions to order.
    let fractions = [a, b, c, d, e, f, g, h, i, j, k, l]

    for (i, x) in fractions.enumerated() {
      for y in fractions[i+1..<fractions.endIndex] {
        expect(x.isLessThanOrEqualTo(y)) == Bool(!(x.isNaN || y.isNaN))
      }
    }
  }

  func testTotalOrder() {
    // Create fractions to test total ordering
    let a = -Fraction.nan // -nan
    let b = -Fraction.signalingNaN // -snan
    let c = -Fraction.infinity // -inf
    let d = -2÷3 // -⅔
    let e = -1÷3 // -⅓
    let f = -Fraction.zero // -0
    let g = Fraction.zero // 0
    let h = 1÷3 // ⅓
    let i = 2÷3 // ⅔
    let j = Fraction.infinity // inf
    let k = Fraction.signalingNaN // snan
    let l = Fraction.nan // nan

    // Create an array with the fractions to order.
    let fractions = [a, b, c, d, e, f, g, h, i, j, k, l]

    // Test whether each fraction in `fractions` is ordered below or equal to the next.
    for (i, x) in fractions.enumerated() {
      for y in fractions[i+1..<fractions.endIndex] {
        expect(x.isTotallyOrdered(belowOrEqualTo: y)) == true
      }
    }
  }

  func testReciprocal() {
    expect((1÷3).reciprocal) == 3÷1
    expect((-1÷3).reciprocal) == -3÷1
    expect(Fraction.pi.reciprocal) == Fraction.pi.denominator÷Fraction.pi.numerator
    expect(Fraction.infinity.reciprocal) == .zero
    expect((-Fraction.infinity).reciprocal) == -.zero
    expect(Fraction.zero.reciprocal) == .infinity
    expect((-Fraction.zero).reciprocal) == -.infinity
  }

  func testInitializeWithDouble() {
    expect(Fraction(Double.nan)).to(beNaN())
    expect(Fraction(Double.nan)).toNot(beSignalingNaN())
    expect(Fraction(Double.nan).numerator) == 0
    expect(Fraction(Double.nan).denominator) == 1
    expect(Fraction(Double.signalingNaN)).to(beNaN())
    expect(Fraction(Double.signalingNaN)).to(beSignalingNaN())
    expect(Fraction(Double.infinity)) == .infinity
    expect(Fraction(-Double.infinity)) == -.infinity
    expect(Fraction(Double.pi)).to(equalWithAccuracy(.pi, 1÷1e15))
    expect(Fraction(-Double.pi)).to(equalWithAccuracy(-.pi, (1÷1e15)))
  }

  func testConversionToDouble() {
    expect(Double(1÷2)) == 0.5
    expect(Double(1÷3)) == 0.33333333333333333334
    expect(Double(2÷3)) == 0.66666666666666666667
    expect(Double(1÷4)) == 0.25
    expect(Double(2÷4)) == 0.5
    expect(Double(3÷4)) == 0.75
    expect(Double(1÷5)) == 0.2
    expect(Double(2÷5)) == 0.4
    expect(Double(3÷5)) == 0.6
    expect(Double(4÷5)) == 0.8
    expect(Double(1÷6)) == 0.16666666666666666667
    expect(Double(2÷6)) == 0.33333333333333333334
    expect(Double(3÷6)) == 0.5
    expect(Double(4÷6)) == 0.66666666666666666667
    expect(Double(5÷6)) == 0.83333333333333333334
    expect(Double(1÷7)) == 0.14285714285714285714
    expect(Double(2÷7)) == 0.28571428571428571428
    expect(Double(3÷7)) == 0.42857142857142857144
    expect(Double(4÷7)) == 0.57142857142857142857
    expect(Double(5÷7)) == 0.71428571428571428571
    expect(Double(6÷7)) == 0.85714285714285714285
    expect(Double(1÷8)) == 0.125
    expect(Double(2÷8)) == 0.25
    expect(Double(3÷8)) == 0.375
    expect(Double(4÷8)) == 0.5
    expect(Double(5÷8)) == 0.625
    expect(Double(6÷8)) == 0.75
    expect(Double(7÷8)) == 0.875
    expect(Double(1÷9)) == 0.11111111111111111111
    expect(Double(2÷9)) == 0.22222222222222222222
    expect(Double(3÷9)) == 0.33333333333333333333
    expect(Double(4÷9)) == 0.44444444444444444444
    expect(Double(5÷9)) == 0.55555555555555555556
    expect(Double(6÷9)) == 0.66666666666666666667
    expect(Double(7÷9)) == 0.77777777777777777778
    expect(Double(8÷9)) == 0.88888888888888888889
    expect(Double(1÷10)) == 0.1
    expect(Double(2÷10)) == 0.2
    expect(Double(3÷10)) == 0.3
    expect(Double(4÷10)) == 0.4
    expect(Double(5÷10)) == 0.5
    expect(Double(6÷10)) == 0.6
    expect(Double(7÷10)) == 0.7
    expect(Double(8÷10)) == 0.8
    expect(Double(9÷10)) == 0.9
  }

  func testDoubleRoundTrip() {
    expect(Fraction(Double(1÷2))) == 1÷2
    expect(Fraction(Double(1÷3))) == 1÷3
    expect(Fraction(Double(2÷3))) == 2÷3
    expect(Fraction(Double(1÷4))) == 1÷4
    expect(Fraction(Double(2÷4))) == 2÷4
    expect(Fraction(Double(3÷4))) == 3÷4
    expect(Fraction(Double(1÷5))) == 1÷5
    expect(Fraction(Double(2÷5))) == 2÷5
    expect(Fraction(Double(3÷5))) == 3÷5
    expect(Fraction(Double(4÷5))) == 4÷5
    expect(Fraction(Double(1÷6))) == 1÷6
    expect(Fraction(Double(2÷6))) == 2÷6
    expect(Fraction(Double(3÷6))) == 3÷6
    expect(Fraction(Double(4÷6))) == 4÷6
    expect(Fraction(Double(5÷6))) == 5÷6
    expect(Fraction(Double(1÷7))) == 1÷7
    expect(Fraction(Double(2÷7))) == 2÷7
    expect(Fraction(Double(3÷7))) == 3÷7
    expect(Fraction(Double(4÷7))) == 4÷7
    expect(Fraction(Double(5÷7))) == 5÷7
    expect(Fraction(Double(6÷7))) == 6÷7
    expect(Fraction(Double(1÷8))) == 1÷8
    expect(Fraction(Double(2÷8))) == 2÷8
    expect(Fraction(Double(3÷8))) == 3÷8
    expect(Fraction(Double(4÷8))) == 4÷8
    expect(Fraction(Double(5÷8))) == 5÷8
    expect(Fraction(Double(6÷8))) == 6÷8
    expect(Fraction(Double(7÷8))) == 7÷8
    expect(Fraction(Double(1÷9))) == 1÷9
    expect(Fraction(Double(2÷9))) == 2÷9
    expect(Fraction(Double(3÷9))) == 3÷9
    expect(Fraction(Double(4÷9))) == 4÷9
    expect(Fraction(Double(5÷9))) == 5÷9
    expect(Fraction(Double(6÷9))) == 6÷9
    expect(Fraction(Double(7÷9))) == 7÷9
    expect(Fraction(Double(8÷9))) == 8÷9
    expect(Fraction(Double(1÷10))) == 1÷10
    expect(Fraction(Double(2÷10))) == 2÷10
    expect(Fraction(Double(3÷10))) == 3÷10
    expect(Fraction(Double(4÷10))) == 4÷10
    expect(Fraction(Double(5÷10))) == 5÷10
    expect(Fraction(Double(6÷10))) == 6÷10
    expect(Fraction(Double(7÷10))) == 7÷10
    expect(Fraction(Double(8÷10))) == 8÷10
    expect(Fraction(Double(9÷10))) == 9÷10
  }

}
