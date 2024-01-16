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

class addSession(Resource):
    @cross_origin()
    def post(self):
        creator_id = request.form.get("creator_id")
        name = request.form.get("name")
        password = request.form.get("password")

        if not creator_id:
            return {"error":"No creator_id"},500
        if not name:
            return {"error":"No name"},500
        if not password:
            return {"error":"No password"},500

        query = f'''INSERT INTO sessions (creator_id, name, password)
                    VALUES ({creator_id},"{name}","{password}")'''


        try:
            cur = db.get_db().cursor()
            cur.execute(query)
            db.get_db().commit()
            cur.close()


            new_query = f'''SELECT * FROM sessions WHERE name='{name}' AND password='{password}';'''

            cur = db.get_db().cursor()
            cur.execute(new_query)
            get_session = cur.fetchall()
            print(get_session)
            cur.close()

            if get_session:
                session_id = get_session[0]["id"]

                inner_query = f'''INSERT INTO session_users (user_id, session_id)
                                    VALUES ({creator_id},{session_id})'''

                cur = db.get_db().cursor()
                cur.execute(inner_query)
                db.get_db().commit()
                cur.close()

                return {"status":"Session added"}, 200
            else:
                return {"error":"Something went wrong"},500
        except:
            return {"error":"Something went wrong"}, 500

class deleteSession(Resource):
    @cross_origin()
    def post(self):
        name = request.form.get("name")
        password = request.form.get("password")

        if not name:
            return {'error':'no name'},500
        if not password:
            return {'error':'no password'},500

        query = f'''DELETE FROM sessions WHERE name = '{name}' AND password = '{password}';'''

        try:
            cur = db.get_db().cursor()
            cur.execute(query)
            db.get_db().commit()
            cur.close()

            return {"status":"Session deleted"}, 200
        except:
            return {'error':"Something went wrong"},500


class connectToSession(Resource):
    @cross_origin()
    def post(self):
        user_id = request.form.get("user_id")
        name = request.form.get("name")
        password = request.form.get("password")
        count_query = f'''SELECT COUNT(*) as count FROM app_user
                        JOIN session_users ON app_user.id = session_users.user_id
                        JOIN sessions ON session_users.session_id = sessions.id
                        WHERE sessions.name = '{name}'
                        AND sessions.password = '{password}';'''
        
        cur = db.get_db().cursor()
        cur.execute(count_query)
        get_count = cur.fetchone()
        cur.close()

        if get_count["count"] >= 3:
            return {"error":"can't join session"},500


        query = f'''SELECT * FROM sessions WHERE name="{name}" AND
                    password="{password}"'''


        try:
            cur = db.get_db().cursor()
            cur.execute(query)
            get_session = cur.fetchall()
            print(get_session)
            cur.close()
        except:
            return {"Validity": False},500


        if get_session:
            session_id = get_session[0]["id"]
            creator_id = get_session[0]["creator_id"]

            inner_query = f'''INSERT INTO session_users (user_id, session_id)
                                VALUES ({user_id},{session_id})'''
            try:
                cur = db.get_db().cursor()
                cur.execute(inner_query)
                db.get_db().commit()
                cur.close()
            except:
                return {"Validity": False},500

            response_data = {'Validity': True, 'creator_id': creator_id};
            response = make_response(jsonify(response_data), 200)
            return response
        else:
            response_data = {'Validity' : False}
            response = make_response(jsonify(response_data), 500)
            return response

class disconnectFromSession(Resource):
    @cross_origin()
    def post(self):
        user_id = request.form.get("user_id")
        name = request.form.get("name")
        password = request.form.get("password")

        query = f'''SELECT * FROM sessions WHERE name="{name}" AND
                    password="{password}"'''

        try:
            cur = db.get_db().cursor()
            cur.execute(query)
            get_session = cur.fetchall()
            cur.close()
        except:
            return {"error": "Wrong name or password"},500


        if get_session:
            session_id = get_session[0]["id"]

            inner_query = f'''DELETE FROM session_users WHERE user_id = {user_id} AND session_id = {session_id};'''

            try:
                cur = db.get_db().cursor()
                cur.execute(inner_query)
                db.get_db().commit()
                cur.close()
            except:
                return {"Validity": False},500

            return {"status":"You have disconnected successfully"},200
        else:
            return {"error":"Could not disconnect from session"},500

class getUsersInSession(Resource):
    @cross_origin()
    def post(self):
        name = request.form.get("name")
        password = request.form.get("password")
        print(name)
        print(password)

        query = f'''SELECT app_user.* FROM app_user
                    JOIN session_users ON app_user.id = session_users.user_id
                    JOIN sessions ON session_users.session_id = sessions.id
                    WHERE sessions.name = '{name}'
                    AND sessions.password = '{password}';'''

        try:
            cur = db.get_db().cursor()
            cur.execute(query)
            users = cur.fetchall()
            cur.close()

            user_list = [user for user in users]

            return {'user_list': user_list},200
        except:
            return {'error':'Something went wrong'},500


class updateSavedItem(Resource):
    @cross_origin()
    def post(self):
        user_id = request.form.get("user_id")
        savedItem = request.form.get("savedItem")
        print(savedItem)

        if savedItem == 'Clothing 1':
            savedItem = 'assets/tbao_clothing_1.png'
        if savedItem == 'Clothing 2':
            savedItem = 'assets/tbao_clothing_2.png'
        if savedItem == 'Hat 1':
            savedItem = 'assets/tbao_hat_1.png'
        if savedItem == 'Hat 2':
            savedItem = 'assets/tbao_hat_2.png'
        if savedItem == 'Snout 1':
            savedItem = 'assets/tbao_snout_1.png'
        if savedItem == 'Snout 2':
            savedItem = 'assets/tbao_snout_2.png'
        if savedItem == 'Glasses 1':
            savedItem = 'assets/tbao_glasses_1.png'
        if savedItem == 'Glasses 2':
            savedItem = 'assets/tbao_glasses_2.png'



        query = f'''UPDATE app_user SET image ="{savedItem}" WHERE id = {user_id};'''

        try:
            cur = db.get_db().cursor()
            cur.execute(query)
            db.get_db().commit()
            cur.close()
            return {"status":"SavedItem updated"},200
        except:
            return {"error":"Could not update savedItem"},500

class SetUserState(Resource):
    @cross_origin()
    def post(self):
        user_id = request.form.get("user_id")
        state = request.form.get("state")

        query = f'''UPDATE app_user SET userState ="{state}" WHERE id = {user_id};'''

        try:
            cur = db.get_db().cursor()
            cur.execute(query)
            db.get_db().commit()
            cur.close()
            return {"status":"State updated"},200
        except:
            return {"error":"Could not update state"},500

class UpdateUserPoints(Resource):
    @cross_origin()
    def post(self):
        user_id = request.form.get("user_id")
        userPoints = request.form.get("userPoints")

        query = f'''UPDATE app_user SET userPoints ="{userPoints}" WHERE id = {user_id};'''

        try:
            cur = db.get_db().cursor()
            cur.execute(query)
            db.get_db().commit()
            cur.close()
            return {"status":"Points updated"},200
        except:
            return {"error":"Could not update points"},500

