//
//  LocationPickerViewModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 18/09/25.
//

import Foundation
import MapKit
import SwiftUI

class LocationPickerViewModel: ObservableObject {
    @Published var position: MapCameraPosition = .automatic
    @Published var searchText = ""
    @Published var searchResults: [MKMapItem] = []
    @Published var selectedMapItem: MKMapItem?
    
    @Published var isDraggingMap = false
    @Published var mapCenterCoordinate = CLLocationCoordinate2D()
    
    func searchLocation() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self, let response = response, error == nil else {
                return
            }
            
            self.searchResults = response.mapItems
        }
    }
    
    func selectMapItem(_ item: MKMapItem, updateCoordinate: (CLLocationCoordinate2D) -> Void, updateLocation: (String) -> Void) {
        selectedMapItem = item
        position = .region(MKCoordinateRegion(
            center: item.placemark.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
        
        updateCoordinate(item.placemark.coordinate)
        
        let placemark = item.placemark
        updateLocation(formatAddress(from: placemark))
    }
    
    func formatAddress(from placemark: CLPlacemark) -> String {
        var addressComponents: [String] = []
        
        if let name = placemark.name, !name.isEmpty {
            addressComponents.append(name)
        }
        
        if let thoroughfare = placemark.thoroughfare, !thoroughfare.isEmpty {
            addressComponents.append(thoroughfare)
        }
        
        if let locality = placemark.locality, !locality.isEmpty {
            addressComponents.append(locality)
        }
        
        if let administrativeArea = placemark.administrativeArea, !administrativeArea.isEmpty {
            addressComponents.append(administrativeArea)
        }
        
        if let postalCode = placemark.postalCode, !postalCode.isEmpty {
            addressComponents.append(postalCode)
        }
        
        if let country = placemark.country, !country.isEmpty {
            addressComponents.append(country)
        }
        
        return addressComponents.joined(separator: ", ")
    }
    
    func geocodeAddress(_ address: String, updateCoordinate: @escaping (CLLocationCoordinate2D) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            guard let self = self, error == nil, let placemark = placemarks?.first else { return }
            
            if let location = placemark.location {
                updateCoordinate(location.coordinate)
                
                self.position = .region(MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))
            }
        }
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D, updateLocation: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self, error == nil, let placemark = placemarks?.first else { return }
            
            updateLocation(self.formatAddress(from: placemark))
        }
    }
}
