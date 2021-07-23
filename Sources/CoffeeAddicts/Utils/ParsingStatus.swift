//
//  File.swift
//  
//
//  Created by Mihai Garda Popescu on 23.07.2021.
//

import Foundation

enum ParsingStatus: String {
    case CSVFileDownloadError
    case CSVFileReadingError
    case CSVFileDownloadSuccess
    case CSVFileInvalid
    case CSVFileLineInvalid
    case CSVFileEmptyResult
    case CSVParsingSuccess
}
