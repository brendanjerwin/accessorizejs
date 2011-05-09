accessorize.js
==============
_Add observable accessors to any object._

`accessorize.js` makes it easy to convert plain javascript 'properties'
into fancy-ass-observable-accessor-methods!

Accessorized accessor methods will be familiar to anyone who has used
JQuery:

**Getter:** `var foo = obj.propertyName()`

**Setter:** `obj.propertyName(newValue)`


_But wait! There's more!_

In addition to the lovely accessor symantics, you'll also get change
notification too!

'''javascript

var obj = accessorize.wrap({
    propertyOne : "value",
    propertyTwo : "another value"
});

obj.propertyOne.subscribe(function(newValue){
    alert("Property One changed to " + newValue);
});

obj.propertyOne("some new value"); //What do you think happens now?

'''



LICENSE
=======
This software is licensed under the "MIT License":

Copyright (c) 2011 Brendan Erwin and contributors.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

