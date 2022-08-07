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
    private var lat: Double?
    private var lon: Double?
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var totalDeathsLabel: UILabel!
    @IBOutlet weak var totalConfirmedLabel: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    
    var manager = CovidManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegadoHistorial = self

        mapa.delegate = self
        
        configureUI()
        manager.estadisticasHoy(pais: paisCovid?.Country ?? "mexico")
    }
    
    func configureUI(){
        countryLabel.text = paisCovid?.Country
        totalDeathsLabel.text = "Total de muertes: \(paisCovid?.TotalDeaths ?? 0)"
        totalConfirmedLabel.text = "Casos confirmados: \(paisCovid?.TotalConfirmed ?? 0)"
    }
    
    func setupMap() {
        //Mapa
        let anotacion = MKPointAnnotation()
        anotacion.title = "\(paisCovid?.Country ?? "")"
        anotacion.subtitle = "Muertes: \(paisCovid?.TotalDeaths ?? 0)"
        anotacion.coordinate = CLLocationCoordinate2D(latitude: lat ?? 19.1493, longitude: lon ?? -101.1234)
       
        
        
        let span = MKCoordinateSpan(latitudeDelta: 40.0, longitudeDelta: 40.0)
        let region = MKCoordinateRegion(center: anotacion.coordinate, span: span)
        self.mapa.setRegion(region, animated: true)
        self.mapa.addAnnotation(anotacion)
    }


}

extension VistaDetalladaViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil
        }

        var anotationView = mapa.dequeueReusableAnnotationView(withIdentifier: "custom")

        if anotationView == nil {
            anotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            anotationView?.annotation = annotation
        }
        anotationView?.image = UIImage(named: "co2")
//        anotationView?.image = UIImage(systemName: "mappin.and.ellipse")
        anotationView?.displayPriority = .defaultHigh
        anotationView?.canShowCallout = true
        
        return anotationView
    }
}

extension VistaDetalladaViewController: historialPaisProtocol {
    func cargarDatos(datos: [PaisDatos]) {
        
        lat = Double(datos[0].Lat)
        lon = Double(datos[0].Lon)
        
        
        self.setupMap()

        
    }
    
    
}
