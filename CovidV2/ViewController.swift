//
//  ViewController.swift
//  CovidV2
//
//  Created by marco rodriguez on 06/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var nuevasMuertes: UILabel!
    @IBOutlet weak var totalRecuperados: UILabel!
    @IBOutlet weak var nuevosRecuperados: UILabel!
    @IBOutlet weak var totalMuertes: UILabel!
    @IBOutlet weak var totalConfirmados: UILabel!
    @IBOutlet weak var nuevosConfirmados: UILabel!
    
    var covidManager = CovidManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        covidManager.delegado = self
        
        covidManager.buscarEstadisticas()
    }


}

extension ViewController: covidManagerProtocol {
    func cargarDatos(datos: CovidDatos) {
        DispatchQueue.main.async {
            self.nuevosConfirmados.text = "Nuevos casos: \(datos.Global.NewConfirmed)"
            self.nuevasMuertes.text = "Muertes hoy: \(datos.Global.NewDeaths)"
            self.totalRecuperados.text = "Recuperados hoy: \(datos.Global.TotalRecovered)"
            self.nuevosRecuperados.text = "Nuevos recuperados: \(datos.Global.NewRecovered)"
            self.totalMuertes.text = "Total de meurtes: \(datos.Global.TotalDeaths)"
            self.totalConfirmados.text = "Total de casos confirmados: \(datos.Global.TotalConfirmed)"
            
            
            self.fecha.text = "Fecha: \(datos.Global.Date)"
        }
    }
    
    func huboError(cualError: Error) {
        
        DispatchQueue.main.async {
            let alerta = UIAlertController(title: "ERROR", message: "\(cualError.localizedDescription)", preferredStyle: .alert)
            let accionCancelar = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            alerta.addAction(accionCancelar)
            self.present(alerta, animated: true)
        }
       

    }
    
    
}
