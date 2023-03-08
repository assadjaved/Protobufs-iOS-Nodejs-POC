//
//  protobuf_pocApp.swift
//  protobuf-poc
//
//  Created by Asad Javed on 03/03/2023.
//

import SwiftUI

@main
struct protobuf_pocApp: App {
    private let viewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
