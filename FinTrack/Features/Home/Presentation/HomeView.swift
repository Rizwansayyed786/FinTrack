//
//  HomeView.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 05/09/26.
//
import SwiftUI
import Charts

struct HomeView : View
{
    @State private var viewModel : HomeViewModel
    init(viewModel: HomeViewModel){
        self.viewModel = viewModel
    }
    
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
                
                if viewModel.state.isLoading{
                    ProgressView()
                }else if let dasboard = viewModel.state.dashboard{
                    Header(userName : dasboard.name)
                    BalanceCard(balance: dasboard.balance)
                    ScrollView{
                        QucikActions()
                        SpendingOverView(overviews: dasboard.spendingOverview)
                        RecentTransactions(transactions: dasboard.transactions)
                    }
                }
            }.padding(16)
        }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top).background(Color.gray.opacity(0.2))
    }
}


struct Header : View{
    let userName : String
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
    let balance : Balance
    var body : some View{
        HStack{
            VStack(alignment : .leading){
                Text("Total Balance")
                .font(.title2)
                    .foregroundColor(.black)
                Text("\(balance.total)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            Spacer()
            VStack{
                HStack{
                    Image(systemName: "arrow.up").font(Font.system(size: 20, weight: .bold)).foregroundColor(.green)
                    Text("\(balance.percentagechange) %")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                Text("vs last month")
                    .font(.title3)
                    .foregroundColor(.black)
            }
        }.padding(24)
            .fixedSize(horizontal: false, vertical: true)
            .background(.white).shadow(radius: 4,y: 2).clipShape(RoundedRectangle(cornerRadius: 16))
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
                    NavigationLink{
                        ExampleView()
                    }label: {
                        QuicAction(title: item.title, icon: item.icon).frame(width: 80)
                    }
                    
                   
                }
            }
        }.padding(24)
            .fixedSize(horizontal: false, vertical: true)
            .background(.white).shadow(radius: 4,y: 2).clipShape(RoundedRectangle(cornerRadius: 16))
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

struct SpendingOverView : View{
    let overviews : [SpendingOverview]
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
                
                ZStack{
                    Chart(overviews){ overview in
                        SectorMark(
                            angle : .value(overview.title,overview.amount),
                            innerRadius: .ratio(0.6)
                            
                        ).foregroundStyle(Color(hex: overview.color))
                    }.frame(width: 130,height : 130)
                    VStack{
                        Text("$ 56420")
                            .font(.caption)
                        Text("Total")
                            .font(.caption)
                    }
                }
                Spacer()
                VStack {
                    ForEach(overviews, id: \.id) { overview in

                        HStack {

                            Circle()
                                .fill(Color(hex: overview.color))
                                .frame(width: 10, height: 10)

                            Text(overview.title)
                                .font(.caption)

                            Spacer()

                            Text("\(overview.amount, specifier: "%.0f")%")
                                .font(.caption)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            
            
        }.padding(24)
            .fixedSize(horizontal: false, vertical: true)
            .background(.white).shadow(radius: 4,y: 2).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}


struct RecentTransactions : View {
    let transactions : [Transaction]
    var body : some View{
        VStack{
            HStack
            {
                Text("Recent Transactions")
                    .font(.title3).bold()
                Spacer()
                Text("See All").font(.caption).foregroundStyle(Color.blue)
            }
            
            ForEach(transactions) { transaction in
                TransactionView(transaction: transaction)
            }
            
        }.padding(24)
            .fixedSize(horizontal: false, vertical: true)
            .background(.white).clipShape(RoundedRectangle(cornerRadius: 16)).shadow(radius: 4,y: 2)
        
    }
}

struct TransactionView : View {
    var transaction : Transaction
    var body : some View{
        HStack{
            VStack(alignment: .leading){
                Text(transaction.category).font(.caption).bold()
                Text(transaction.merchant).font(.caption)
            }
            Spacer()
            Text("$\(transaction.amount, specifier: "%.2f")").font(.caption).foregroundStyle(Color.red)
        }.padding(.vertical,5)
    }
}




struct ExampleView : View {
    var body: some View {
        Text("Hello, world!")
    }
}


//#Preview {
//    HomeView()
//}
