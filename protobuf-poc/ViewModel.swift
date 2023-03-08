//
//  ViewModel.swift
//  protobuf-poc
//
//  Created by Asad Javed on 06/03/2023.
//

import Foundation
import Starscream

class ViewModel: ObservableObject {
    enum SocketStatus: String {
        case connected = "Connected"
        case disconnected = "Disconnected"
    }
    private let socket: WebSocket
    @Published private(set) var status: SocketStatus = .disconnected
    @Published private(set) var books: [BookInfo] = []
    
    init() {
        var request = URLRequest(url: URL(string: "wss://localhost:8080")!)
        request.timeoutInterval = 5
        let pinner = FoundationSecurity(allowSelfSigned: true) // don't validate SSL certificates
        socket = WebSocket(request: request, certPinner: pinner)
        socket.delegate = self
    }
    
    func openConn() {
        socket.connect()
    }
    
    func closeConn() {
        socket.disconnect()
    }
    
    func ping() {
        //TODO: - test ping
    }
    
    func send(payload: Data) {
        socket.write(data: payload)
    }
}

extension ViewModel: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
        case .connected:
            print("websocket is connected")
            status = .connected
        case .disconnected, .cancelled, .reconnectSuggested:
            print("websocket is disconnected")
            status = .disconnected
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
            if let book = try? BookInfo(serializedData: data) {
                books.append(book)
            }
        case .ping, .pong, .viabilityChanged:
            break
        case .error(let error):
            guard let error else { return }
            print("Error: \(error.localizedDescription)")
            closeConn()
        }
    }
}

extension BookInfo {
    static var random: BookInfo {
        let books = [
            "To Kill a Mockingbird by Harper Lee",
            "1984 by George Orwell",
            "The Great Gatsby by F. Scott Fitzgerald",
            "Pride and Prejudice by Jane Austen",
            "The Catcher in the Rye by J.D. Salinger",
            "The Lord of the Rings by J.R.R. Tolkien",
            "Harry Potter and the Philosopher's Stone by J.K. Rowling",
            "The Hitchhiker's Guide to the Galaxy by Douglas Adams",
            "One Hundred Years of Solitude by Gabriel Garcia Marquez",
            "Animal Farm by George Orwell",
            "Brave New World by Aldous Huxley",
            "Crime and Punishment by Fyodor Dostoevsky",
            "The Adventures of Huckleberry Finn by Mark Twain",
            "The Picture of Dorian Gray by Oscar Wilde",
            "Frankenstein by Mary Shelley",
            "Wuthering Heights by Emily Bronte",
            "The Diary of a Young Girl by Anne Frank",
            "The Count of Monte Cristo by Alexandre Dumas",
            "The Brothers Karamazov by Fyodor Dostoevsky",
            "The Hunger Games by Suzanne Collins"
        ]
        let book = books.randomElement()!
        let comps = book.components(separatedBy: "by")
        return BookInfo.with {
            $0.id = Int64(books.firstIndex(of: book)!)
            $0.title = String(comps.first!)
            $0.author = String(comps.last!)
        }
    }
}
