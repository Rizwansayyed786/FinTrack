//
//  HomeView.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 05/09/26.
//
import SwiftUI
struct HomeView : View
{
    var body: some View
    {
        ZStack(alignment: .top){
            // Background
        Color(hex: "0D182A")
            .frame(height: 200)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 30,
                    bottomTrailingRadius: 30,
                    topTrailingRadius: 0
                )
            )
            .ignoresSafeArea(edges: .top)
            VStack(spacing: 20,){
                Header()
                BalanceCard()
                QucikActions()
                SpendingOverView()
            }.padding(16)
        }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top).background(Color.gray.opacity(0.2))
    }
}


struct Header : View{
    var body : some View{
        HStack()
        {
            VStack(alignment : .leading){
                Text("Hello, Rizwan!")
                    .font(.title)
                    .foregroundColor(.white)
                Text("Welcome Back")
                    .font(.body)
                    .foregroundColor(.white)
            }
            Spacer()
            Image(systemName: "bell").font(.system(size: 25)).foregroundColor(.white)
        }
    }
}

struct BalanceCard : View{
    var body : some View{
        HStack{
            VStack(alignment : .leading){
                Text("Total Balance")
                .font(.title2)
                    .foregroundColor(.black)
                Text("$1,000.00")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            Spacer()
            VStack{
                HStack{
                    Image(systemName: "arrow.up").font(Font.system(size: 20, weight: .bold)).foregroundColor(.green)
                    Text("12.5%")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                Text("vs last month")
                    .font(.title3)
                    .foregroundColor(.black)
            }
        }.padding(24).frame(maxWidth: .infinity).background(Color(.white)).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct QuickActionItem : Hashable{
    let title : String
    let icon : String
}

struct QucikActions : View{
    var items : [QuickActionItem] = [
        QuickActionItem(title: "Add Transaction", icon: "plus"),
        QuickActionItem(title: "Send Money", icon: "paperplane.fill"),
        QuickActionItem(title: "Categories", icon: "contextualmenu.and.cursorarrow"),
        QuickActionItem(title: "Reports", icon: "receipt"),
        QuickActionItem(title: "Categories", icon: "plus"),
        QuickActionItem(title: "Reports", icon: "plus"),
    ]
    var body : some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(alignment: .top,spacing: 8){
                ForEach(items,id: \.self) { item in
                    QuicAction(title: item.title, icon: item.icon).frame(width: 80)
                }
            }
        }.padding(24)
            .fixedSize(horizontal: false, vertical: true)
            .background(.white).clipShape(RoundedRectangle(cornerRadius: 16)).shadow(radius: 4,y: 2)
    }
}

struct QuicAction : View {
    var title : String
    var icon : String
    
    var body: some View {
        VStack(spacing : 8){
            Image(systemName: icon).font(.system(size: 30, weight: .bold)).frame(width: 70,height:  70).foregroundColor(.green).background(Color.gray.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 16))
            Text(title)
                .font(.caption)
                .foregroundColor(Color.black).frame(width: 80)
                .multilineTextAlignment(.center)

        }
    }
}

struct SpendingOverViewModel : Identifiable{
    var id : String
    var title : String
    var value : String
    var color : Color
}

struct SpendingOverView : View{
    var overviews : [SpendingOverViewModel] = [
        SpendingOverViewModel(id: "1", title: "Income", value: "28%", color: .green),
        SpendingOverViewModel(id: "2", title: "Expenses", value: "50%", color: .red),
        SpendingOverViewModel(id: "1", title: "Income", value: "28%", color: .green),
        SpendingOverViewModel(id: "2", title: "Expenses", value: "50%", color: .red),
        SpendingOverViewModel(id: "1", title: "Income", value: "28%", color: .green),
        SpendingOverViewModel(id: "2", title: "Expenses", value: "50%", color: .red),
    ]
    var body : some View{
        VStack{
            HStack
            {
                Text("Spedning Overview")
                    .font(.title3)
                    .bold()
                Spacer()
                HStack{
                    Text("View All")
                        .font(.caption)
                    Image(systemName: "chevron.down").font(.caption).foregroundColor(.black)
                }
            
            }
            
            HStack{
                Text("").frame(maxWidth: .infinity)
                Spacer()
                VStack{
                    ForEach(overviews) { overview in
                        HStack{
                            Circle().fill(overview.color).frame(width: 10, height: 10)
                            Text(overview.title)
                                .font(.caption)
                            Spacer()
                            Text(overview.value)
                                .font(.caption)
                        }
                    }
                    
                }.frame(maxWidth: .infinity)
            }
            
            
        }.padding(24)
            .fixedSize(horizontal: false, vertical: true)
            .background(.white).clipShape(RoundedRectangle(cornerRadius: 16)).shadow(radius: 4,y: 2)
    }
}
#Preview {
    HomeView()
}
