from bottle import Bottle, run,view,static_file, debug, request, post
from beaker.middleware import SessionMiddleware
from script1 import pingDevices
from script2 import detectExistingDevices
from script3 import createConfigFile
from script4 import modifyConfigFile
import os
debug(True)

ROOT = os.path.abspath(os.path.dirname(__file__))

session_opts = {
    'session.type': 'memory',
    'session.cookie_expires': 300,
    'session.auto': True
}
bottle_app = Bottle()
app = SessionMiddleware(bottle_app, session_opts)

@bottle_app.route('/static/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root=os.path.join(ROOT,'static'))

@bottle_app.route('/')
@view('index')
def index():
	session = request.environ.get('beaker.session')
	configured_phones = detectExistingDevices()
	new_phones = session.get('new') or ()
	configured_phones = detectExistingDevices()
	session['new'] = new_phones
	def get_new_phones():
		for element in new_phones:
			if element not in configured_phones:
				yield element
	return dict(new_phones=get_new_phones(), configured_phones=configured_phones  )

@bottle_app.route('/refresh')
@view('index')
def refresh():
	session = request.environ.get('beaker.session')
	new_phones = pingDevices()
	configured_phones = detectExistingDevices()
	session['new'] = new_phones
	def get_new_phones():
		for element in new_phones:
			if element not in configured_phones:
				yield element
	return dict(new_phones=get_new_phones(), configured_phones=configured_phones  )

@bottle_app.route('/create', method='POST')
def create():
	ip = request.forms.get('ip')
	mac = request.forms.get('mac')
	extension = request.forms.get('extension')
	return dict(value=1 if createConfigFile(mac, extension) else 0)

@bottle_app.route('/modify', method='POST')
def modify():
	ip = request.forms.get('ip')
	mac = request.forms.get('mac')
	extension = request.forms.get('extension')
	return dict(value=1 if modifyConfigFile(mac, extension) else 0)


run(app=app, port=8080, server='gunicorn', host='172.20.2.1')