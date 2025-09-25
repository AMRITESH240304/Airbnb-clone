//
//  LocationPickerView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 18/09/25.
//

import SwiftUI
import MapKit

struct LocationPickerView: View {
    @Binding var coordinate: CLLocationCoordinate2D
    @Binding var location: String
    @Binding var hasSetCoordinate: Bool
    @StateObject private var viewModel = LocationPickerViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search for a location", text: $viewModel.searchText)
                        .onSubmit {
                            viewModel.searchLocation()
                        }
                    
                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
                            viewModel.searchResults = []
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                if !viewModel.searchResults.isEmpty {
                    List(viewModel.searchResults, id: \.self) { item in
                        Button {
                            viewModel.selectMapItem(item, updateCoordinate: { newCoordinate in
                                coordinate = newCoordinate
                                hasSetCoordinate = true
                            }, updateLocation: { newLocation in
                                location = newLocation
                            })
                        } label: {
                            VStack(alignment: .leading) {
                                Text(item.name ?? "Unknown Location")
                                    .foregroundColor(Theme.textPrimary)
                                Text(item.placemark.title ?? "")
                                    .font(.caption)
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: min(CGFloat(viewModel.searchResults.count * 60), 200))
                }
                
                Map(position: $viewModel.position, interactionModes: .all) {
                    if let item = viewModel.selectedMapItem {
                        Marker(item.name ?? "Selected Location", coordinate: item.placemark.coordinate)
                    } else if hasSetCoordinate {
                        Marker("Selected Location", coordinate: coordinate)
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .onMapCameraChange { context in
                    viewModel.mapCenterCoordinate = context.region.center
                }
                .overlay(alignment: .center) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(Theme.primaryColor)
                        .background(Circle().fill(.white).frame(width: 25, height: 25))
                        .opacity(viewModel.isDraggingMap ? 1 : 0)
                }
                .gesture(
                    DragGesture()
                        .onChanged { _ in
                            viewModel.isDraggingMap = true
                        }
                        .onEnded { _ in
                            coordinate = viewModel.mapCenterCoordinate
                            hasSetCoordinate = true
                            
                            viewModel.reverseGeocode(coordinate: coordinate) { newLocation in
                                location = newLocation
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                viewModel.isDraggingMap = false
                            }
                        }
                )
                
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Theme.textSecondary)
                    
                    Spacer()
                    
                    Button("Use This Location") {
                        if !hasSetCoordinate && viewModel.selectedMapItem != nil {
                            coordinate = viewModel.selectedMapItem!.placemark.coordinate
                            hasSetCoordinate = true
                        }
                        dismiss()
                    }
                    .foregroundColor(Theme.primaryColor)
                    .disabled(!hasSetCoordinate && viewModel.selectedMapItem == nil)
                }
                .padding()
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if hasSetCoordinate {
                viewModel.position = .region(MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))
            }
            
            if !location.isEmpty && !hasSetCoordinate {
                viewModel.geocodeAddress(location) { newCoordinate in
                    coordinate = newCoordinate
                    hasSetCoordinate = true
                }
            }
        }
    }
}
