//
//  ProfileView.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 09/09/26.
//
import Foundation
import SwiftUI
struct ProductView: View {

    @State private var products: [ProductDTO] = []
    @State private var total: Int = 0
    @State private var isLoadingFirstPage = false
    @State private var isLoadingMore = false
    @State private var errorMessage: String?
    @State private var loadMoreError: String?

    private var hasMorePages: Bool { products.count < total }

    var body: some View {
        Group{
            if isLoadingFirstPage {
                ProgressView("Loading products...")
            }else if let errorMessage, products.isEmpty {
                VStack(spacing: 12) {
                    Text(errorMessage)
                    Button("Retry") {
                        Task { await loadFirstPage() }
                    }
                }
            }else if products.isEmpty {
                Text("No products")
            }else{
                List {
                    ForEach(products, id: \.id) { product in
                        NavigationLink(
                            value: ProductRoute.productDetails(product: product)
                        ){
                            HStack{
                                VStack(alignment: .leading,) {
                                    Text(product.title)
                                     Text("$\(product.price)")
                                }
                                Spacer()
                                AsyncImageComponent(thumbnail: product.thumbnail,size: 100)
                            }
                        }
                        .onAppear {
                            // Reaching the last row pulls the next page.
                            guard product.id == products.last?.id else { return }
                            Task { await loadNextPage() }
                        }
                    }

                    listFooter
                }
            }
        }.task {
            await loadFirstPage()
        }.navigationDestination(for: ProductRoute.self) { route in
            switch route {
            case .productDetails(let product):
                ProductDetails(product: product)
            }
        }

    }

    /// Spinner while paging, a retry affordance if a page failed, and a final
    /// count once everything is in.
    @ViewBuilder
    private var listFooter: some View {
        if isLoadingMore {
            ProgressView()
                .frame(maxWidth: .infinity)
        } else if let loadMoreError {
            VStack(spacing: 8) {
                Text(loadMoreError)
                    .font(.caption)
                    .foregroundStyle(.red)
                Button("Retry") {
                    Task { await loadNextPage() }
                }
            }
            .frame(maxWidth: .infinity)
        } else if !hasMorePages {
            Text("All \(total) products loaded")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
        }
    }

    func loadFirstPage() async {
        // `.task` runs again when the tab is revisited — don't refetch page 1.
        guard products.isEmpty, !isLoadingFirstPage else { return }

        isLoadingFirstPage = true
        errorMessage = nil

        do{
            let response = try await loadMore(skip: 0)
            products = response.products
            total = response.total
        }catch {
            errorMessage = error.localizedDescription
        }

        isLoadingFirstPage = false
    }

    func loadNextPage() async {
        guard !isLoadingMore, !isLoadingFirstPage, hasMorePages else { return }

        isLoadingMore = true
        loadMoreError = nil

        do{
            let response = try await loadMore(skip: products.count)
            // Guard against duplicate ids: a repeated row would make ForEach
            // render incorrectly and could wedge the pager on the same page.
            let seen = Set(products.map(\.id))
            products.append(contentsOf: response.products.filter { !seen.contains($0.id) })
            total = response.total
        }catch {
            loadMoreError = error.localizedDescription
        }

        isLoadingMore = false
    }
}


func loadMore(skip : Int) async throws -> ProductsResponseDTO {
    let limit : Int = 10
    let url = URL(
        string: "https://dummyjson.com/products?limit=\(limit)&skip=\(skip)"
    )!

    print("🚀 API REQUEST")
    let (data, response) =
        try await URLSession.shared.data(from: url)

    if let httpResponse = response as? HTTPURLResponse {
        print("Status:", httpResponse.statusCode)
    }
    
    print("Response body:")
    print(String(data: data, encoding: .utf8) ?? "Unable to convert data")

    return try JSONDecoder().decode(
        ProductsResponseDTO.self,
        from: data
    )
}


struct ProductDTO: Decodable ,Equatable, Hashable{
    let id: Int
    let title: String
    let description: String
    let price: Double
    let rating: Double
    let stock: Int
    let brand: String?
    let thumbnail: String
}

struct ProductsResponseDTO: Decodable {
    let products: [ProductDTO]
    let total: Int
    let skip: Int
    let limit: Int
}


struct ProductDetails : View {
    var product : ProductDTO
    @Environment(NavigationManager.self) private var navigation
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImageComponent(thumbnail: product.thumbnail, size: 300).frame(maxWidth: .infinity, alignment: .center)
           Text(product.title)
           Text("\(product.price)")
           Text(product.description)
            
            Button("Go TO Home") {
                navigation.popToRoot(.home)
            }
        }.padding(16).frame(maxWidth: .infinity, maxHeight: .infinity).navigationTitle("Product Details")
    }
}
