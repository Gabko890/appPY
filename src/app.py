from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# External API
BASE_URL = "https://jsonplaceholder.typicode.com"

# Data pre demonstraciu, mozno pouzit ORM
posts = []

# ID validacia
def validate_user_id(user_id):
    response = requests.get(f"{BASE_URL}/users/{user_id}")
    return response.status_code == 200

# Pridanie postu
@app.route('/posts', methods=['POST'])
def add_post():
    data = request.get_json()
    if validate_user_id(data['userId']):
        posts.append(data)
        return jsonify({'message': 'Post uspesne pridany'}), 201
    return jsonify({'error': 'Nespravne User ID'}), 400

# Vyhladanie IDeckom
@app.route('/posts/<int:id>', methods=['GET'])
def get_post(id):
    for post in posts:
        if post['id'] == id or post['userId'] == id:
            return jsonify(post)
    response = requests.get(f"{BASE_URL}/posts/{id}")
    if response.status_code == 200:
        new_post = response.json()
        posts.append(new_post)
        return jsonify(new_post)
    return jsonify({'error': 'Post nenajdeny'}), 404

# Deletnutie postu
@app.route('/posts/<int:id>', methods=['DELETE'])
def delete_post(id):
    for i, post in enumerate(posts):
        if post['id'] == id:
            del posts[i]
            return jsonify({'message': 'Post odstraneny'})
    return jsonify({'error': 'Post nenajdeny'}), 404

# Update postu
@app.route('/posts/<int:id>', methods=['PUT'])
def update_post(id):
    data = request.get_json()
    for post in posts:
        if post['id'] == id:
            post['title'] = data.get('title', post['title'])
            post['body'] = data.get('body', post['body'])
            return jsonify({'message': 'Post aktualizovany uspesne'})
    return jsonify({'error': 'Post nenajdeny'}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
