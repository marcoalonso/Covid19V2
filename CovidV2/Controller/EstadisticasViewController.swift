//
//  ViewController.swift
//  CovidV2
//
//  Created by marco rodriguez on 06/08/22.
//

import UIKit

class EstadisticasViewController: UIViewController {
    
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var nuevasMuertes: UILabel!
    @IBOutlet weak var totalRecuperados: UILabel!
    @IBOutlet weak var nuevosRecuperados: UILabel!
    @IBOutlet weak var totalMuertes: UILabel!
    @IBOutlet weak var totalConfirmados: UILabel!
    @IBOutlet weak var nuevosConfirmados: UILabel!
    
    @IBOutlet weak var searchPais: UISearchBar!
    @IBOutlet weak var tablaPaises: UITableView!
    
    
    var covidManager = CovidManager()
    var listaPaises: [CountriesStats] = []
    
    var paisVisualizar: CountriesStats?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        covidManager.delegado = self
        searchPais.delegate = self
        tablaPaises.delegate = self
        tablaPaises.dataSource = self
        
        covidManager.buscarEstadisticas()
    }


}

// MARK: - SearchBar
extension EstadisticasViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Filtrar elementos")
    }
}

// MARK: - UITableView
extension EstadisticasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaPaises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaPaises.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        celda.textLabel?.text = listaPaises[indexPath.row].Country
        celda.detailTextLabel?.text = "Total de casos: \(listaPaises[indexPath.row].TotalConfirmed) "
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaPaises.deselectRow(at: indexPath, animated: true)
        paisVisualizar = listaPaises[indexPath.row]
        
        performSegue(withIdentifier: "paisCovid", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paisCovid" {
            let verPais = segue.destination as! VistaDetalladaViewController
            verPais.paisCovid = paisVisualizar
        }
    }
    
}

extension EstadisticasViewController: covidManagerProtocol {
    func cargarDatos(datos: CovidDatos) {
        DispatchQueue.main.async {
            
            self.nuevosConfirmados.text = "Nuevos casos: \(datos.Global.NewConfirmed)"
            self.nuevasMuertes.text = "Muertes hoy: \(datos.Global.NewDeaths)"
            self.nuevosRecuperados.text = "Nuevos recuperados: \(datos.Global.NewRecovered)"
            
            self.totalRecuperados.text = "Recuperados hoy: \(datos.Global.TotalRecovered)"
            self.totalMuertes.text = "Total de muertes: \(datos.Global.TotalDeaths)"
            
            let totalConfirmadosStyle = String(format: "%d", locale: Locale.current, datos.Global.TotalConfirmed)
            
            self.totalConfirmados.text = "Total de casos: \(totalConfirmadosStyle)"
            self.fecha.text = "Fecha: \(datos.Global.Date)"
            
            //TableView
            self.listaPaises = datos.Countries
            self.tablaPaises.reloadData()
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
