import flask
import flask_login
import bcrypt

# adapted from https://github.com/maxcountryman/flask-login/blob/03bb7ffd5722f5ff8626d625b0e4941bda66b681/README.md


app = flask.Flask(__name__)
app.secret_key = 'super secret string'  # Change this!

login_manager = flask_login.LoginManager()

login_manager.init_app(app)

USERNAME = 'foo@bar.tld'


with open('hash.txt', 'r') as f:
    hashed = f.readline().strip()


class User(flask_login.UserMixin):
    pass


@login_manager.user_loader
def user_loader(email):
    user = User()
    user.id = USERNAME

    return user


@login_manager.request_loader
def request_loader(request):
    user = User()
    user.id = USERNAME

    # DO NOT ever store passwords in plaintext and always compare password
    # hashes using constant-time comparison!
    user.is_authenticated = bcrypt.checkpw(request.form['password'].encode('utf8'), hashed)

    return user


@app.route('/', methods=['GET', 'POST'])
def login():
    if flask.request.method == 'GET':
        return '''
               <form method='POST'>
                <input type='password' name='password' id='password' placeholder='password'></input>
                <input type='submit' name='submit'></input>
               </form>
               '''

    email = USERNAME
    if bcrypt.checkpw(flask.request.form['password'].encode('utf8'), hashed):
        user = User()
        user.id = USERNAME
        flask_login.login_user(user)
        return flask.redirect(flask.url_for('protected'))

    return 'Bad login'


@app.route('/protected')
@flask_login.login_required
def protected():
    return 'Logged in as: ' + flask_login.current_user.id


@app.route('/logout')
def logout():
    flask_login.logout_user()
    return 'Logged out'


@login_manager.unauthorized_handler
def unauthorized_handler():
    return 'Unauthorized'
    
    
if __name__ == '__main__':
    app.run()
