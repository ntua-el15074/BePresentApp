from flask import request, jsonify, make_response, session
from functools import wraps
from flask_restful import Resource
import json, jwt, datetime
from API import db, app
from flask_cors import cross_origin,CORS

CORS(app, resources={r"/bepresent/*": {"origins": "http://127.0.0.1:9876"}})

class checkConnection(Resource):
    @cross_origin()
    def get(self):
        try: 
            query = f'show tables'
            cur = db.get_db().cursor()
            cur.execute(query)
            cur.close()
            return "Yes"
        except:
            print("oops")

class addContact(Resource):
    @cross_origin()
    def post(self):
        user_id = request.form.get("user_id")
        name = request.form.get("name")
        phone = request.form.get("phone")
        query = f'''INSERT INTO contacts (user_id, name, phonenumber)
                    VALUES ({user_id}, '{name}', '{phone}')'''

        cur = db.get_db().cursor()
        cur.execute(query)
        db.get_db().commit()
        cur.close()
        return {"status":"Contact added"}, 200

class deleteContact(Resource):
    @cross_origin()
    def post(self):
        user_id = request.form.get("user_id")
        name = request.form.get("name")
        phone = request.form.get("phone")

        query = f'''DELETE FROM contacts WHERE user_id = {user_id}
                    AND name = '{name}' AND phonenumber = '{phone}';'''

        cur = db.get_db().cursor()
        cur.execute(query)
        db.get_db().commit()
        cur.close()

        return {"status":"Contact deleted"}, 200

class addItem(Resource):
    @cross_origin()
    def post(self):
        user_id = request.form.get("user_id")
        category = request.form.get("category")
        name = request.form.get("name")
        imagepath = request.form.get("imagepath")
        cost = request.form.get("cost")
        postop = request.form.get("postop")
        posleft = request.form.get("posleft")
        possize = request.form.get("possize")
        top_ingame = request.form.get("top_ingame")
        left_ingame = request.form.get("left_ingame")

        query = f'''INSERT INTO inventory
        (user_id, category, name, imagepath, cost, postop, posleft,
        possize, top_ingame, left_ingame) VALUES
        ({user_id}, "{category}", "{name}", "{imagepath}", {cost}, {postop}, {posleft},
        {possize}, {top_ingame}, {left_ingame});'''


        cur = db.get_db().cursor()
        cur.execute(query)
        db.get_db().commit()
        cur.close()

        return {"status":"Item added"}, 200

class addMoney(Resource):
    @cross_origin()
    def post(self):
        money = request.form.get("money")
        user_id = request.form.get("user_id")

        query = f'''update app_user SET money = {money} where id = {user_id}'''

        cur = db.get_db().cursor()
        cur.execute(query)
        db.get_db().commit()
        cur.close()

        return {"status":"Money added"}, 200

class deductMoney(Resource):
    @cross_origin()
    def post(self):
        money = request.form.get("money")
        user_id = request.form.get("user_id")

        query = f'''update app_user SET money = {money} where id = {user_id}'''

        cur = db.get_db().cursor()
        cur.execute(query)
        db.get_db().commit()
        cur.close()

        return {"status":"Money deducted"}, 200

class authenticateUser(Resource):
    @cross_origin()
    def post(self):
        username = request.form.get("username")
        password = request.form.get("password")

        query = f'''SELECT * FROM app_user WHERE username = "{username}" AND
                    password = "{password}"'''


        cur = db.get_db().cursor()
        cur.execute(query)
        get_user = cur.fetchall()
        cur.close()
        if get_user:
            user_id = get_user[0]["id"]
            user_money = get_user[0]["money"]

            response_data = {'user_id':user_id, 'money':user_money}
            response = make_response(jsonify(response_data), 200)
            return response
        else:
            response_data = {'error' : 'error message'}
            response = make_response(jsonify(response_data), 500)
            return response

class addUser(Resource):
    @cross_origin()
    def post(self):
        username = request.form.get("username")
        password = request.form.get("password")
        email = request.form.get("email")
        money = request.form.get("money")

        query = f'''INSERT INTO app_user (username, password, email, money)
                    VALUES ("{username}","{password}", "{email}", {money})'''

        cur = db.get_db().cursor()
        cur.execute(query)
        db.get_db().commit()
        cur.close()

        return {"status":"User added"}, 200

class getUserContacts(Resource):
    @cross_origin()
    def post(self):
        try:
            user_id = request.form.get("user_id")

            query = f'''SELECT * FROM contacts WHERE user_id = {user_id}'''

            cur = db.get_db().cursor()
            cur.execute(query)
            get_data = cur.fetchall()
            cur.close()
            if get_data:
                response_data = [{"name" : data["name"],
                                  "phone" : data["phonenumber"]}
                                for data in get_data]

                return_dict = {}
                return_dict["result"] = response_data

                json_result = json.dumps(return_dict, sort_keys=False)
                response = make_response(json_result, 200)
                return response
            else:
                return {'error': 'no data'},400
        except TypeError as e:
            return {'error': str(e)}

class getUserInventory(Resource):
    @cross_origin()
    def post(self):
        user_id = request.form.get("user_id")

        query = f'''SELECT * FROM inventory WHERE user_id = {user_id}'''

        cur = db.get_db().cursor()
        cur.execute(query)
        get_data = cur.fetchall()
        cur.close()
        if get_data:
            response_data = [{"category" : data["category"],
                              "name" : data["name"],
                              "imagepath" : data["imagepath"],
                              "cost" : data["cost"],
                              "postop" : data["postop"],
                              "posleft" : data["posleft"],
                              "possize" : data["possize"],
                              "top_ingame" : data["top_ingame"],
                              "left_ingame" : data["left_ingame"]}
                            for data in get_data]

            return_dict = {}
            return_dict["result"] = response_data

            json_result = json.dumps(return_dict, sort_keys=False)
            response = make_response(json_result, 200)
            return response
        else:
            return {'error': 'patata happened'}, 400

