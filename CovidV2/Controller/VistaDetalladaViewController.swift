//
//  VistaDetalladaViewController.swift
//  CovidV2
//
//  Created by marco rodriguez on 06/08/22.
//

import UIKit
import MapKit

class VistaDetalladaViewController: UIViewController {
    
    var paisCovid: CountriesStats?
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var totalDeathsLabel: UILabel!
    @IBOutlet weak var totalConfirmedLabel: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    
    var manager = CovidManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegadoHistorial = self

        configureUI()
        manager.estadisticasHoy(pais: paisCovid?.Country ?? "mexico")
    }
    
    func configureUI(){
        countryLabel.text = paisCovid?.Country
        totalDeathsLabel.text = "Total de muertes: \(paisCovid?.TotalDeaths ?? 0)"
        totalConfirmedLabel.text = "Casos confirmados: \(paisCovid?.TotalConfirmed ?? 0)"
    }


}

extension VistaDetalladaViewController: historialPaisProtocol {
    func cargarDatos(datos: [PaisDatos]) {
        print(datos[0])
    }
    
    
}
