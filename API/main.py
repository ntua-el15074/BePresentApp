from flask_restful import Api

from API import app
from API.classes import *

api = Api(app, prefix='/bepresent')

api.add_resource(checkConnection, '/checkconnection')

#Contacts
api.add_resource(addContact, '/addcontact')
api.add_resource(deleteContact, '/deletecontact')

#Inventory
api.add_resource(addItem, '/additem')
api.add_resource(addMoney, '/addmoney')
api.add_resource(deductMoney, '/deductmoney')

#User
api.add_resource(authenticateUser,'/authenticateuser')
api.add_resource(addUser,'/adduser')
api.add_resource(getUserContacts,'/getusercontacts')
api.add_resource(getUserInventory,'/getuserinventory')
api.add_resource(updateSavedItem, '/updatesaveditem')
api.add_resource(SetUserState, '/setuserstate')

#Session
api.add_resource(connectToSession,'/connecttosession')
api.add_resource(disconnectFromSession,'/disconnectfromsession')
api.add_resource(addSession,'/addsession')
api.add_resource(deleteSession,'/deletesession')
api.add_resource(getUsersInSession, '/getusersinsession')


if __name__ == "__main__":
    # debug mode: every time we change it restarts the server
    app.run(debug=True, port=9876)

