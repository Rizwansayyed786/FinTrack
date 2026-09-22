//
//  ReportsView.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 22/09/26.
//

import SwiftUI
import Charts
struct ReportView : View{
    var body : some View{
        VStack(spacing : 20){
            ReportsViewHeader()
            TotalExpense()
            ExpenseTrendView()
            ExpenseByCategories()
        }.padding(16).frame(maxWidth: .infinity,maxHeight : .infinity ,alignment: .topLeading)
    }
}


struct ReportsViewHeader : View{
    var body : some View{
        HStack{
            Text("Reports")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Spacer()
            HStack{
                Text("This month")
                Image(systemName: "chevron.down")
            }.padding(8).clipShape(RoundedRectangle(cornerRadius: 8)).overlay(RoundedRectangle(cornerRadius: 16).stroke(.gray.opacity(0.25),lineWidth: 1))
        }
    }
}

struct TotalExpense : View{
    var body : some View{
        VStack(alignment: .leading,spacing: 10){
            Text("Total Expense").font(.title3)
            Text("$1,200.00")
                .font(.title)
                .fontWeight(.bold)
            HStack{
                Image(systemName: "arrow.down").font(.caption).foregroundStyle(Color.green)
                Text("8.2%").font(.caption).foregroundStyle(Color.green)
                Text("vs last Month").font(.caption)
                    
            }
        }.padding(20).frame(maxWidth : .infinity,alignment: .leading).clipShape(RoundedRectangle(cornerRadius: 8)).overlay(RoundedRectangle(cornerRadius: 16).stroke(.gray.opacity(0.25),lineWidth: 1))
    }
}

struct MonthlyExpense: Identifiable {
    let id = UUID()
    let month: String
    let amount: Double
}

struct ExpenseTrendView : View{
    let expenses : [MonthlyExpense] = [
        MonthlyExpense(month: "Jan", amount: 8000),
        MonthlyExpense(month: "Feb", amount: 12000),
        MonthlyExpense(month: "Mar", amount: 9500),
        MonthlyExpense(month: "Apr", amount: 18000),
        MonthlyExpense(month: "May", amount: 15000),
        MonthlyExpense(month: "Jun", amount: 22000),
    ]
    var body : some View{
        VStack(alignment: .leading,spacing: 10){
            Text("Expense Trend") .font(.title3)
                .fontWeight(.bold)
            Chart(expenses) { expense in

                LineMark(
                    x: .value("Month", expense.month),
                    y: .value("Amount", expense.amount)
                )
                PointMark(
                    x: .value("Month", expense.month),
                    y: .value("Amount", expense.amount)
                )
              
            }.chartYAxis{
                AxisMarks(position : .leading)
            }.chartXAxis{
                
                AxisMarks(position : .bottom)
            }.chartYScale(domain: 0...30_000)

        }.frame(maxWidth : .infinity,maxHeight: 250, alignment: .topLeading)
    }
}


struct Expense : Identifiable {
    let id : String
    let title : String
    let amount : Double
    let color : Color
    let percentage : Double
}

struct ExpenseByCategories : View{
    var expenses : [Expense] = [
        .init(id: "1", title: "Food", amount: 100, color: .red,percentage: 0.3),
        .init(id: "2", title: "Transport", amount: 100, color: .blue,percentage: 0.2),
        .init(id: "3", title: "Entertainment", amount: 100, color: .yellow,percentage: 0.2),
        .init(id: "4", title: "Savings", amount: 100, color: .green,percentage: 0.1),
        .init(id: "5", title: "Clothing", amount: 100, color: .orange,percentage: 0.1),
    ]
    var body : some View{
        VStack(alignment: .leading,){
            Text("Expense by Category") .font(.title3)
                .fontWeight(.bold)
            
            ForEach(expenses){ expense in
                ExpenseCategory(color: expense.color, title: expense.title, amount: expense.amount, percentage: expense.percentage)
            }
        }.frame(maxWidth : .infinity,alignment: .leading)
    }
}

struct ExpenseCategory : View{
    let color : Color
    let title : String
    let amount : Double
    let percentage : Double
    var body : some View{
        GeometryReader { geometry in
            HStack{
                Text(title)
                    .font(.caption).frame(width: geometry.size.width * 0.25,alignment: .leading)
                RoundedRectangle(cornerRadius : 16).fill(color).frame(maxWidth : .infinity,maxHeight: 3)
                Text("$\(amount,specifier: "%.2f") (\(percentage*100 ,specifier: "%.f")%)").font(.caption).frame(width: geometry.size.width * 0.25,alignment: .init(horizontal: .trailing, vertical: .center))
                
            }
        }.frame(height: 20)
    }
}

#Preview{
    ReportView()
}
