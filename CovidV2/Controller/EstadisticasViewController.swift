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
    
    //Un arreglo para filtrar los paises
    var paisesFiltrados: [CountriesStats] = []
    
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
        paisesFiltrados = []
        
        if searchText == "" {
            paisesFiltrados = listaPaises
        } else {
            for pais in listaPaises {
                if pais.Country.lowercased().contains(searchText.lowercased()) {
                    paisesFiltrados.append(pais)
                }//if pais
            }//for
        }//else
        
        //neceisto actualizar la tabla constantemente
        self.tablaPaises.reloadData()
    }
}

// MARK: - UITableView
extension EstadisticasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paisesFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaPaises.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        celda.textLabel?.text = paisesFiltrados[indexPath.row].Country
        celda.detailTextLabel?.text = "Total de casos: \(paisesFiltrados[indexPath.row].TotalConfirmed) "
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaPaises.deselectRow(at: indexPath, animated: true)
        paisVisualizar = paisesFiltrados[indexPath.row]
        
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
            
            let strFecha = self.dateFormatter(fecha: datos.Global.Date)
            print(datos.Global.Date)
            self.fecha.text = "Fecha: \(strFecha)"
            
            //TableView
            self.listaPaises = datos.Countries
            self.paisesFiltrados = self.listaPaises
            self.tablaPaises.reloadData()
        }
    }
    
    func dateFormatter(fecha: String) -> String {
        // fecha de ejemplo
         //let isoDate = "2016-04-14T10:44:00.209z"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm.ss.SSSz"
        let date = dateFormatter.date(from:fecha)!
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
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
