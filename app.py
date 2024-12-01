from flask import Flask
from flask_restful import Api
from flask_jwt_extended import JWTManager
from models import db
from resources.auth import Register, Login
from resources.finance import FinanceSummary, AddTransaction, DeleteTransaction
from flask_cors import CORS

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
app.config['JWT_SECRET_KEY'] = 'your-secret-key'
CORS(app)

db.init_app(app)
api = Api(app)
jwt = JWTManager(app)

# Criar as tabelas
with app.app_context():
    db.create_all()

# Rotas
api.add_resource(Register, '/api/register')
api.add_resource(Login, '/api/login')
api.add_resource(FinanceSummary, '/api/finance/summary')
api.add_resource(AddTransaction, '/api/finance/add')
api.add_resource(DeleteTransaction, '/api/finance/delete/<int:transaction_id>')

if __name__ == "__main__":
    app.run(debug=True)
