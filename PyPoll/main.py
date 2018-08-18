import os
import csv

csvpath = os.path.join("election_data.csv")


#say something about the dictionary here
myDict={}
row_number=0

# Open and read csv and convert it to a list of dictionaries
with open(csvpath, newline="") as csvfile:
    csvreader = csv.reader(csvfile, delimiter=",")
    
    # use of next to skip first title row in csv file
    next(csvreader) 
    Votes = []
  
 # PUT A DIFFERENT COMMENT IN HERE   
    for row in csvreader:
       
        Votes.append(int(row[0]))

        row_number +=1
        if row[2] in myDict:
            myDict[row[2]] += 1
        else:
            myDict [row[2]]=1
       
        result = max(myDict.keys(), key=(lambda k: myDict[k]))

    print("Election Results")
    print("-----------------------------------")
    print("Total Votes:", len(Votes))
    print("-----------------------------------")
    for candidate in myDict:
        print (str(candidate),round((((myDict[candidate])/row_number)*100),2), "(",(myDict[candidate]),")")
    print("-----------------------------------")
    print("Winner: ",(result))
    print("-----------------------------------")


    # Specify the file to write to
    output_path = os.path.join("results.csv")

    # Open the file using "write" mode. Specify the variable to hold the contents
    with open(output_path, 'w', newline='') as csvfile:

        # Initialize csv.writer
        csvwriter = csv.writer(csvfile, delimiter=',')

        # Write the first row (column headers)
        csvwriter.writerow(["Election Results"])

        csvwriter.writerow(["-----------------------------------"])

        csvwriter.writerow(["Total Votes:", len(Votes)])
    
        csvwriter.writerow(["-----------------------------------"])

        for candidate in myDict:
            csvwriter.writerow([(str(candidate),(((myDict[candidate])/row_number)*100), "(",(myDict[candidate]),")")])

        csvwriter.writerow([(result)])

        csvwriter.writerow(["-----------------------------------"])
    





 
   
