import psycopg2


def menu():
    print("Please enter the number to choose option")
    print("(1) Enter a Patient's Observation")
    print("(2) Quit")
    print("(3) help")

#Connecting to database.
connection = psycopg2.connect(
    host = "localhost",
    user = "postgres",
    password = "postgres",
    port = "5432",
    database = "covid19"
)
#Curser
cursor = connection.cursor()

#Goal: Add Observations about Patients into database

print("Welcome to the Hospital Database System")
hospital_id = input("Please enter your Hospital ID number: ")
cursor.execute("select exists(select 1 from health_professional where hospital_id="+hospital_id+")")
h_exists = cursor.fetchall()[0][0]
#hospital_id validation
if (not h_exists):
    print("Hospital ID Does not exists. Terminating...")
    connection.close()
    exit()


response = ''
menu()
while not response=='2':
    if (response=='3'):
        menu()
    if (response=='1'):
        patient_id = input("Please enter the patient's ID number: ")
        #patient_id validation
        cursor.execute("select exists(select 1 from patient where patient_id="+patient_id+")")
        patient_exists = cursor.fetchall()[0][0]
        if (not patient_exists):
            print("Sorry! Patient does not exist")
            menu()
            response = input()
            continue
        else:
            #Generating obv_id automatically
            cursor.execute("SELECT * FROM observation ORDER BY obv_id DESC LIMIT 1")
            lastObv_id = cursor.fetchall()[0][0]
            obv_id = lastObv_id+1

            #remaining inputs 
            date = input("Enter Date (YYYY-MM-DD): ")
            time = input("Enter Time (HH:MM): ")
            text = input("Enter Text: ")
            
            try:
                #INSERT into Observation
                cursor.execute("INSERT INTO observation (obv_id, date, time, text) VALUES (%s,%s,%s,%s)", 
                (obv_id, date, time, text))
                connection.commit()
                #INSERT into make_observation
                cursor.execute("INSERT INTO make_observation (obv_id, hospital_id) VALUES (%s,%s)", 
                (obv_id, hospital_id))
                connection.commit()
                #INSERT into receive_observation
                cursor.execute("INSERT INTO receive_observation (obv_id, patient_id) VALUES (%s,%s)", 
                (obv_id, patient_id))
                connection.commit()

            except Exception as e:
                print('Error:', e)
                menu()
                response = input()
                continue
            
            print("Observation has been added successfully!")
            print("Observation ID: "+str(obv_id)+", Date: "+date+", Time: "+time)
            print()
            menu()
            response = input()
            continue

    response = input()    

print("Goodbye...")
connection.close()