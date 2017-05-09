# Import Modules
from __future__ import print_function      # make print a function
import mysql.connector                     # mysql functionality
import sys                                 # for misc errors

# Configure SQL Driver
PASS = "" if len(sys.argv) < 1 else sys.argv[1]    # user's password
SERVER = "sunapee.cs.dartmouth.edu"                # db server to connect to
USER = "aalavi"                                    # user to connect as
DB = "aalavi_db"                                   # db to user
QUERY = "SELECT * FROM Person;"                    # query statement

if __name__ == "__main__":
    try:
        # initialize db connection
        con = mysql.connector.connect(host=SERVER, user=USER, password=PASS, database=DB, use_unicode=False)

        print("Connection established.")

        # initialize a cursor
        cursor = con.cursor()

        # query db
        cursor.execute(QUERY)

        print("Query executed: '{0}'\n\nResults:".format(QUERY))

        # print table header
        print("".join(["{:<12}".format(col) for col in cursor.column_names]))
        print("--------------------------------------------")

        # iterate through results
        for row in cursor:
            print("".join(["{:<12}".format(col) for col in row]))

        # cleanup
        con.close()
        cursor.close()

    except mysql.connector.Error as e:        # catch SQL errors
        print("SQL Error: {0}".format(e.msg))
    except:                                   # anything else
        print("Unexpected error: {0}".format(sys.exc_info()[0]))

    print("\nConnection terminated.", end='')
