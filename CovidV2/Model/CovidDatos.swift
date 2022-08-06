//
//  CovidDatos.swift
//  CovidV2
//
//  Created by marco rodriguez on 06/08/22.
//

import Foundation

struct CovidDatos: Decodable {
    let Global: GlobalStats
    let Countries: [CountriesStats]
}

struct GlobalStats: Decodable {
    let NewConfirmed: Int64
    let TotalConfirmed: Int64
    let NewDeaths: Int64
    let TotalDeaths: Int64
    let NewRecovered: Int64
    let TotalRecovered: Int64
    let Date: String
}

struct CountriesStats: Codable {
    let Country: String
    let TotalConfirmed: Int64
    let TotalDeaths: Int64
}
