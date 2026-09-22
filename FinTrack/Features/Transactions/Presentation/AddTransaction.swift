//
//  AddTransaction.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 18/09/26.
//
import SwiftUI
struct AddTransaction : View{
    @State private var amount = ""
    @State private var category = ""
    @State private var date = ""
    @State private var payment = ""
    @State private var note = ""

    var body: some View{
        VStack(spacing : 30){
            AddTransactionHeader()	
            FloatingTextField(
                title: "Amount",
                text: $amount
            )
            FloatingTextField(title: "Category", iconName: "chevron.down",text: $category)
            FloatingTextField(title: "Date",iconName: "calendar",text: $date,)
            FloatingTextField(title: "Payment Method", iconName: "indianrupeesign", text: $payment)
            
            FloatingTextArea(title: "Note(Optional)", text: $note)
               
            Spacer()
            Button("Save Transaction"){
            }.frame(maxWidth: .infinity).padding(16).foregroundStyle(.white).background(.black).cornerRadius(16)
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


struct FloatingTextField: View {
    let title: String
    let iconName : String?
    @Binding var text: String

    init(title: String, iconName: String? = nil, text:Binding<String>) {
        self.title = title
        self.iconName = iconName
        self._text = text
      
    }
    @FocusState private var isFocused: Bool

    private var shouldFloat: Bool {
        isFocused || !text.isEmpty
    }

    var body: some View {
        ZStack(alignment: .leading) {

            // Border
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    isFocused ? .blue : .gray,
                    lineWidth: 1
                )

            

            HStack(spacing: 8){
                // Text input
                TextField("", text: $text)
                    .focused($isFocused)
                    .padding(.horizontal, 16)
                if let iconName{
                    Image(systemName: iconName)
                        .padding(.trailing, 16)
                    
                }
                
            }
            
            // Floating label
            Text(title)
                .font(.caption)
                .foregroundStyle(isFocused ? .blue : .gray)
                .padding(.horizontal, 4)
                .background(.white)
                .offset(
                    x: 12,
                    y: shouldFloat ? -20 : 0
                )
                .animation(.easeInOut(duration: 0.2), value: shouldFloat)
        }.frame(height: 56)
        
    }
}


struct FloatingTextArea : View {
    let title: String
    @Binding var text: String
    @FocusState private var isFocused: Bool

    private var shouldFloat: Bool {
        isFocused || !text.isEmpty
    }
    
    var body: some View{
        ZStack(alignment: .topLeading){
            
            // Border
            RoundedRectangle(cornerRadius: 10).stroke(isFocused ? .blue : .gray,lineWidth: 1)
            
            //text editor
            TextEditor(text: $text)
                .focused($isFocused)
                .padding(.horizontal,16).padding(.top,30)
            
            // Floating label
            Text(title)
                .font(.caption)
                .foregroundStyle(isFocused ? .blue : .gray)
                .padding(.horizontal, 4)

                .offset(
                    x: 12,
                    y: shouldFloat ? 10 : 20
                )
                .animation(.easeInOut(duration: 0.2), value: shouldFloat).frame(alignment : .topLeading)
        }

    }
        
}

#Preview{
    AddTransaction()
}


