from flask import Flask
from flask import redirect
import json
import time
import sys

# Getting the list of available servers from a json file
# I chose not to hard-code the list but to allow editing from somewhere else
available_servers = open('servers.json')
data = json.load(available_servers)
port_list = list(data["available_servers"])

# Defining flask application
app = Flask(__name__)

def next_available_server():

    global port_list

    # Since port_list is global, it can be modified by 
    # other requests coming to the server;
    # this cycle waits until there is at least 1 server available
    while len(port_list) < 1:
        time.sleep(0.01)

    next_port = port_list.pop(0)

    return str(next_port)

# Function called by factapp server that has finished with its
# calculations and is free to accept other incoming connections
@app.route("/port_update/<int:available_port>")
def update_port(available_port):

    global port_list
    
    print('\nAppending new available port: ' + str(available_port), flush=True)
    port_list.append(available_port)

    return '200'

@app.route("/")
def entrypoint():
    
    next_port = next_available_server()

    url = "http://localhost:" + next_port + "/" + next_port

    print('\nRedirecting client to: ' + url, flush=True)

    return redirect(url, code=302)

if __name__ == "__main__":
    app.run()