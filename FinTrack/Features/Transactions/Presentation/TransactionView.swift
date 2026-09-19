//
//  TransactionView.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 16/09/26.
//
import SwiftUI
struct TransactionTab : View {
    var body: some View {
        VStack {
            TransactionHeader()
            TransactionList()
        }.padding(16).frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
    }
}

struct TransactionHeader : View {
    var tabs : [String] = ["All","Income","Expense"]
    @State var selection : Int = 0
    var body : some View{
        VStack {
            ZStack(){
                Text("Transaction")
                    .font(.title)
                    .fontWeight(.bold)
                HStack{
                    Image(systemName: "magnifyingglass").font(.system(size: 20, weight: .bold, design: .default)).foregroundStyle(.black)
                    Image(systemName: "line.3.horizontal.decrease").foregroundStyle(.black)
                }.frame(maxWidth: .infinity , alignment: .trailing)
            }.padding(16)
            HStack{
                ForEach(tabs.indices,id: \.self){ index in
                    Text(tabs[index]).font(.title2).foregroundStyle(
                        selection == index ? .white : .primary
                    ).padding(.horizontal,25).padding(.vertical,6).background(
                        selection == index ? .black : .white
                    ).clipShape(RoundedRectangle(cornerRadius: 10)).onTapGesture {
                        selection = index
                    }
                }
            }.frame(maxWidth: .infinity , alignment: .leading)
        }
    }
}

struct TransactionList : View{
    var body : some View{
        ScrollView{
            ForEach(0..<25,id: \.self) { index in
                HStack{
                    Image(systemName: "suitcase.circle.fill")
                    VStack{
                        Text("Salary")
                        Text("Income")
                    }
                    Spacer()
                    VStack{
                        Text("+ $75000")
                        Text("10 May 2024")
                    }
                }.padding(16)
            }
        }
    }
}

#Preview {
    TransactionTab()
}


