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

    def init(self, cursor, con):
        self.cursor = cursor
        self.con = con

    def do_submit(self, line):
        title, Affiliation, RICode, author2, author3, author4, filename = shlex.split(line)

    def do_register(self, line):
        # parse arguments
        tokens = shlex.split(line)
        # Map person type string to number
        pno = {'author': 1, 'editor': 2, 'reviewer': 3}[tokens[0]]

        def insert_sqls(fname, lname, pno, email, address, ri_codes=[]):
            print("insert")
            queries = ["INSERT INTO `Person` (`first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES \
            (\'{0}\', \'{1}\', {2}, \'{3}\', NULL, \'{4}\');".format(fname, lname, pno, email, address)]

            self.do_execute(queries.pop(0))

            for ri_code in ri_codes:
                print("ri_codes: {0}".format(ri_code))
                queries.append("INSERT INTO `Reviewer_Interest`(`person_id`, `ri_code`) VALUES \
                ({0}, {1});".format(self.cursor.lastrowid, ri_code))

            return queries

        # parse arguments if author
        ri_codes = []
        if pno == 2:
            ptype, fname, lname, email, address = tokens

        # parse arguments if editor
        elif pno == 1:
            ptype, fname, lname = tokens
            email, address = "", ""

        # parse arguments if reviewer
        elif pno == 3:
            ptype, fname, lname = tokens[:3]
            ri_codes = tokens[3:]
            email, address = "", ""

        queries = insert_sqls(fname, lname, pno, email, address, ri_codes)

        # Execute Query
        for query in queries:
            self.do_execute(query)
        self.con.commit()

        # Render Updated Table
        self.do_display(DISPLAY_PERSON)

    def do_execute(self, QUERY):
        """helper function to execute SQL statement"""
        try:
            # execute input query
            print("Executing QUERY: '{0}'".format(QUERY))
            self.cursor.execute(QUERY)
        except mysql.connector.Error as e:        # catch SQL errors
            print("SQL Error: {0}".format(e.msg))
        except:                                   # anything else
            print("Unexpected error: {0}".format(sys.exc_info()[0]))

    def do_display(self, QUERY):
        """helper function to execute SQL statement and render results"""
        try:
            # execute display query
            self.cursor.execute(QUERY)

            # print table header
            print("\n\nResults:")
            print("".join(["{:<15}".format(col) for col in self.cursor.column_names]))
            print("--------------------------------------------")

            # iterate through results
            for row in self.cursor:
                print("".join(["{:<15}".format(col) for col in row]))

        except mysql.connector.Error as e:        # catch SQL errors
            print("SQL Error: {0}".format(e.msg))
        except:                                   # anything else
            print("Unexpected error: {0}".format(sys.exc_info()[0]))

    def help_register(self):
        print('\n'.join(['register <author|editor|reviewer> <fname> <lname> [email] [address]', 'Signup']))

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
        prompt.init(cursor, con)
        prompt.cmdloop('Starting Megadodo Publication Prompt')

        # cleanup
        con.close()
        cursor.close()

    except mysql.connector.Error as e:        # catch SQL errors
        print("SQL Error: {0}".format(e.msg))
    except:                                   # anything else
        print("Unexpected error: {0}".format(sys.exc_info()[0]))

    print("\nConnection terminated.", end='')
