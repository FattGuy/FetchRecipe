//
//  URLSessionMock.swift
//  FetchRecipe
//
//  Created by Feng Chang on 2/3/25.
//

import Foundation

/// A mock version of `URLSession` that allows us to simulate API responses for testing.
class URLSessionMock: URLSessionProtocol {
    var testData: Data?
    var testResponse: URLResponse?
    var testError: Error?

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.testData = data
        self.testResponse = response
        self.testError = error
    }

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
