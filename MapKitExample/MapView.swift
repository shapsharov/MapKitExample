//
//  MapView.swift
//  MapKitExample
//
//  Created by Bogdan Shapsharov on 31.10.2021.
//

import MapKit
import SwiftUI

/// Отображение карты (обёртка над MKMapView)
struct MapView: UIViewRepresentable {

	typealias UIViewType = MKMapView

	/// Модель отображения точек интереса
	@EnvironmentObject var placesViewModel: PlacesViewModel

	/// Отображение карты из MapKit
	@State var view: MKMapView = MKMapView()

	// MARK: - UIViewRepresentable

	func makeUIView(context: Context) -> MKMapView {
		view.delegate = context.coordinator
		let recognizer = UILongPressGestureRecognizer(target: context.coordinator,
													  action: #selector(context.coordinator.addPinBasedOnGesture(_:)))
		view.addGestureRecognizer(recognizer)
		return view
	}

	func updateUIView(_ uiView: MKMapView, context: Context) {
		if placesViewModel.places.count !=  uiView.annotations.count {
			uiView.removeAnnotations(uiView.annotations)
			uiView.addAnnotations(placesViewModel.places)
		}

		if let place = placesViewModel.lastPick {
			let region = MKCoordinateRegion(center: place.coordinate,
											span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
			uiView.setRegion(region, animated: true)
		}

		uiView.removeOverlays(uiView.overlays)
		let line = MKPolyline(points: placesViewModel.places.map { MKMapPoint($0.coordinate) },
							  count: placesViewModel.places.count)

		uiView.addOverlay(line)
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	//MARK: - Coordinator

	/// Координатор отображения карты
	final class Coordinator: NSObject, MKMapViewDelegate {

		/// Родительское отображение
		var parent: MapView

		/// Инициализатор
		/// - Parameter parent: родительское отображение
		init(_ parent: MapView) {
			self.parent = parent
		}

		/// Добавить маркер на карту
		/// - Parameter gestureRecognizer: распознователь жестов
		@objc func addPinBasedOnGesture(_ gestureRecognizer:UIGestureRecognizer) {
			if gestureRecognizer.state == .ended {
				guard let newCoordinates = gestureRecognizer.view as? MKMapView else { return }
				let touchPoint = gestureRecognizer.location(in: gestureRecognizer.view)
				let coordinate = newCoordinates.convert(touchPoint, toCoordinateFrom: gestureRecognizer.view)
				parent.placesViewModel.append(place: Place(coordinate: coordinate))
				let region = MKCoordinateRegion(center: coordinate,
												span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
				parent.view.setRegion(region, animated: true)
			}
		}

		// MARK: - MKMapViewDelegate

		func mapView(
			_ mapView: MKMapView,
			viewFor annotation: MKAnnotation
		) -> MKAnnotationView? {
			guard let place = annotation as? Place else {
				return nil
			}

			let identifier = "place"
			var view: MKMarkerAnnotationView

			if let dequeuedView = mapView.dequeueReusableAnnotationView(
				withIdentifier: identifier) as? MKMarkerAnnotationView {
				dequeuedView.annotation = place
				view = dequeuedView
			} else {
				view = MKMarkerAnnotationView(
					annotation: place,
					reuseIdentifier: identifier)
				view.canShowCallout = true
				view.calloutOffset = CGPoint(x: -5, y: 5)
				view.rightCalloutAccessoryView = UIButton(type: .close)
			}
			return view
		}

		func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
			guard let place = view.annotation as? Place else { return }
			parent.placesViewModel.lastPick = place
			let region = MKCoordinateRegion(center: place.coordinate,
											span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
			parent.view.setRegion(region, animated: true)
		}

		func mapView(
			_ mapView: MKMapView,
			annotationView view: MKAnnotationView,
			calloutAccessoryControlTapped control: UIControl
		) {
			guard let place = view.annotation as? Place else { return }
			parent.placesViewModel.remove(place: place)
		}

		func mapView(
			_ mapView: MKMapView,
			rendererFor overlay: MKOverlay
		) -> MKOverlayRenderer {
			let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
			renderer.strokeColor = .blue
			return renderer
		}
	}

}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView()
			.environmentObject(PlacesViewModel())
	}
}

