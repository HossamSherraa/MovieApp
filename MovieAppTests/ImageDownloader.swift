//
//  ImageDownloader.swift
//  MovieAppTests
//
//  Created by Hossam on 31/05/2021.
//

import SwiftUI
import XCTest
import Combine
@testable import MovieApp

class ImageDownloaderTests: XCTestCase {

    var subscriptions : Set<AnyCancellable> = []
    let imageDownloader : ImageDownloader = MDBimageDownloader(mDBService: MDBNetworkService.shared)
    let imagePath : String = "/sdEOH0992YZ0QSxgXNIGLq1ToUi.jpg"
    lazy var imageDownloaderexpectation = expectation(description: "ImageDownloaderTests")
  
    func  testsimageDownloader() throws {
        imageDownloader.getImage(path: imagePath, size: .medium)
            .sink { image in
                
                XCTAssert(true)
               
                self.imageDownloaderexpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [imageDownloaderexpectation], timeout: 0.1)
    }

    

}
