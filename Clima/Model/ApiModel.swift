import Foundation

protocol DidChangeApiDataModelProtocol {
    func liveDateFromApi(_ dataModel : ApiDataModel )
    func errorData(_ error:Error)
}



struct ApiModel {
    
    var delegate: DidChangeApiDataModelProtocol?
    
    
    func apiCallWithCity(city:String)  {
        let apiUri = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=3c1d69ed27224b9c819cd2496e55ddf1"
        apiReq(apiUri)
    }
    func apiCallWithLanLong(lat latittude:Double, long longitude:Double)  {
        let apiUri = "https://api.openweathermap.org/data/2.5/weather?lat=\(latittude)&lon=\(longitude)&appid=3c1d69ed27224b9c819cd2496e55ddf1"
        apiReq(apiUri)
    }
    
    func apiReq(_ apiUrl: String) {
        if let uri = URL(string: apiUrl){
            let uriSession =   URLSession(configuration: .default)
            
            let task =  uriSession.dataTask(with: uri) { data, response, error in
                if error != nil {
                    self.delegate?.errorData(error!)
                    return
                }
                if data != nil{
                    if let getData = self.decodeDataApi(apiData: data!){
                        self.delegate?.liveDateFromApi(getData)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func decodeDataApi(apiData: Data)  -> ApiDataModel? {
        let decoder = JSONDecoder()
        do{
            let dataDecoded = try  decoder.decode(WeatherModel.self, from: apiData)
            let id = dataDecoded.weather[0].id
            let temp = dataDecoded.main.temp
            let name = dataDecoded.name
            let weather = ApiDataModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            self.delegate?.errorData(error)
            return nil
        }
        
    }
    
    
}
