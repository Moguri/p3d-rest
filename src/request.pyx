"""
Author: Jordan Maxwell
Written: 02/18/2019

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

import traceback

cdef class HTTPRequest(object):
    """
    Represents an HTTP request in queue
    """

    cdef HTTPRest _rest
    cdef int _request_id
    cdef object _channel
    cdef object _callback
    cdef object _ram_file

    def __init__(self, rest, request_id, channel, ram_file, callback=None):
        self._rest = rest
        self._request_id = request_id
        self._channel = channel
        self._callback = callback
        self._ram_file = ram_file
    
    @property
    def request_id(self):
        return self._request_id

    @property
    def channel(self):
        return self._channel

    @property
    def ram_file(self):
        return self._ram_file

    cpdef update(self):
        """
        Performs the run operations and finishing callbacks
        for the request's channel instance
        """

        if self._channel == None:
            return

        done = not self._channel.run()
        if done:
            _rest_notify.debug('Completed request: %s' % self._request_id)
            
            if self._callback != None:
                try:
                    self._callback(self._ram_file.get_data())
                except:
                    _rest_notify.warning('Exception occured processing callback')
                    _rest_notify.warning(traceback.format_exc())

            self._rest.remove_request(self._request_id)