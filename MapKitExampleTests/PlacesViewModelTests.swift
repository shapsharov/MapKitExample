//
//  PlacesViewModelTests.swift
//  MapKitExampleTests
//
//  Created by Bogdan Shapsharov on 31.10.2021.
//

import XCTest
@testable import MapKitExample

final class PlacesViewModelTests: XCTestCase {

	var sut: PlacesViewModel?

	override func setUp() {
		super.setUp()
		sut = PlacesViewModel()
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func getPlace(lat: Double = 0.1, long: Double = 0.2) -> Place {
		Place(coordinate: .init(latitude: lat, longitude: long))
	}
}

// MARK: - Tests

extension PlacesViewModelTests {

	func testAppendPlace() {
		// arrange
		let place = getPlace()

		// act
		sut?.append(place: place)

		// assert
		XCTAssertEqual(sut?.places.count, 1)
		XCTAssertEqual(sut?.lastPick, place)
	}

	func testAppendPlaceTwice() {
		// arrange
		let place = getPlace()

		// act
		sut?.append(place: place)
		sut?.append(place: place)

		// assert
		XCTAssertEqual(sut?.places.count, 1)
		XCTAssertEqual(sut?.lastPick, place)
	}

	func testAppendPlaceTwoDifferent() {
		// arrange
		let place1 = getPlace()
		let place2 = getPlace(lat: 0.2, long: 0.3)

		// act
		sut?.append(place: place1)
		sut?.append(place: place2)

		// assert
		XCTAssertEqual(sut?.places.count, 2)
		XCTAssertEqual(sut?.places.first, place1)
		XCTAssertEqual(sut?.places.last, place2)
		XCTAssertEqual(sut?.lastPick, place2)
	}

	func testRemovePlace() {
		// arrange
		let place1 = getPlace()
		sut?.append(place: place1)
		let place2 = getPlace(lat: 0.2, long: 0.3)
		sut?.append(place: place2)

		// act
		sut?.remove(place: place2)

		// assert
		XCTAssertEqual(sut?.places.count, 1)
		XCTAssertNil(sut?.lastPick)
	}

	func testRemovePlaceFromEmpty() {
		// arrange
		let place = getPlace()

		// act
		sut?.remove(place: place)

		// assert
		XCTAssertEqual(sut?.places.count, 0)
		XCTAssertNil(sut?.lastPick)
	}

	func testRemovePlaceLast() {
		// arrange
		let place = getPlace()
		sut?.append(place: place)

		// act
		sut?.remove(place: place)

		// assert
		XCTAssertEqual(sut?.places.count, 0)
		XCTAssertNil(sut?.lastPick)
	}

	func testRemovePlacesCorrectIndiсes() {
		// arrange
		let place = getPlace()
		sut?.append(place: place)

		// act
		sut?.removePlaces(at: IndexSet(integer: 0))

		// assert
		XCTAssertEqual(sut?.places.count, 0)
		XCTAssertNil(sut?.lastPick)
	}

	func testRemovePlacesOutofBoundsIndices() {
		// arrange
		let place = getPlace()
		sut?.append(place: place)

		// act
		sut?.removePlaces(at: IndexSet(integer: 1))

		// assert
		XCTAssertEqual(sut?.places.count, 1)
		XCTAssertEqual(sut?.lastPick, place)
	}
}
