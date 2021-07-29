//
//  storeKitView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 24.07.2021.
//

import SwiftUI

struct RecipeRow: View {
    @Binding var showInAppPurchase: Bool
    let recipe: Recipe
    let action: () -> ()
    
    var body: some View{
        VStack{
            
            if recipe.isLocked {
                HStack{
                    Text("☕️")
                        .font(.largeTitle)
                        .padding()
                    
                    VStack {
                        Text(recipe.titile)
                            .font(.title)
                        
                        Text(recipe.description)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    if let price = recipe.price, recipe.isLocked {
                        
                        Text(price)
                            .foregroundColor(Color("back"))
                            .padding()
                            .background(Color.primary)
                            .cornerRadius(9)
                    }
                }
                .padding(.trailing)
                .onTapGesture {
                    action()
                }
            } else {
                Text("Спасибо за поддержку".localized)
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
}


struct storeKitView: View {
    @EnvironmentObject var store: StoreKit
    @Binding var showInAppPurchase: Bool
    var body: some View {
        VStack (alignment: .leading){
            
            Text("Нравится приложение?".localized)
                .font(.callout)
                .padding(.leading)
        
            ForEach(store.allRecipes, id: \.self) { recipe in
                HStack{
                    RecipeRow(showInAppPurchase: $showInAppPurchase, recipe: recipe) {
                        
                            if let product = store.product(for: recipe.id) {
                                store.purchaseProduct(product)
                            }
                            
                        }
                    }
                
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
        storeKitView(showInAppPurchase: .constant(true))
            .environmentObject(StoreKit())
    }
}
