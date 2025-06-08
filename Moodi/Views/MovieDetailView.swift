//
//  MovieDetailView.swift
//  Moodi
//
//  Created by Maria Amzil on 8/6/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movieId: Int

    @State private var detail: MovieDetail?
    @State private var providers: ProvidersByCountry?
    @State private var isLoading = true

    var body: some View {
        ZStack {
            Color.terciaryColor
                        .ignoresSafeArea()
            ScrollView {
             
                if isLoading {
                    ProgressView("Loading...")
                        .padding(.top, 100)
                } else if let detail = detail {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(detail.title)
                            .font(.custom("Poppins-SemiBold", size:30))

                        if let date = detail.release_date {
                            Text("\(formattedDate(date))")
                                .font(.custom("Poppins-Regular", size:14))
                        }

                        if let runtime = detail.runtime {
                            Text("\(runtime) min")
                                .font(.custom("Poppins-Regular", size:14))
                        }

                        if !detail.genres.isEmpty {
                            Text("Genres: \(detail.genres.map(\.name).joined(separator: ", "))")
                                .font(.custom("Poppins-Regular", size:14))
                        }

                        Divider()

                        Text(detail.overview)
                            .font(.custom("Poppins-Light", size:16))

                        Divider()

                        if let providers = providers {
                            Text("Available to watch it at:")
                                .font(.custom("Poppins-SemiBold", size:16))

                            if let flatrate = providers.flatrate {
                                providerSection("Streaming", flatrate)
                            }
                            if let rent = providers.rent {
                                providerSection("Rent", rent)
                            }
                            if let buy = providers.buy {
                                providerSection("Buy", buy)
                            }
                        } else {
                            Text("There is no information about where to watch it.")
                               
                        }
                    }
                    .foregroundColor(Color.textColor)
                    .padding()
                } else {
                    Text("The information couldn't be loaded.")
                        .foregroundColor(Color.textColor)
                        .font(.custom("Poppins-Regular", size:14))
                }
                
            }
        }
        
        .onAppear(perform: loadAllData)
      
    }

    @ViewBuilder
    func providerSection(_ title: String, _ list: [Provider]) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(list, id: \.provider_id) { prov in
                        VStack {
                            if let logo = prov.logo_path,
                               let url = URL(string: "https://image.tmdb.org/t/p/w92\(logo)") {
                                AsyncImage(url: url) { img in
                                    img.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            } else {
                                Color.gray.frame(width: 60, height: 60)
                            }
                            
                            Text(prov.provider_name)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 80)
                    }
                }
            }
        }
    }

    func loadAllData() {
        Task {
            async let d: () = fetchDetail()
            async let p: () = fetchProviders()
            _ = await (d, p)
            isLoading = false
        }
    }

    func fetchDetail() async {
        let urlStr = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(Secrets.tmdbApiKey)&language=en-US"
        guard let url = URL(string: urlStr),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let decoded = try? JSONDecoder().decode(MovieDetail.self, from: data) else {
            return
        }
        detail = decoded
    }

    func fetchProviders() async {
        let urlStr = "https://api.themoviedb.org/3/movie/\(movieId)/watch/providers?api_key=\(Secrets.tmdbApiKey)"
        guard let url = URL(string: urlStr),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let decoded = try? JSONDecoder().decode(WatchProvidersResponse.self, from: data)
             else {
            return
        }
        
        let userCountryCode = Locale.current.region?.identifier ?? "US"
        let countryProviders = decoded.results[userCountryCode] ?? decoded.results["US"]

        providers = countryProviders
    }

    func formattedDate(_ dateString: String) -> String {
        let df = DateFormatter(); df.dateFormat = "yyyy-MM-dd"
        let df2 = DateFormatter(); df2.dateStyle = .medium
        if let d = df.date(from: dateString) { return df2.string(from: d) }
        return dateString
    }
}


#Preview {
    MovieDetailView(movieId: 1)
}
