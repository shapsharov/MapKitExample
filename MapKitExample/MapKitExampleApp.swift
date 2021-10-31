//
//  MapKitExampleApp.swift
//  MapKitExample
//
//  Created by Bogdan Shapsharov on 31.10.2021.
//

import SwiftUI

@main
struct MapKitExampleApp: App {
	let placesViewModel = PlacesViewModel()

	var body: some Scene {
		WindowGroup {
			PlacesView(places: placesViewModel)
		}
	}
}
