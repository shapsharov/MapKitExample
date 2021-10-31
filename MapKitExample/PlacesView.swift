//
//  PlacesView.swift
//  MapKitExample
//
//  Created by Bogdan Shapsharov on 31.10.2021.
//

import SwiftUI

/// Отображение точек интереса
struct PlacesView: View {

	/// Модель отображения
	@StateObject var places: PlacesViewModel

	// MARK: - View

	var body: some View {
		VStack {
			MapView()
				.environmentObject(places)
				.ignoresSafeArea()
			NavigationView {
				List {
					ForEach(places.places, id: \.self) { place in
						HStack {
							Text("\(place.title ?? "")")
							Spacer()
						}
						.onTapGesture {
							places.lastPick = place
						}
					}
					.onDelete(perform: places.removePlaces(at:))
				}
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						EditButton()
					}
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		PlacesView(places: PlacesViewModel())
	}
}
