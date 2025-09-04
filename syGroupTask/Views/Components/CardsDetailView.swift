//
//  CardsDetailView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 03/09/25.
//

import SwiftUI

struct CardsDetailView: View {
    @State var number:UUID?
    var body: some View {
        Text("\(number!)")
    }
}

#Preview {
    CardsDetailView()
}
