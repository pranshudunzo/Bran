//
//  BotController.swift
//  App
//
//  Created by Pranshu Goyal on 27/06/19.
//

import Vapor
import Dispatch

/// Controls basic CRUD operations on `Todo`s.
final class BotController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }
    
    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return todo.save(on: req)
        }
    }
    
    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
            }.transform(to: .ok)
    }
    
    func run(_ req: Request) throws -> Future<HTTPResponse> {
        
        // Connect a new client to the supplied hostname.
        let client = HTTPClient.connect(hostname: "vapor.codes", on: req)
        // Create an HTTP request: GET /
        let httpReq = HTTPRequest(method: .GET, url: "/")
        // Send the HTTP request, fetching a response
        let response =  client.flatMap({ (client) in
            return client.send(httpReq)
        })
        
        let _ = response.map({ (response) in
            print(response)
        })
        
        return response
    }
}
