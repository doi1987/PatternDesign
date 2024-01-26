//
//  NetworkError.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 22/1/24.
//

import Foundation

enum NetworkError {
	case malformedURL
	case dataFormatting
	case other
	case noData
	case errorCode(Int?)
	case tokenFormatError
	case decoding
}
