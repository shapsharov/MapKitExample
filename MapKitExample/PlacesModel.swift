//
//  PlacesModel.swift
//  MapKitExample
//
//  Created by Bogdan Shapsharov on 31.10.2021.
//

import MapKit

/// Точка интереса
final class Place: NSObject, MKAnnotation, Identifiable {

	/// Координаты
	let coordinate: CLLocationCoordinate2D

	/// Заголовок
	var title: String? {
		"(\(String(format: "%.3f", coordinate.latitude)), \(String(format: "%.3f", coordinate.longitude)))"
	}

	/// Инициализатор
	/// - Parameter coordinate: координаты
	init(coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
		super.init()
	}
}
