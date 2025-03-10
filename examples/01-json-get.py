"""
Author: Jordan Maxwell
Written: 07/30/2019

The MIT License (MIT)

Copyright (c) 2019 Nxt Games

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

from panda3d import rest

from direct.showbase.ShowBase import ShowBase

base = ShowBase()

def handle_ip(self, data):
    """
    Handles the callback data
    """

    ip = data.get('ip', 'unknown')
    print('My public ip is: %s' % ip)

base.rest = rest.HTTPRest()
base.rest.perform_json_get_request('https://api.ipify.org/?format=json', callback=handle_ip)

def update_rest(self, task):
    """
    Updates the rest object
    """

    base.rest.update()
    return task.cont

base.taskMgr.add(update_rest, 'update-http')

base.run()