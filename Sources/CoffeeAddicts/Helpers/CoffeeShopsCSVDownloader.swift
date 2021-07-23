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
        let sema = DispatchSemaphore(value: 0)

        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent(Constants.localCSVFileName)
        
        do {
            try FileManager.default.removeItem(at: destinationFileUrl)
        } catch {
            completion(nil, .CSVFileDownloadError)
        }

        let fileURL = URL(string: urlString)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
     
        let request = URLRequest(url:fileURL!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    completion(nil, .CSVFileDownloadError)
                }
                
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = dir.appendingPathComponent(Constants.localCSVFileName)
                    
                    do {
                        let csvString = try String(contentsOf: fileURL, encoding: .utf8)
                        completion(csvString, .CSVFileDownloadSuccess)
                        sema.signal()

                    } catch {
                        print("error reading from file")
                        completion(nil, .CSVFileReadingError)
                        sema.signal()
                    }
                }
            } else {
                print("Error" )
                sema.signal()

            }
        }
        task.resume()
        sema.wait()
    }
}
