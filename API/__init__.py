from flask import Flask
#from flask_mysqldb import MySQL
from flaskext.mysql import MySQL
import pymysql
from flask_cors import CORS, cross_origin

app = Flask(__name__)

CORS(app, resources={r"/bepresent/*": {"origins": "http://127.0.0.1:9876"}})

app.config["SECRET_KEY"] = "SECRET_KEY"
app.config["MYSQL_DB"] = "bepresent"
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = ""
app.config["MYSQL_HOST"] = "127.0.0.1"
#app.config["MYSQL_CHARSET"] = "utf8"
# # app.config["MYSQL_PORT"] = 5000
#app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

#db = MySQL(app)
db = MySQL(app,
           prefix="ntuaflix",
           host="localhost",
           user="root",
           #password="trage3dy",
           db="bepresent",
           #autocommit=True,
           cursorclass=pymysql.cursors.DictCursor
           )

db.init_app(app)

