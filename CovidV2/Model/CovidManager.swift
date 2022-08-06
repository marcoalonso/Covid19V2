//
//  CovidManager.swift
//  CovidV2
//
//  Created by marco rodriguez on 06/08/22.
//

import Foundation

protocol covidManagerProtocol {
    func cargarDatos(datos: CovidDatos)
    func huboError(cualError: Error)
}

protocol historialPaisProtocol {
    func cargarDatos(datos: [PaisDatos])
}

struct CovidManager {
 
    var delegado: covidManagerProtocol?
    var delegadoHistorial: historialPaisProtocol?
    
    func estadisticasHoy(pais: String) {
        let urlString = "https://api.covid19api.com/dayone/country/\(pais)/status/confirmed"
        
        if let url = URL(string: urlString){
            let sesion = URLSession(configuration: .default)
            
            let tarea = sesion.dataTask(with: url) { datos, respuesta, error in
                //Si hubo un error
                if error != nil {
                    print("Error en la tarea: \(error!.localizedDescription)")
                    //delegado?.huboError(cualError: error!)
                }
                //Si no hubo error
                if let datosSeguros = datos {
        
                    if let estadisticasUI =  self.parsearJSONPais(data: datosSeguros) {
                        //por medio del delegado mandar la dataUI
                        delegadoHistorial?.cargarDatos(datos: estadisticasUI)
                    }
                    
                }//if let
            }
            tarea.resume()
        }
    }
    
    func parsearJSONPais(data: Data) -> [PaisDatos]? {
        //print("parsearJSON")
        let decodificador = JSONDecoder()
        do {
            let datosDecodificados: [PaisDatos]  = try decodificador.decode([PaisDatos].self, from: data)
            
            print("Decodificacion Exitosa")
//            print(datosDecodificados)
            //retorna el array de todo el historial de ese pais
            return datosDecodificados
            
        }catch {
            print("Error al decodificar: \(error.localizedDescription)")
            delegado?.huboError(cualError: error)
            return nil
        }
    }
    
    func buscarEstadisticas() {
        let urlString = "https://api.covid19api.com/summary"
        
        if let url = URL(string: urlString){
            let sesion = URLSession(configuration: .default)
            
            let tarea = sesion.dataTask(with: url) { datos, respuesta, error in
                //Si hubo un error
                if error != nil {
                    print("Error en la tarea: \(error!.localizedDescription)")
                    delegado?.huboError(cualError: error!)
                }
                //Si no hubo error
                if let datosSeguros = datos {
        
                    if let estadisticasUI =  self.parsearJSON(data: datosSeguros) {
                        //por medio del delegado mandar la dataUI
                        delegado?.cargarDatos(datos: estadisticasUI)
                    }
                    
                }//if let
            }
            tarea.resume()
        }//if let url
    }//func buscar
    
    func parsearJSON(data: Data) -> CovidDatos? {
        //print("parsearJSON")
        let decodificador = JSONDecoder()
        do {
            let datosDecodificados  = try decodificador.decode(CovidDatos.self, from: data)
            
            //print("Decodificacion Exitosa")
            print(datosDecodificados)
            
            return datosDecodificados
            
        }catch {
            print("Error al decodificar: \(error.localizedDescription)")
            delegado?.huboError(cualError: error)
            return nil
        }
    }
    
    
}
