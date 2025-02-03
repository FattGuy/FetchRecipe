//
//  URLSessionMock.swift
//  FetchRecipe
//
//  Created by Feng Chang on 2/3/25.
//

import Foundation

class URLSessionMock: URLSessionProtocol {
    var testData: Data?
    var testResponse: HTTPURLResponse?
    var testError: Error?
    
    /// Allows configuring mock session easily
    init(data: Data? = nil, statusCode: Int = 200, error: Error? = nil) {
        self.testData = data
        self.testError = error
        self.testResponse = HTTPURLResponse(url: URL(string: "https://mock.api.com")!,
                                            statusCode: statusCode,
                                            httpVersion: nil,
                                            headerFields: nil)
    }
    
    /// Simulates async network request
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = testError {
            throw error
        }
        
        guard let data = testData, let response = testResponse else {
            throw URLError(.badServerResponse)
        }
        
        return (data, response)
    }
}
