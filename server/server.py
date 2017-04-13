#!/usr/bin/env python2

import sys
import flask
import flask_login
import ssl
import bcrypt
import hashlib


# adapted from https://github.com/maxcountryman/flask-login/blob/03bb7ffd5722f5ff8626d625b0e4941bda66b681/README.md

# default options
host = '0.0.0.0'
port = 5000
password_file = 'password.db'
mode = 'bcrypt'
https = True


app = flask.Flask(__name__)
app.secret_key = 'super secret string'  # Change this!

login_manager = flask_login.LoginManager()
login_manager.init_app(app)

USERNAME = 'foo@bar.tld'


def check_password(password):
    password_from_file = None
    with open(password_file, 'r') as f:
        password_from_file = f.readline().strip()

    if mode == "bcrypt":
        return bcrypt.checkpw(password.encode('utf8'), password_from_file)

    elif mode == "md5":
        m = hashlib.md5()
        m.update(password)
        return m.hexdigest() == password_from_file

    elif mode == "plaintext":
        return password == password_from_file

    else:
        return False


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

    user.is_authenticated = check_password(request.form['password'])

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

    if check_password(flask.request.form['password']):
        user = User()
        user.id = USERNAME
        flask_login.login_user(user)
        return flask.redirect(flask.url_for('protected'))

    return 'Bad login'


@app.route('/protected')
@flask_login.login_required
def protected():
    return "Congratulations!  You've completed part 1 of the lab.  For part 2, see TCP port XXXX."


@app.route('/logout')
def logout():
    flask_login.logout_user()
    return 'Logged out'


@login_manager.unauthorized_handler
def unauthorized_handler():
    return 'Unauthorized'


if __name__ == '__main__':
    if len(sys.argv) >= 2:
        password_file = sys.argv[1]
    if len(sys.argv) >= 3:
        mode = sys.argv[2]
    if len(sys.argv) >= 4:
        https = (sys.argv[3] == 'True')

    if https:
        context = ssl.create_default_context(purpose=ssl.Purpose.CLIENT_AUTH)
        context.load_cert_chain(certfile="server.crt", keyfile="server.key")
    else:
        context = None

    app.run(host=host, port=port, debug=True, ssl_context=context)
