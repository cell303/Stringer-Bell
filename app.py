import os
import webapp2

from google.appengine.ext import db
from google.appengine.ext.webapp import template

class MainPage(webapp2.RequestHandler):
	def get(self, file):
	  template_values = {
	  	'title': 'Stringer Bell',
	  }
	  						
	  path = os.path.join(os.path.dirname(__file__), 'index.html')
	  self.response.out.write(template.render(path, template_values))

app = webapp2.WSGIApplication([(r'/(.*)', MainPage)])
