//
//  storeKitView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 24.07.2021.
//

import SwiftUI

struct storeKitView: View {
    @ObservedObject var store: StoreKit
    @Binding var showInAppPurchase: Bool
    var body: some View {
    
            
        VStack (alignment: .leading){
            
            Text("Нравится приложение?".localized)
                .font(.callout)
                .padding(.leading)
            
            ForEach(store.allRecipes, id: \.self) { recipe in
                
                Button(action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        store.purchaseTapped = true
                    }
                
                    if let product = store.product(for: recipe.id) {
                        store.purchaseProduct(product)
                    }
                }, label: {
                    HStack{
                        VStack {
                            if recipe.isLocked {
                                HStack{
                                    ZStack{
                              
                                        ProgressView()
                                            .zIndex(1)
                                            .padding()
                                            .scaleEffect(1.5)
                                            .opacity(store.purchaseTapped ? 1 : 0)
                                        
                                    Text("✅")
                                        .font(.title)
                                        .padding()
                                        .opacity(store.purchaseTapped ? 0.1 : 1)
                                    
                                    }
                                    
                                    VStack {
                                        Text(recipe.titile)
                                            .font(.title2)
                                        
                                        Text(recipe.description)
                                            .font(.caption2)
                                    }
                                    
                                    Spacer()
                                    
                                    if let price = recipe.price, recipe.isLocked {
                                        Text(price)
                                            .foregroundColor(Color("back"))
                                            .padding(10)
                                            .background(Color.primary)
                                            .cornerRadius(9)
                                    }
                                }
                                .padding(.trailing)
                               
                            } else {
                                Text("Спасибо за поддержку!".localized)
                                    .font(.subheadline)
                                    .padding()
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation{
                                                showInAppPurchase = false
                                            }
                                        }
                                    }
                            }
                        }
                    }
                })
            }
            .onAppear{
                store.loadStoredPurchases()
            }
            
            Spacer()
            
        }
    }
}

struct storeKitView_Previews: PreviewProvider {
    static var previews: some View {
        storeKitView(store: StoreKit(), showInAppPurchase: .constant(true))
    }
}
