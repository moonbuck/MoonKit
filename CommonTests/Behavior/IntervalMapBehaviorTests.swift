//
//  IntervalMapTests.swift
//  IntervalMapTests
//
//  Created by Jason Cardwell on 12/4/16.
//  Copyright © 2016 Jason Cardwell. All rights reserved.
//

import XCTest
import MoonKitTest
import MoonKit

final class IntervalMapBehaviorTests: XCTestCase {

  func testCreation() {

    let map1 = IntervalMap<Double>()
    expect(map1).to(haveCount(0))
    expect(map1).to(beEmpty())

    let map2 = IntervalMap<Double>(4.3)
    expect(map2).to(haveCount(1))
    expect(map2).toNot(beEmpty())

    let map3 = IntervalMap<Double>(〖6.4..9.3】)
    expect(map3).to(haveCount(1))
    expect(map3).toNot(beEmpty())

    let map4 = IntervalMap<Double>([
      〖4.9..8.2】,
      【9.1..24.6】,
      【26.3..39.2〗,
      〖44.3..56.2〗
      ])
    expect(map4).to(haveCount(4))
    expect(map4).toNot(beEmpty())

    let map5: IntervalMap<Double> = [
      〖4.9..8.2】,
      【9.1..24.6】,
      【26.3..39.2〗,
      〖44.3..56.2〗
    ]
    expect(map5).to(haveCount(4))
    expect(map5).toNot(beEmpty())

  }

  func testMinAndMax() {

    let map1 = IntervalMap<Double>([
      〖4.9..8.2】,
      【9.1..24.6】,
      【26.3..39.2〗,
      〖44.3..56.2〗
      ])
    expect(map1.min()) == 〖4.9..8.2】
    expect(map1.max()) == 〖44.3..56.2〗

    let map2 = IntervalMap<Double>()
    expect(map2.min()).to(beNil())
    expect(map2.max()).to(beNil())

  }

  func testCoverage() {

    let map1 = IntervalMap<Double>([
      〖4.9..8.2】,
      【9.1..24.6】,
      【26.3..39.2〗,
      〖44.3..56.2〗
      ])
    expect(map1.coverage) == 〖4.9..56.2〗

    let map2 = IntervalMap<Double>()
    expect(map2.coverage).to(beNil())

  }

  func testContainsElement() {

    let map = IntervalMap<Double>([
      〖4.9..8.2】,
      【9.1..24.6】,
      【26.3..39.2〗,
      〖44.3..56.2〗
      ])

    expect(map.contains(4.9)) == false
    expect(map.contains(5.0)) == true
    expect(map.contains(8.2)) == true
    expect(map.contains(8.4)) == false
    expect(map.contains(9.1)) == true
    expect(map.contains(9.9)) == true
    expect(map.contains(24.6)) == true
    expect(map.contains(25.3)) == false
    expect(map.contains(26.3)) == true
    expect(map.contains(30.0)) == true
    expect(map.contains(43.1)) == false
    expect(map.contains(44.3)) == false
    expect(map.contains(56.0)) == true
    expect(map.contains(56.2)) == false
    expect(map.contains(64.1)) == false

  }

  func testContainsInterval() {

    let map = IntervalMap<Double>([
      〖4.9..8.2】,
      【9.1..24.6】,
      【26.3..39.2〗,
      〖44.3..56.2〗
      ])

    expect(map.contains(【4.9..5.0】)) == false
    expect(map.contains(〖4.9..5.0】)) == true
    expect(map.contains(【8.2..8.2】)) == true
    expect(map.contains(〖8.4..18.4〗)) == false
    expect(map.contains(〖9.1..18.4】)) == true
    expect(map.contains(【9.9..24.6〗)) == true
    expect(map.contains(【24.6..27.6〗)) == false
    expect(map.contains(〖25.3..27.3】)) == false
    expect(map.contains(【26.3..29.5】)) == true
    expect(map.contains(【30.0..39.2〗)) == true
    expect(map.contains(〖43.1..45.2】)) == false
    expect(map.contains(【44.3..50.2】)) == false
    expect(map.contains(【56.0..56.2】)) == false
    expect(map.contains(【50.2..56.2〗)) == true
    expect(map.contains(〖64.1..32.2】)) == false

  }

