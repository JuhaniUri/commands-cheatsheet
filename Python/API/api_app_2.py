import json
from flask import Flask, jsonify, request, json

app = Flask(__name__)

 
# Opening JSON file
f = open('car_brands.json')

cars = json.load(f)


@app.route('/cars')
def get_cars():
  return jsonify(cars)


@app.route('/cars', methods=['POST'])
def add_cars():
  cars.append(request.get_json())
  return '', 204