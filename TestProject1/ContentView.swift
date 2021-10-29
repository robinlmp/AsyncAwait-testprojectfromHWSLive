//
//  ContentView.swift
//  TestProject1
//
//  Created by Robin Phillips on 02/08/2021.
//

import SwiftUI

extension URLSession {
    func decode<T: Decodable>(
        _ type: T.Type = T.self,
        from url: URL,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
    ) async throws -> T {
        let (data, _) = try await data(from: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        
        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }
}

struct Petition: Codable, Identifiable {
    let id: String
    let title: String
    let signatureCount: Int
    let signatureThreshold: Int
    

    
}

let colours = [
    Color.red,
    Color.blue,
    Color.pink,
    Color.green,
    Color.yellow
    
]

let frameRatio = 0.9
let frameSize: Double = 250
let threshold: Double = 100000



struct ContentView: View {
    @State private var petitions = [Petition]()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(petitions) { petition in
                    ZStack {
                        
                        Rectangle()
                            .foregroundColor(Color.gray)
                            //.backgroundColor(colours.randomElement())
                            .frame(width: frameSize, height: frameSize)
                            .clipShape(Circle())
                        
                        Rectangle()
                            .foregroundColor(colours.randomElement())
                            //.backgroundColor(colours.randomElement())
                            .frame(width: ((frameSize / threshold) * Double (petition.signatureCount)), height: ((frameSize / threshold) * Double (petition.signatureCount)))
                            .clipShape(Circle())
                        
                        VStack {
                            Text("\(petition.title): ").bold()
                                .foregroundColor(.white)
                                .padding()
                            
                            Text("\(petition.signatureCount)")
                            
                        }
                        .frame(width: (frameSize * frameRatio), height: (frameSize * frameRatio))
                        
                    }
                    
                }
            }
            
            .navigationTitle("Petitions")
            .task {
                do {
                    petitions = try await fetchPetitions()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchPetitions() async throws -> [Petition] {
        var petitionsURL = URL(string: "https://hws.dev/petitions.json")!
        //var petitionsURL = URL(string: "​https://hws.dev/petitions.json")!
        return try await URLSession.shared.decode(from: petitionsURL)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
