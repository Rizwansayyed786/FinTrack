//
//  Untitled.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 20/09/26.
//
import SwiftUI
struct CategoriesView : View {
    var body: some View {
        VStack(spacing : 20){
           CategoriesHeader()
           Categories()
            Spacer()
           AddCategory()
       }.padding(16).frame(maxWidth : .infinity,maxHeight : .infinity, alignment: .init(horizontal: .center, vertical: .top))
    }
}


struct CategoriesHeader : View {
    @State var selection : Int = 0
    var body: some View{
        HStack{
            Text("Expense")
                .padding(.horizontal,16)
                .padding(.vertical,8)
                .frame(maxWidth: .infinity)
                .foregroundColor(selection == 0 ? .white : .black)
                .background(selection == 0 ? .black : .clear).clipShape(RoundedRectangle(cornerRadius: 10)).onTapGesture {
                        self.selection = 0
                }.frame(maxWidth: .infinity)
            Text("Income")
                .padding(.horizontal,16)
                .padding(.vertical,8)
                .frame(maxWidth: .infinity)
                .foregroundColor(selection == 1 ? .white : .black)
                .background(selection == 1 ? .black : .clear).clipShape(RoundedRectangle(cornerRadius: 10)).onTapGesture {
                    self.selection = 1
            }
        }.padding(8).background(.gray.opacity(0.2)).cornerRadius(16)
    }
}

struct CategoryItem : Hashable{
    let name : String
    let color : Color
    let icon : String
}

struct Categories : View {
    @State var categoryItems : [CategoryItem] = [
        .init(name: "Food & Dinning", color: .orange, icon: "fork.knife"),
        .init(name: "Shoping", color: .pink, icon: "cart"),
        .init(name: "Transport", color: .blue, icon: "bus"),
        .init(name: "Bills & Utilities", color: .green, icon: "receipt"),
        .init(name: "Eduacation", color: .purple, icon: "graduationcap"),
    ]
    
    var body: some View{
        VStack(spacing: 16){
            ForEach(categoryItems, id: \.self){ item in
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 16).fill(item.color).frame(width: 40, height: 40)
                        if item.icon.isEmpty {
                            Image(systemName: "tray").font(.system(size: 20))
                        } else {
                            Image(systemName: item.icon).font(.system(size: 20))
                        }
                    }
                    Text(item.name)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
        }
    }
}

struct AddCategory : View {
    var body: some View{
        HStack(spacing : 8){
            Image(systemName: "plus").font(.system(size: 20))
            Text("Add Category")
        }.padding(16).frame(maxWidth: .infinity).border(Color.gray, width: 1).clipShape(RoundedRectangle(cornerRadius: 16)).overlay(RoundedRectangle(cornerRadius : 16).stroke(.gray))
    }
}
#Preview {
    CategoriesView()
}
