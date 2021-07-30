//
//  File.swift
//  
//
//  Created by Mihai Garda Popescu on 23.07.2021.
//

import Foundation

typealias CSVResult = (String?, ParsingStatus) -> Void

class CoffeeShopsCSVDownloader {
    static func downloadCSVFileFromURLString(_ urlString: String, completion: @escaping CSVResult) {
        guard let documentsUrl: URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?) else {
            completion(nil, .CSVFileDownloadError)
            return
        }

        let sema = DispatchSemaphore(value: 0)

        let destinationFileUrl = documentsUrl.appendingPathComponent(Constants.localCSVFileName)
        
        do {
            try FileManager.default.removeItem(at: destinationFileUrl)
        } catch {
            completion(nil, .CSVFileDownloadError)
        }

        if let fileURL = URL(string: urlString) {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
         
            let request = URLRequest(url: fileURL)
            
            CoffeeShopsCSVDownloader.downloadTaskForSession(session,
                                                            destinationFileURL: destinationFileUrl,
                                                            request: request,
                                                            semaphore: sema,
                                                            completion: completion)
        } else {
            completion(nil, .CSVFileDownloadError)
        }
    }
    
    static func downloadTaskForSession(_ session: URLSession,
                                       destinationFileURL: URL,
                                       request: URLRequest,
                                       semaphore: DispatchSemaphore,
                                       completion: @escaping CSVResult) {
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileURL)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileURL) : \(writeError)")
                    completion(nil, .CSVFileDownloadError)
                }
                
                do {
                    let csvString = try String(contentsOf: destinationFileURL, encoding: .utf8)
                    completion(csvString, .CSVFileDownloadSuccess)
                    semaphore.signal()

                } catch {
                    print("error reading from file")
                    completion(nil, .CSVFileReadingError)
                    semaphore.signal()
                }
            } else {
                print("Error" )
                semaphore.signal()
            }
        }
        task.resume()
        semaphore.wait()
    }
}
