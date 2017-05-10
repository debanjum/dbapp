# Import Modules
from __future__ import print_function      # make print a function
import mysql.connector                     # mysql functionality
import sys                                 # for passing shell arguments, misc errors
import cmd                                 # for creating interactive commandline interface
import shlex                               # for parsing shell type arguments

# Configure SQL Driver
PASS = "" if len(sys.argv) < 1 else sys.argv[1]    # user's password
SERVER = "sunapee.cs.dartmouth.edu"                # db server to connect to
USER = "aalavi"                                    # user to connect as
DB = "aalavi_db"                                   # db to user
DISPLAY_PERSON = "SELECT * FROM Person;"           # query statement


class CmdInterface(cmd.Cmd):
    """Applications Commandline interface"""

    def init(self, cursor):
        self.cursor = cursor

    def do_register(self, line):
        # parse arguments
        ptype, fname, lname, email, address = shlex.split(line)

        # Map person type string to number
        pno = {'author': 1, 'editor': 2, 'reviewer': 3}[ptype]

        # Create Insert Query
        INSERT_QUERY = "INSERT INTO `Person` (`first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES \
        (\'{0}\', \'{1}\', {2}, \'{3}\', '', \'{4}\');".format(fname, lname, pno, email, address)

        # Execute and Render Query
        self.execute(INSERT_QUERY)

    def execute(self, QUERY):
        try:
            # execute input query
            print("Executing QUERY: '{0}'".format(QUERY))
            self.cursor.execute(QUERY)

            # execute display query
            self.cursor.execute(DISPLAY_PERSON)

            # print table header
            print("\n\nResults:")
            print("".join(["{:<12}".format(col) for col in self.cursor.column_names]))
            print("--------------------------------------------")

            # iterate through results
            for row in self.cursor:
                print("".join(["{:<12}".format(col) for col in row]))

        except mysql.connector.Error as e:        # catch SQL errors
            print("SQL Error: {0}".format(e.msg))
        except:                                   # anything else
            print("Unexpected error: {0}".format(sys.exc_info()[0]))

    def help_register(self):
        print('\n'.join(['register <author|editor|reviewer> <fname> <lname> <email> <address>', 'Signup']))

    def do_EOF(self, line):
        return True


if __name__ == "__main__":
    try:
        # setup connection to db
        con = mysql.connector.connect(host=SERVER, user=USER, password=PASS, database=DB, use_unicode=False)
        print("Connection to Megadodo Publications DB established.")

        # initialize a cursor
        cursor = con.cursor()

        # enter commandline i/o loop
        prompt = CmdInterface()
        prompt.prompt = '> '
        prompt.init(cursor)
        prompt.cmdloop('Starting Megadodo Publication Prompt')

        # cleanup
        con.close()
        cursor.close()

    except mysql.connector.Error as e:        # catch SQL errors
        print("SQL Error: {0}".format(e.msg))
    except:                                   # anything else
        print("Unexpected error: {0}".format(sys.exc_info()[0]))

    print("\nConnection terminated.", end='')