  func testIndexFor() {

    let map = IntervalMap<Double>([
      〖4.9..8.2】,
      【9.1..24.6】,
      【26.3..39.2〗,
      〖44.3..56.2〗
      ])

    expect(map.index(of: 2.9)).to(beNil())
    expect(map.index(of: 4.9)).to(beNil())
    expect(map.index(of: 5.3)) == 0
    expect(map.index(of: 8.2)) == 0
    expect(map.index(of: 9.0)).to(beNil())
    expect(map.index(of: 9.1)) == 1
    expect(map.index(of: 22.1)) == 1
    expect(map.index(of: 24.6)) == 1
    expect(map.index(of: 25.3)).to(beNil())
    expect(map.index(of: 26.3)) == 2
    expect(map.index(of: 33.3)) == 2
    expect(map.index(of: 39.2)).to(beNil())
    expect(map.index(of: 44.3)).to(beNil())
    expect(map.index(of: 55.3)) == 3
    expect(map.index(of: 56.2)).to(beNil())
    expect(map.index(of: 66.2)).to(beNil())

    expect(map.index(of: 〖4.9..8.2】)) == 0
    expect(map.index(of: 【9.1..24.6】)) == 1
    expect(map.index(of: 【26.3..39.2〗)) == 2
    expect(map.index(of: 〖44.3..56.2〗)) == 3
    expect(map.index(of: 【4.9..8.2】)).to(beNil())
    expect(map.index(of: 【9.1..24.6〗)) == 1
    expect(map.index(of: 【28.3..33.2〗)) == 2
    expect(map.index(of: 〖44.3..56.2】)).to(beNil())

  }

