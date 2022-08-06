//
//  CovidDatos.swift
//  CovidV2
//
//  Created by marco rodriguez on 06/08/22.
//

import Foundation

struct CovidDatos: Decodable {
    let Global: GlobalStats
}

struct GlobalStats: Decodable {
    let  NewConfirmed: Double
    let  TotalConfirmed: Double
    let NewDeaths: Double
    let TotalDeaths: Double
    let NewRecovered: Double
    let TotalRecovered: Double
    let Date: String
}
