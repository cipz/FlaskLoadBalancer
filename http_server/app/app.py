from flask import Flask
from math import factorial
import requests
import os

# Defining flask application
app = Flask(__name__)

def update_status(my_port):

    lb_ip_addr = os.environ['LB_IP_ADDR']
    lb_port = os.environ['LB_PORT']

    return requests.get("http://" + \
                        lb_ip_addr + ":" + \
                        str(lb_port) + \
                        "/port_update/" + \
                        str(my_port))

@app.route("/")
@app.route("/<int:my_port>")
def factapp(my_port=None):

    random_value = randint(100, 1000)

    print("random_value", random_key)
    
    # Calculating the factorial
    res = str(factorial(key_value))

    # Building a string to display
    return_string = "Factorial of " + str(random_value) + \
                    " = " + str(res)

    if my_port is not None:
        update_res = str(update_status(my_port))
        if update_res != '<Response [200]>':
            return 'Failed to update port status :' + update_res

    return return_string

if __name__ == "__main__":
    app.run()
