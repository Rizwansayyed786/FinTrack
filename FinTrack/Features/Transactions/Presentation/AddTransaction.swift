//
//  AddTransaction.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 18/09/26.
//
import SwiftUI
struct AddTransaction : View{
    @State private var amount = ""
    var body: some View{
        VStack{
            AddTransactionHeader()
            TextField("Email",text: $amount)
                .frame(maxWidth:.infinity)
                .padding(16)
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16)).keyboardType(.emailAddress)
            TextField("Email",text: $amount)
                .frame(maxWidth:.infinity)
                .padding(16)
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16)).keyboardType(.emailAddress)
            TextField("Email",text: $amount)
                .frame(maxWidth:.infinity)
                .padding(16)
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16)).keyboardType(.emailAddress)
        }.padding(16).frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
    }
}

struct AddTransactionHeader : View{
    @State var selection : Int = 0
    var body: some View{
        HStack{
            Text("Expense")
                .padding(.horizontal,16)
                .padding(.vertical,8)
                .foregroundColor(selection == 0 ? .white : .black)
                .background(selection == 0 ? .black : .white).clipShape(RoundedRectangle(cornerRadius: 10)).onTapGesture {
                        self.selection = 0
                }
            Text("Income")
                .padding(.horizontal,16)
                .padding(.vertical,8)
                .foregroundColor(selection == 1 ? .white : .black)
                .background(selection == 1 ? .black : .white).clipShape(RoundedRectangle(cornerRadius: 10)).onTapGesture {
                    self.selection = 1
            }
        }
    }
}

#Preview {
    AddTransaction()
}
