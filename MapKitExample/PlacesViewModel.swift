//
//  PlacesViewModel.swift
//  MapKitExample
//
//  Created by Bogdan Shapsharov on 31.10.2021.
//

import Combine
import Foundation

/// Модель отображения точек интереса
final class PlacesViewModel: ObservableObject {

	/// Массив точек интереса
	@Published private(set) var places: [Place] = []

	/// Последняя выбранная точка
	@Published var lastPick: Place?

	/// Добавить новую точку интереса
	/// - Parameter place: точка интереса
	func append(place: Place) {
		if !places.contains(where: { $0 == place }) {
			places.append(place)
			lastPick = place
		}
	}

	// Удалить конкретную точку интереса.
	/// - Parameter place: точка интереса
	func remove(place: Place) {
		places.removeAll(where: { $0 == place} )
		lastPick = nil
	}

	/// Удалить набор точек интереса
	/// - Parameter indexSet: индекс
	func removePlaces(at indexSet: IndexSet) {
		if let maxIndex = indexSet.max(), maxIndex < places.count {
			places.remove(atOffsets: indexSet)
			lastPick = nil
		}
	}
}
