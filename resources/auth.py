from flask import request
from flask_restful import Resource
from werkzeug.security import generate_password_hash, check_password_hash
from flask_jwt_extended import create_access_token
from models import User, db

class Register(Resource):
    def post(self):
        data = request.get_json()
        hashed_password = generate_password_hash(data['password'])
        user = User(username=data['username'], password=hashed_password)
        db.session.add(user)
        db.session.commit()
        return {"message": "User registered successfully"}, 201

class Login(Resource):
    def post(self):
        data = request.get_json()
        user = User.query.filter_by(username=data['username']).first()
        if user and check_password_hash(user.password, data['password']):
            token = create_access_token(identity=user.id)
            return {"access_token": token}, 200
        return {"message": "Invalid credentials"}, 401
