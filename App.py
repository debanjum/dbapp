# Import Modules
from __future__ import print_function      # make print a function
import mysql.connector                     # mysql functionality
import sys                                 # for passing shell arguments, misc errors
import cmd                                 # for creating interactive commandline interface
import shlex                               # for parsing shell type arguments

EDITOR = 1
AUTHOR = 2
REVIEWER = 3
RETIRED_REVIEWER = 4

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
        self.mode = "none"
        self.curr_id = -1

    def do_submit(self, line):
        title, Affiliation, RICode, author2, author3, author4, filename = shlex.split(line)

    def do_login(self, line):
        if (self.mode != "none"):
            print("Command not usable")
            return

        #parse arguments
        user_id = shlex.split(line)[0]

        LOGIN_QUERY = "SELECT * FROM Person WHERE id = {};".format(user_id)

        self.do_execute(LOGIN_QUERY)

        for row in self.cursor:
            self.curr_id = row["id"]
            if row["type"] == EDITOR:
                print("\n---------EDITOR PANEL---------\n")
                print("Hello {} {}!\nYour ID is: {} \n".format(row["first_name"], row["last_name"], row["id"]))
                self.mode = "editor"
            elif row["type"] == AUTHOR:
                print("\n---------AUTHOR PANEL---------\n")
                print("Hello {} {}!\nYour ID is: {}\nYour Address on file is:\n{} \n".format(row["first_name"], row["last_name"], row["id"], row["mailing_address"]))
                self.mode = "author"
            elif row["type"] == REVIEWER:
                print("\n---------REVIEWER PANEL---------\n")
                print("Hello {} {}!\nYour ID is: {} \n".format(row["first_name"], row["last_name"], row["id"]))
                self.mode = "reviewer"
            elif row["type"] == RETIRED_REVIEWER:
                print("\n---------RETIRED REVIEWER PANEL---------\n")
                print("Hello {} {}!\nYour ID is: {} \n".format(row["first_name"], row["last_name"], row["id"]))
                self.mode = "retired_reviewer"

            self.do_help("")

        if (self.cursor.rowcount == -1):
            print("User ID Not Found")

    def do_register(self, line):
        # parse arguments
        tokens = shlex.split(line)
        # Map person type string to number
        pno = {'author': AUTHOR, 'editor': EDITOR, 'reviewer': REVIEWER}[tokens[0]]

        def insert_sqls(fname, lname, pno, email, address, ri_codes=[]):
            print("insert")
            queries = [("INSERT INTO `Person` (`first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES "
            "(\'{0}\', \'{1}\', {2}, \'{3}\', NULL, \'{4}\');").format(fname, lname, pno, email, address)]

            self.do_execute(queries.pop(0))

            for ri_code in ri_codes:
                print("ri_codes: {0}".format(ri_code))
                queries.append(("INSERT INTO `Reviewer_Interest`(`person_id`, `ri_code`) VALUES "
                "({0}, {1});").format(self.cursor.lastrowid, ri_code))

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
            return

        if self.cursor.rowcount > 0:
            print("Operation Successful!");
        else:
            print("No Rows Affected by Operation, such a record does not exist or is inaccessible");

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
                print("".join(["{:<15}".format(row[col]) for col in self.cursor.column_names]))

        except mysql.connector.Error as e:        # catch SQL errors
            print("SQL Error: {0}".format(e.msg))

    def do_logout(self, line):
        self.mode = "none"
        self.curr_id = -1

    def help_register(self):
        print('\n'.join(['Signup: register <author|editor|reviewer> <fname> <lname> <email> <address>']))

    def help_login(self):
        print('\n'.join(['Login: login <user_id>']))

    def do_help(self, line):
        if (len(shlex.split(line)) == 0):
            if (self.mode == "none"):
                print('\n'.join(['Available Commands:', '- register', '- login', '- exit\n']))
            elif (self.mode == "editor"):
                print('\n'.join(['Available Commands:', '- status', '- assign', '- accept', '- reject', '- typeset', '- schedule', '- publish', '- logout' ,'- exit\n']))
            elif (self.mode == "author"):
                print('\n'.join(['Available Commands:', '- status', '- submit', '- retract', '- logout' ,'- exit\n']))
            elif (self.mode == "reviewer"):
                print('\n'.join(['Available Commands:', '- status', '- accept', '- reject', '- logout' ,'- exit\n']))
            else:
                print('\n'.join(['Available Commands:', '- rejoin', '- login', '- exit\n']))
        else:
            if shlex.split(line)[0] == "register":
                self.help_register()
            elif shlex.split(line)[0] == "login":
                self.help_login()

    def do_status(self, line):
        if (self.mode == "author"):
            STATUS_QUERY = ("SELECT Manuscript.id, Manuscript.title, Manuscript.status FROM Manuscript, Person, Manuscript_Author "
            "WHERE Manuscript.id = Manuscript_Author.manuscript_id "
            "AND Person.id = {} "
            "AND Person.id = Manuscript_Author.author_id "
            "AND Manuscript_Author.rank = 1;").format(self.curr_id)

            self.do_display(STATUS_QUERY);

            # print("\nStatus of Submitted Manuscripts:")
            # print("".join(["{:<12}".format(col) for col in self.cursor.column_names]))
            # print("--------------------------------------------")

            # # iterate through results
            # for row in self.cursor:
            #     print("{}\t{}\t{}".format(row["id"], ("{}...").format(row["title"][:20]), row["status"]))

        elif (self.mode == "editor"):
            STATUS_QUERY = ("SELECT status, count(*) as num "
                            "FROM Manuscript "
                            "GROUP BY status "
                            "ORDER BY status, num;")

            self.do_display(STATUS_QUERY);

            # print("\nStatus of Manuscripts in System:")
            # print("".join(["{:<12}".format(col) for col in self.cursor.column_names]))
            # print("--------------------------------------------")

            # # iterate through results
            # for row in self.cursor:
            #     print("{}\t{}".format((row["status"].replace("_", " ")).title(), row["num"]))

        elif (self.mode == "reviewer"):
            STATUS_QUERY = ("SELECT Manuscript.id, Manuscript.title FROM Manuscript, Person, Manuscript_Reviewer "
                            "WHERE Manuscript.id = Manuscript_Reviewer.manuscript_id "
                            "AND Person.id = {} "
                            "AND Person.id = Manuscript_Reviewer.reviewer_id "
                            "AND Manuscript.status = 'under_review' AND Manuscript_Reviewer.result = '-';").format(self.curr_id)

            self.do_display(STATUS_QUERY);

            # print("\nStatus of Assigned Manuscripts:")
            # print("".join(["{:<12}".format(col) for col in self.cursor.column_names]))
            # print("--------------------------------------------")

            # # iterate through results
            # for row in self.cursor:
            #     print("{}\t{}".format(row["id"], ("{}...").format(row["title"][:20])))

        else:
            print("Command not usable")
            return

    def do_accept(self, line):
        if (self.mode == "reviewer"):
            manuscript_id, appropriate, clarity, method, contribution = shlex.split(line)

            try: 
                manuscript_id = int(manuscript_id)
                appropriate = int(appropriate)
                clarity = int(clarity)
                method = int(method)
                contribution = int(contribution)

                if (appropriate < 0 or appropriate > 10) or (clarity < 0 or clarity > 10) or (method < 0 or method > 10) or (contribution < 0 or contribution > 10):
                    print("Scores must be between 0 and 10")
                    return

            except ValueError:
                print("Invalid Input, please retry")
                return

            UPDATE_QUERY = ("UPDATE `aalavi_db`.`Manuscript_Reviewer` SET `result`='{}', `clarity`='{}', `method`='{}', "
                " `contribution`='{}', `appropriate`='{}' WHERE `reviewer_id`='{}' AND `manuscript_id`='{}' AND `result` = '-';").format('y', clarity, method, appropriate, contribution, self.curr_id, manuscript_id)

            self.do_execute(UPDATE_QUERY)

            self.conn.commit()

        elif (self.mode == "editor"):
            print("Command not usable")
            return 
        else:
           print("Command not usable")
           return 

    def do_reject(self, line):
        if (self.mode == "reviewer"):
            manuscript_id, appropriate, clarity, method, contribution = shlex.split(line)

            try: 
                manuscript_id = int(manuscript_id)
                appropriate = int(appropriate)
                clarity = int(clarity)
                method = int(method)
                contribution = int(contribution)

                if (appropriate < 0 or appropriate > 10) or (clarity < 0 or clarity > 10) or (method < 0 or method > 10) or (contribution < 0 or contribution > 10):
                    print("Scores must be between 0 and 10")
                    return

            except ValueError:
                print("Invalid Input, please retry")
                return

            UPDATE_QUERY = ("UPDATE `aalavi_db`.`Manuscript_Reviewer` SET `result`='{}', `clarity`='{}', `method`='{}', "
                " `contribution`='{}', `appropriate`='{}' WHERE `reviewer_id`='{}' AND `manuscript_id`='{}' AND `result` = '-';").format('n', clarity, method, appropriate, contribution, self.curr_id, manuscript_id)

            self.do_execute(UPDATE_QUERY)

            self.con.commit()

        elif (self.mode == "editor"):
            print("Command not usable")
            return 
        else:
           print("Command not usable")
           return 

    def do_EOF(self, line):
        return True

    def do_exit(self, line):
        self.con.commit()
        self.con.close()
        self.cursor.close()
        sys.exit(0)

    def do_quit(self, line):
        self.do_exit(line)


if __name__ == "__main__":
    try:
        # setup connection to db
        con = mysql.connector.connect(host=SERVER, user=USER, password=PASS, database=DB, use_unicode=False)
        print("Connection to Megadodo Publications DB established.")

        # initialize a cursor
        cursor = con.cursor(dictionary = True)

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

    print("\nConnection terminated.", end='')