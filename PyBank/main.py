import os
import csv

csvpath = os.path.join("budget_data.csv")

# Set initial Net_Amount 
net_Amount=0
count = 0 

# Open and read csv and convert it to a list of dictionaries
with open(csvpath, newline="") as csvfile:
    csvreader = csv.reader(csvfile, delimiter=",")
   
    # use of next to skip first title row in csv file
    next(csvreader) 
    revenue = []
    date = []
    rev_change = []

    # in this loop I did sum of column 1 which is revenue in csv file and counted total months which is column 0 
    for row in csvreader:

        revenue.append(int(row[1]))
        date.append(row[0])


    #in this loop I did total of difference between all row of column "Revenue" and found total revnue change. Also found out max revenue change and min revenue change. 
    for i in range(1,len(revenue)):
        rev_change.append(revenue[i] - revenue[i-1])   
        avg_rev_change = sum(rev_change)/len(rev_change)

        max_rev_change = max(rev_change)

        min_rev_change = min(rev_change)

        max_rev_change_date = str(date[rev_change.index(max(rev_change))])
        min_rev_change_date = str(date[rev_change.index(min(rev_change))])

    print("Financial Analysis")
    print("-----------------------------------")
    print("Total Months:", len(date))
    print("Total Revenue: $", sum(revenue))
    print("Avereage Revenue Change: $", round(avg_rev_change))
    print("Greatest Increase in Revenue:", max_rev_change_date,"($", max_rev_change,")")
    print("Greatest Decrease in Revenue:", min_rev_change_date,"($", min_rev_change,")")

    # Specify the file to write to
    output_path = os.path.join("results.csv")

    # Open the file using "write" mode. Specify the variable to hold the contents
    with open(output_path, 'w', newline='') as csvfile:

        # Initialize csv.writer
        csvwriter = csv.writer(csvfile, delimiter=',')

        # Write the first row (column headers)
        csvwriter.writerow(["Financial Analysis"])

        csvwriter.writerow(["-----------------------------------"])

        csvwriter.writerow(["Total Months:", len(date)])

        csvwriter.writerow(["Total Revenue:", sum(revenue)])

        csvwriter.writerow(["Avereage Revenue Change:", round(avg_rev_change)])

        csvwriter.writerow(["Greatest Increase in Revenue:", max_rev_change_date,"($", max_rev_change,")"])

        csvwriter.writerow(["Greatest Decrease in Revenue:", min_rev_change_date,"($", min_rev_change,")"])
    



