//
//  ContentView.swift
//  protobuf-poc
//
//  Created by Asad Javed on 03/03/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Button("Connect", action: {
                    viewModel.openConn()
                })
                Button("Disconnect", action: {
                    viewModel.closeConn()
                })
                Button("Send", action: {
                    do {
                        let payload = try BookInfo.random.serializedData()
                        viewModel.send(payload: payload)
                    } catch let error {
                        print("error sending payload: \(error)")
                    }
                })
                Spacer()
            }
            HStack(spacing: 4) {
                Text("Connection status:")
                    .font(.system(size: 12, weight: .light))
                Text("\(viewModel.status.rawValue)")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(viewModel.status == .connected ? .green : .gray)
                Spacer()
            }
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    ForEach(viewModel.books, id: \.id) { book in
                        HStack {
                            Text("#\(book.id).")
                                .font(.system(size: 12, weight: .light))
                            Spacer()
                                .frame(width: 8)
                            Text("\(book.title)")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text("by \(book.author)")
                                .font(.system(size: 14, weight: .regular))
                        }
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                        )
                        .padding(.vertical, 4)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .animation(.linear)
            }
        }
        .padding(.horizontal, 16)
    }
}
