//
//  SpotifyHomeView.swift
//  SwiftUiPractice
//
//  Created by mohammed on 30/10/2024.
//

import SwiftUI
import SwiftfulUI

struct SpotifyHomeView: View {
    
    @State private var currentUser: User? = nil
    @State private var selectedCategory: Category? = nil
    @State private var products: [Product] = []
    @State private var productRows: [ProductRow] = []
    
    var body: some View {
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()
            ScrollView(.vertical) {
                
                LazyVStack(spacing: 1, pinnedViews: [.sectionHeaders]) {
                    Section {
                        
                        VStack(spacing:16){
                            recentSections
                                .padding(.horizontal , 16)
                            if let product = products.first {
                                newReleasesSection(product: product)
                                    .padding(.horizontal , 16)
                            }
                            
                            listRows
                            
                        }
                        
                                                
                    } header: {
                        header
                    }

                }
                .padding(.top , 8)
            }
            .scrollIndicators(.hidden)
            .clipped()
            
        }
        .task {
            await getData()
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
    
    private func getData() async {
        do{
            currentUser = try await DatabaseHelper().getUsers().first
            products = try await Array(DatabaseHelper().getProducts().prefix(8))
            
            var rows: [ProductRow] = []
            let allBrands = Set(products.map { $0.brand })
            
            for brand in allBrands {
//                let products = self.products.filter({$0.brand == brand})
                rows.append(ProductRow(title: brand?.capitalized ?? "", products: products))
            }
            
            productRows = rows
            
        } catch {
            
        }
    }
    
    private var header : some View {
        HStack(spacing:0) {
            ZStack{
                if let currentUser {
                    ImageLoaderView(urlString: currentUser.image)
                        .background(.spotifyWhite)
                        .clipShape(Circle())
                        .onTapGesture {
                            
                        }
                }
            }
            .frame(width: 35 , height: 35)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Category.allCases , id: \.self) { category in
                        
                        SpotifyCategoryCell(title: category.rawValue.capitalized ,isSelected: category == selectedCategory)
                            .onTapGesture {
                                selectedCategory = category
                            }
                    }
                }
                .padding(.horizontal , 16)
            }.scrollIndicators(.hidden)
            
        }
        .padding(.vertical , 24)
        .padding(.leading , 8)
        .background(.spotifyBlack)

    }
    
    private var recentSections : some View {
        NonLazyVGrid(columns: 2, alignment: .center, spacing: 10, items: products) { product in
            if let product {
                SpotifyRecentsCell(imageName: product.firstImage , title: product.title)
                    .asButton(.press) {
                        
                    }
            }
        }
    }
    
    private func newReleasesSection(product:Product) -> some View {
        SpotifyNewReleaseCell(
            imageName: product.firstImage,
            headline: product.brand,
            subheadline: product.category,
            title: product.title,
            subtitle: product.description) {
                
            } onPlayPressed: {
                
            }
    }
    
    private var listRows : some View {
        ForEach(productRows) { row in
            VStack(spacing:8){
                Text(row.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.spotifyWhite)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal , 16)
                
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing:16) {
                        ForEach(row.products) { product in
                            ImageTitleRowCell(
                                imageSize: 120,
                                imageName: product.firstImage,
                                title: product.title
                            )
                            .asButton(.press) {
                                
                            }
                        }
                    }
                    .padding(.horizontal , 16)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    SpotifyHomeView()
}