  func testInsert() {

    var map: IntervalMap<Double> = []

    expect(map).to(beEmpty())

    map.insert(43.6)
    expect(map) == [【43.6..43.6】]

    map = []
    expect(map).to(beEmpty())

    map.insert(【43.6..43.6】)
    expect(map) == [【43.6..43.6】]

    map.insert(〖22.1..39.0】)
    expect(map) == [〖22.1..39.0】, 【43.6..43.6】]

    map.insert(【11.4..16.2〗)
    expect(map) == [【11.4..16.2〗, 〖22.1..39.0】, 【43.6..43.6】]

    map.insert(15.9)
    expect(map) == [【11.4..16.2〗, 〖22.1..39.0】, 【43.6..43.6】]

    map.insert(〖24.2..30.5】)
    expect(map) == [【11.4..16.2〗, 〖22.1..39.0】, 【43.6..43.6】]

    map.insert(【44.6..44.6〗)
    expect(map) == [【11.4..16.2〗, 〖22.1..39.0】, 【43.6..43.6】]

    map.insert(〖4.6..5.9〗)
    expect(map) == [〖4.6..5.9〗, 【11.4..16.2〗, 〖22.1..39.0】, 【43.6..43.6】]

    map.insert(〖7.1..9.9〗)
    expect(map) == [〖4.6..5.9〗, 〖7.1..9.9〗, 【11.4..16.2〗, 〖22.1..39.0】, 【43.6..43.6】]

    map.insert(【5.9..8.0〗)
    expect(map) == [〖4.6..9.9〗, 【11.4..16.2〗, 〖22.1..39.0】, 【43.6..43.6】]

    map.insert(【16.2..22.1】)
    expect(map) == [〖4.6..9.9〗, 【11.4..39.0】, 【43.6..43.6】]

    map.insert(〖41.0..43.7〗)
    expect(map) == [〖4.6..9.9〗, 【11.4..39.0】, 〖41.0..43.7〗]

    map.insert(〖5.0..10.1〗)
    expect(map) == [〖4.6..10.1〗, 【11.4..39.0】, 〖41.0..43.7〗]

    map.insert(【9.8..10.1】)
    expect(map) == [〖4.6..10.1】, 【11.4..39.0】, 〖41.0..43.7〗]

    map.insert(〖54.6..58.9〗)
    expect(map) == [〖4.6..10.1】, 【11.4..39.0】, 〖41.0..43.7〗, 〖54.6..58.9〗]

    map.insert(〖64.4..72.1〗)
    expect(map) == [〖4.6..10.1】, 【11.4..39.0】, 〖41.0..43.7〗, 〖54.6..58.9〗, 〖64.4..72.1〗]

    map.insert(【58.9..62.2〗)
    expect(map) == [〖4.6..10.1】, 【11.4..39.0】, 〖41.0..43.7〗, 〖54.6..62.2〗, 〖64.4..72.1〗]

    map.insert(【43.7..54.6】)
    expect(map) == [〖4.6..10.1】, 【11.4..39.0】, 〖41.0..62.2〗, 〖64.4..72.1〗]
    
    map.insert(〖40.0..63.2〗)
    expect(map) == [〖4.6..10.1】, 【11.4..39.0】, 〖40.0..63.2〗, 〖64.4..72.1〗]

    map.insert(〖85.8..99.0〗)
    expect(map) == [〖4.6..10.1】, 【11.4..39.0】, 〖40.0..63.2〗, 〖64.4..72.1〗, 〖85.8..99.0〗]

    map.insert(【74.1..76.7〗)
    expect(map) == [〖4.6..10.1】, 【11.4..39.0】, 〖40.0..63.2〗, 〖64.4..72.1〗, 【74.1..76.7〗, 〖85.8..99.0〗]

    map.insert(【63.2..64.4】)
    expect(map) == [〖4.6..10.1】, 【11.4..39.0】, 〖40.0..72.1〗, 【74.1..76.7〗, 〖85.8..99.0〗]

    map.insert(【72.1..75.5】)
    expect(map) == [〖4.6..10.1】, 【11.4..39.0】, 〖40.0..76.7〗, 〖85.8..99.0〗]

    map.insert(〖39.5..76.0】)
    expect(map) == [〖4.6..10.1】, 【11.4..39.0】, 〖39.5..76.7〗, 〖85.8..99.0〗]

    map.insert(〖39.0..39.2】)
    expect(map) == [〖4.6..10.1】, 【11.4..39.2】, 〖39.5..76.7〗, 〖85.8..99.0〗]

    map.insert(〖39.0..39.5】)
    expect(map) == [〖4.6..10.1】, 【11.4..76.7〗, 〖85.8..99.0〗]

    map.insert(〖11.2..78.9〗)
    expect(map) == [〖4.6..10.1】, 〖11.2..78.9〗, 〖85.8..99.0〗]

    map.insert(〖10.4..11.2】)
    expect(map) == [〖4.6..10.1】, 〖10.4..78.9〗, 〖85.8..99.0〗]

    map.insert(〖10.2..10.4】)
    expect(map) == [〖4.6..10.1】, 〖10.2..78.9〗, 〖85.8..99.0〗]

    map.insert(〖10.1..10.2】)
    expect(map) == [〖4.6..78.9〗, 〖85.8..99.0〗]

    map.insert(〖104.2..111.5〗)
    expect(map) == [〖4.6..78.9〗, 〖85.8..99.0〗, 〖104.2..111.5〗]

    map.insert(〖121.6..144.5〗)
    expect(map) == [〖4.6..78.9〗, 〖85.8..99.0〗, 〖104.2..111.5〗, 〖121.6..144.5〗]

    map.insert(〖116.3..118.2〗)
    expect(map) == [〖4.6..78.9〗, 〖85.8..99.0〗, 〖104.2..111.5〗, 〖116.3..118.2〗, 〖121.6..144.5〗]

    map.insert(〖149.2..150.0〗)
    expect(map) == [〖4.6..78.9〗, 〖85.8..99.0〗, 〖104.2..111.5〗, 〖116.3..118.2〗, 〖121.6..144.5〗, 〖149.2..150.0〗]

    map.insert(〖169.1..173.8〗)
    expect(map) == [〖4.6..78.9〗, 〖85.8..99.0〗, 〖104.2..111.5〗, 〖116.3..118.2〗, 〖121.6..144.5〗, 〖149.2..150.0〗, 〖169.1..173.8〗]

    map.insert(【110.3..116.3】)
    expect(map) == [〖4.6..78.9〗, 〖85.8..99.0〗, 〖104.2..118.2〗, 〖121.6..144.5〗, 〖149.2..150.0〗, 〖169.1..173.8〗]

    map.insert(【140.0..149.0】)
    expect(map) == [〖4.6..78.9〗, 〖85.8..99.0〗, 〖104.2..118.2〗, 〖121.6..149.0】, 〖149.2..150.0〗, 〖169.1..173.8〗]

    map.insert(【140.0..149.2】)
    expect(map) == [〖4.6..78.9〗, 〖85.8..99.0〗, 〖104.2..118.2〗, 〖121.6..150.0〗, 〖169.1..173.8〗]

    map.insert(【101.4..106.4】)
    expect(map) == [〖4.6..78.9〗, 〖85.8..99.0〗, 【101.4..118.2〗, 〖121.6..150.0〗, 〖169.1..173.8〗]

    map.insert(【120.0..122.0】)
    expect(map) == [〖4.6..78.9〗, 〖85.8..99.0〗, 【101.4..118.2〗, 【120.0..150.0〗, 〖169.1..173.8〗]

    map.insert(〖100.0..120.0〗)
    expect(map) == [〖4.6..78.9〗, 〖85.8..99.0〗, 〖100.0..150.0〗, 〖169.1..173.8〗]

    map.insert(【99.0..152.2】)
    expect(map) == [〖4.6..78.9〗, 〖85.8..152.2】, 〖169.1..173.8〗]

    map.insert(【78.9..169.1】)
    expect(map) == [〖4.6..173.8〗]

    map.insert(【202.4..223.9〗)
    expect(map) == [〖4.6..173.8〗, 【202.4..223.9〗]

    map.insert(〖232.4..243.1】)
    expect(map) == [〖4.6..173.8〗, 【202.4..223.9〗, 〖232.4..243.1】]

    map.insert(〖251.9..266.1〗)
    expect(map) == [〖4.6..173.8〗, 【202.4..223.9〗, 〖232.4..243.1】, 〖251.9..266.1〗]

    map.insert(〖243.1..245.1〗)
    expect(map) == [〖4.6..173.8〗, 【202.4..223.9〗, 〖232.4..245.1〗, 〖251.9..266.1〗]

    map.insert(〖250.2..251.9】)
    expect(map) == [〖4.6..173.8〗, 【202.4..223.9〗, 〖232.4..245.1〗, 〖250.2..266.1〗]

    map.insert(【245.1..270.0】)
    expect(map) == [〖4.6..173.8〗, 【202.4..223.9〗, 〖232.4..270.0】]

    map.insert(【3.1..202.4〗)
    expect(map) == [【3.1..223.9〗, 〖232.4..270.0】]

    map.insert(【280.4..300.1】)
    expect(map) == [【3.1..223.9〗, 〖232.4..270.0】, 【280.4..300.1】]

    map.insert(〖360.5..404.5〗)
    expect(map) == [【3.1..223.9〗, 〖232.4..270.0】, 【280.4..300.1】, 〖360.5..404.5〗]

    map.insert(【421.1..453.2〗)
    expect(map) == [【3.1..223.9〗, 〖232.4..270.0】, 【280.4..300.1】, 〖360.5..404.5〗, 【421.1..453.2〗]

    map.insert(〖300.1..421.1〗)
    expect(map) == [【3.1..223.9〗, 〖232.4..270.0】, 【280.4..453.2〗]

  }

