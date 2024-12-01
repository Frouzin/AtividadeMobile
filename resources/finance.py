from flask import request
from flask_restful import Resource
from flask_jwt_extended import jwt_required, get_jwt_identity
from models import Transaction, db
from datetime import datetime

class FinanceSummary(Resource):
    @jwt_required()
    def get(self):
        user_id = get_jwt_identity()
        transactions = Transaction.query.filter_by(user_id=user_id).all()
        total = sum(t.amount if t.type == "recebimento" else -t.amount for t in transactions)
        return {
            "total": total,
            "transactions": [{"id": t.id, "type": t.type, "amount": t.amount, "created_at": t.created_at} for t in transactions]
        }, 200

class AddTransaction(Resource):
    @jwt_required()
    def post(self):
        user_id = get_jwt_identity()
        data = request.get_json()
        transaction = Transaction(
            user_id=user_id,
            type=data['type'],
            amount=data['amount'],
            created_at=datetime.utcnow()
        )
        db.session.add(transaction)
        db.session.commit()
        return {"message": "Transaction added successfully"}, 201

class DeleteTransaction(Resource):
    @jwt_required()
    def delete(self, transaction_id):
        user_id = get_jwt_identity()
        transaction = Transaction.query.filter_by(id=transaction_id, user_id=user_id).first()
        if not transaction:
            return {"message": "Transaction not found"}, 404
        db.session.delete(transaction)
        db.session.commit()
        return {"message": "Transaction deleted successfully"}, 200
