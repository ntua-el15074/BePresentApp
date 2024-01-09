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

db = MySQL(app,
           prefix="ntuaflix",
           host="localhost",
           user="root",
           db="bepresent",
           cursorclass=pymysql.cursors.DictCursor
           )

db.init_app(app)