  func testRemove() {

    var map: IntervalMap<Double> = [
      〖0.3..0.7〗, 【1.6..2.4】, 【5.9..6.6〗, 〖7.6..12.5〗, 〖15.2..15.9】, 〖16.4..18.0】, 〖20.5..21.2】, 【22.2..22.9】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..44.7〗,
      〖45.8..45.9〗, 【46.2..48.5〗, 〖49.8..51.7】, 〖52.1..53.2〗, 【53.3..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 【69.1..71.0】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 【5.9..6.6〗, 〖7.6..12.5〗, 〖15.2..15.9】, 〖16.4..18.0】, 〖20.5..21.2】, 【22.2..22.9】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..44.7〗,
      〖45.8..45.9〗, 【46.2..48.5〗, 〖49.8..51.7】, 〖52.1..53.2〗, 【53.3..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 【69.1..71.0】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(3.2)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 【5.9..6.6〗, 〖7.6..12.5〗, 〖15.2..15.9】, 〖16.4..18.0】, 〖20.5..21.2】, 【22.2..22.9】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..44.7〗,
      〖45.8..45.9〗, 【46.2..48.5〗, 〖49.8..51.7】, 〖52.1..53.2〗, 【53.3..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 【69.1..71.0】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(【1.0..1.6〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 【5.9..6.6〗, 〖7.6..12.5〗, 〖15.2..15.9】, 〖16.4..18.0】, 〖20.5..21.2】, 【22.2..22.9】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..44.7〗,
      〖45.8..45.9〗, 【46.2..48.5〗, 〖49.8..51.7】, 〖52.1..53.2〗, 【53.3..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 【69.1..71.0】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(【69.1..71.0】)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 【5.9..6.6〗, 〖7.6..12.5〗, 〖15.2..15.9】, 〖16.4..18.0】, 〖20.5..21.2】, 【22.2..22.9】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..44.7〗,
      〖45.8..45.9〗, 【46.2..48.5〗, 〖49.8..51.7】, 〖52.1..53.2〗, 【53.3..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(5.9)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖5.9..6.6〗, 〖7.6..12.5〗, 〖15.2..15.9】, 〖16.4..18.0】, 〖20.5..21.2】, 【22.2..22.9】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..44.7〗,
      〖45.8..45.9〗, 【46.2..48.5〗, 〖49.8..51.7】, 〖52.1..53.2〗, 【53.3..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(6.6)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖5.9..6.6〗, 〖7.6..12.5〗, 〖15.2..15.9】, 〖16.4..18.0】, 〖20.5..21.2】, 【22.2..22.9】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..44.7〗,
      〖45.8..45.9〗, 【46.2..48.5〗, 〖49.8..51.7】, 〖52.1..53.2〗, 【53.3..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(7.6)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖5.9..6.6〗, 〖7.6..12.5〗, 〖15.2..15.9】, 〖16.4..18.0】, 〖20.5..21.2】, 【22.2..22.9】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..44.7〗,
      〖45.8..45.9〗, 【46.2..48.5〗, 〖49.8..51.7】, 〖52.1..53.2〗, 【53.3..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(〖47.2..48.2〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖5.9..6.6〗, 〖7.6..12.5〗, 〖15.2..15.9】, 〖16.4..18.0】, 〖20.5..21.2】, 【22.2..22.9】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..44.7〗,
      〖45.8..45.9〗, 【46.2..47.2】, 【48.2..48.5〗, 〖49.8..51.7】, 〖52.1..53.2〗, 【53.3..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(【43.0..44.0】)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖5.9..6.6〗, 〖7.6..12.5〗, 〖15.2..15.9】, 〖16.4..18.0】, 〖20.5..21.2】, 【22.2..22.9】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..43.0〗, 〖44.0..44.7〗,
      〖45.8..45.9〗, 【46.2..47.2】, 【48.2..48.5〗, 〖49.8..51.7】, 〖52.1..53.2〗, 【53.3..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(〖4.9..7.2〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..12.5〗, 〖15.2..15.9】, 〖16.4..18.0】, 〖20.5..21.2】, 【22.2..22.9】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..43.0〗, 〖44.0..44.7〗,
      〖45.8..45.9〗, 【46.2..47.2】, 【48.2..48.5〗, 〖49.8..51.7】, 〖52.1..53.2〗, 【53.3..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(〖50.9..56.2〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..12.5〗, 〖15.2..15.9】, 〖16.4..18.0】, 〖20.5..21.2】, 【22.2..22.9】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..43.0〗, 〖44.0..44.7〗,
      〖45.8..45.9〗, 【46.2..47.2】, 【48.2..48.5〗, 〖49.8..50.9】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(〖9.1..24.6】)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..43.0〗, 〖44.0..44.7〗,
      〖45.8..45.9〗, 【46.2..47.2】, 【48.2..48.5〗, 〖49.8..50.9】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(〖47.0..48.2〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..43.0〗, 〖44.0..44.7〗,
      〖45.8..45.9〗, 【46.2..47.0】, 【48.2..48.5〗, 〖49.8..50.9】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(〖44.3..46.0〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 【48.2..48.5〗, 〖49.8..50.9】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(48.2)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.7〗, 【39.0..39.1〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 〖48.2..48.5〗, 〖49.8..50.9】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(【38.6..39.1〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 〖48.2..48.5〗, 〖49.8..50.9】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 〖87.3..87.8〗, 〖88.3..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(〖87.3..88.4〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 〖48.2..48.5〗, 〖49.8..50.9】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 【88.4..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(〖48.2..51.0】)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.3..30.5〗, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 【88.4..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(【30.3..30.6】)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【28.6..29.3】, 〖29.9..30.0】, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 【88.4..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(【28.4..30.0〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【30.0..30.0】, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【40.5..40.5】, 〖42.5..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 【88.4..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(40.5)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【30.0..30.0】, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 〖42.5..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 【88.4..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(〖40.0..42.9〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【30.0..30.0】, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【42.9..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 〖82.4..84.0〗, 〖84.4..84.6】, 〖85.7..86.5】, 【88.4..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(【82.4..86.5】)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【30.0..30.0】, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【42.9..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 【66.3..67.0〗, 【67.6..68.8】, 〖71.9..74.2】, 〖75.4..76.1】,
      〖76.2..77.5〗, 【78.8..81.9〗, 【88.4..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(〖66.0..74.2】)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【30.0..30.0】, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【42.9..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 〖75.4..76.1】, 〖76.2..77.5〗, 【78.8..81.9〗, 【88.4..88.5】,
      〖88.6..89.1】, 【90.0..91.4】, 〖94.2..94.3】, 〖94.4..94.6〗, 【96.0..98.3】
    ]

    map.remove(【89.9..94.6〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】,
      【26.1..26.6〗, 〖27.0..27.3】, 【30.0..30.0】, 【30.7..31.9〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【42.9..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 〖75.4..76.1】, 〖76.2..77.5〗, 【78.8..81.9〗, 【88.4..88.5】,
      〖88.6..89.1】, 【96.0..98.3】
    ]

    map.remove(【27.0..32.1〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】, 【26.1..26.6〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【42.9..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 〖75.4..76.1】, 〖76.2..77.5〗, 【78.8..81.9〗, 【88.4..88.5】,
      〖88.6..89.1】, 【96.0..98.3】
    ]

    map.remove(【1.6..1.6〗)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】, 【26.1..26.6〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【42.9..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 〖75.4..76.1】, 〖76.2..77.5〗, 【78.8..81.9〗, 【88.4..88.5】,
      〖88.6..89.1】, 【96.0..98.3】
    ]

    map.remove(【60.0..60.0】)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】, 【26.1..26.6〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【42.9..43.0〗, 〖44.0..44.3】,
      【46.2..47.0】, 【56.2..56.6〗, 〖58.3..58.4】, 【59.2..60.0〗, 〖60.0..60.1】,
      【60.4..60.9〗, 【64.4..65.2】, 〖75.4..76.1】, 〖76.2..77.5〗, 【78.8..81.9〗, 【88.4..88.5】,
      〖88.6..89.1】, 【96.0..98.3】
    ]

    map.remove(〖45.0..76.2】)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】, 【26.1..26.6〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【42.9..43.0〗, 〖44.0..44.3】,
      〖76.2..77.5〗, 【78.8..81.9〗, 【88.4..88.5】, 〖88.6..89.1】, 【96.0..98.3】
    ]

    map.remove(88.5)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】, 【26.1..26.6〗, 【32.7..33.8】,
      【35.3..35.5】, 【36.8..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【42.9..43.0〗, 〖44.0..44.3】,
      〖76.2..77.5〗, 【78.8..81.9〗, 【88.4..88.5〗, 〖88.6..89.1】, 【96.0..98.3】
    ]


    map.remove(〖36.0..37.0】)
    expect(map) == [
      〖0.3..0.7〗, 【1.6..2.4】, 〖7.6..9.1】, 【26.1..26.6〗, 【32.7..33.8】,
      【35.3..35.5】, 〖37.0..37.7〗, 【38.4..38.6〗, 【39.6..39.9】, 【42.9..43.0〗, 〖44.0..44.3】,
      〖76.2..77.5〗, 【78.8..81.9〗, 【88.4..88.5〗, 〖88.6..89.1】, 【96.0..98.3】
    ]

    map.remove(【0.0..100.0】)
    expect(map).to(beEmpty())

  }

  func testInvert() {

    expect(IntervalMap([
      〖4.4..8.2】, 【9.9..14.7】, 【18.1..24.2〗, 〖36.6..45.0〗
      ]).inverted(coverage: 【0.0..50.0】)) == [【0.0..4.4】, 〖8.2..9.9〗, 〖14.7..18.1〗, 【24.2..36.6】, 【45.0..50.0】]

  }

  func testEquatable() {

    let intervals = [
      〖4.9..8.2】,
      【9.1..24.6】,
      【26.3..39.2〗,
      〖44.3..56.2〗
    ]

    expect(IntervalMap<Double>(intervals).elementsEqual(intervals)) == true

  }

  func testSubscriptIndexAccessor() {

    let map = IntervalMap<Double>([
      〖4.9..8.2】,
      【9.1..24.6】,
      【26.3..39.2〗,
      〖44.3..56.2〗
      ])

    expect(map[0]) == 〖4.9..8.2】
    expect(map[1]) == 【9.1..24.6】
    expect(map[2]) == 【26.3..39.2〗
    expect(map[3]) == 〖44.3..56.2〗

  }

  func testSubscriptRangeAccessor() {

    let map = IntervalMap<Double>([
      〖4.9..8.2】,
      【9.1..24.6】,
      【26.3..39.2〗,
      〖44.3..56.2〗
      ])

    expect(map[0..<2].elementsEqual([〖4.9..8.2】, 【9.1..24.6】])) == true //FAIL
    expect(map[0..<3].elementsEqual([〖4.9..8.2】, 【9.1..24.6】, 【26.3..39.2〗])) == true //FAIL
    expect(map[2..<4].elementsEqual([【26.3..39.2〗, 〖44.3..56.2〗])) == true //FAIL
    expect(map[3..<4].elementsEqual([〖44.3..56.2〗])) == true //FAIL
    expect(map[3..<3].isEmpty) == true

  }

}

