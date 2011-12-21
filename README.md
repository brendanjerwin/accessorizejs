[![Build Status](https://secure.travis-ci.org/brendanjerwin/accessorizejs.png)](http://travis-ci.org/brendanjerwin/accessorizejs)

`accessorize.js` makes it easy to convert plain javascript 'properties'
into fancy-ass-observable-accessor-methods! Simply call `accessorize()` with
your plain-old-javascript-object and get back a super-charged wrapped
version.

_Unimportant Note_: Actually you could name `accessorize` anything you want since it's packaged as
an [AMD Module](https://github.com/amdjs/amdjs-api/wiki/AMD)

Accessors
---------

Accessorized accessor methods will be familiar to anyone who has used
JQuery:

**Getter:** `var foo = obj.propertyName()`

**Setter:** `obj.propertyName(newValue)`


_But wait! There's more!_

Change Notifications (AKA: Observables)
---------------------------------------

In addition to the lovely accessor semantics, you'll also get change
notification too!

```javascript

var obj = accessorize({
    propertyOne : "value",
    propertyTwo : "another value"
});

obj.propertyOne.subscribe(function(newValue){
    alert("Property One changed to " + newValue);
});

obj.propertyOne("some new value"); //What do you think happens now?

```

Array Accessors
---------------

The array accessors have a couple of special powers themselves.

In addition to the normal getter/setter behavior of the regular
accessors, array accessors offer indexing variations of the getters and
setters:

```javascript

var obj = accessorize({
    arrayProperty = ["hello", "world"]
});

//indexing getter
var item = obj.arrayProperty(1);
alert(item); // alerts: "world"

//indexing setter
obj.arrayProperty(0,"goodbye");
alert(obj.arrayProperty(0)); // alerts: "goodbye"

```

Finally, array accessors surface the standard array methods directly on
the accessor object itself. This lets array accessors be used a lot like
an array would be in many cases. It also provides change notification if
any of the mutator methods are called.

**A not-really-all-that-exciting example:**

```javascript

//You can do this:

var combined = obj.arrayProperty.concat([1,2,3]);

//instead of this:

var combined = obj.arrayProperty().concat([1,2,3]);

```

**A more exciting example:**

_The mutator methods are more interesting, since we get change
notifications when they are called._

```javascript

var obj = accessorize({
    arrayProperty = ["hello", "world"]
});

obj.arrayProperty.subscribe(function(){ alert("Changed!"); });

obj.arrayProperty.sort() // alerts: "Changed!"

```

The following [methods](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array) are promoted to the accessor:

**Causes Change Notification:**

  * pop
  * push
  * reverse
  * shift
  * sort
  * splice
  * unshift

**No Change to Property Value:**

  * concat
  * join
  * slice
  * indexOf *
  * lastIndexOf *

_* These methods are not natively provided by some browsers (IE up to 8). When they are not available, they are not promoted; but if they are patched in with a polyfill prior to accessorizing an object they will be promoted._

Setter Chaining
---------------

Setter calls can be chained, enabling nicely formatted chunks of code:

```javascript

var person = accessorize({
    addresses : [],
    firstName : "",
    lastName : "",
    favoriteColor : ""
});

//Here it is, beautiful assignment blocks!
person
    .firstName("Joe")
    .lastName("Blow")
    .addresses(["123 Any Street", "58 Ave. Q"])
    .favoriteColor("Red");

//Wasn't that nice?

```

Underscore.js Integration
-------------------------

Underscore integration opens up a whole universe of helpful
functionality on your data. See: [underscore.js](http://documentcloud.github.com/underscore/)

If underscore is passed into an accessor it will return an underscore wrapped instance of the property value:

`obj.arrayProperty(_).pluck('blah')`

If underscore.string is loaded:

`obj.stringProperty(_).chain().trim().capitalize().value()`

Also, if the accessor is an Array accessor, you can retrieve an
underscore wrapped instance at a given index:

`obj.arrayProperty(1,_).trim()`


Identify Accessorized Objects
-----------------------------

`isAccessorized()` is available so that you can
identify which of your objects have been accessorized.

```javascript

var source = {
    propertyOne : "value",
    propertyTwo : "another value"
}

if (accessorize.isAccessorized(source)) {
    alert("This doesn't happen!");
}

var obj = accessorize(source);

if (accessorize.isAccessorized(obj)) {
    alert("But this does!");
}

```

If an object _is_ accessorized, `isAccessorized()` returns an object
with a `kind` property: `'object'` if the accessorized object is a
wrapped object, `'accessor'` if it is an accessor.


JSON Serialization
------------------

Care has been taken, and `toJSON()` methods written, to ensure that your
accessorized objects will serialize to JSON like you'd expect.

```javascript

var person = accessorize({
    addresses : ["123 any st.", "345 another ave."],
    firstName : "Joe",
    lastName : "Blow"
});

console.log(JSON.stringify(person))
//{"addresses":["123 any st.","345 another ave."],"firstName":"Joe","lastName":"Blow"}

```


"Why Accessor Methods? I thought ES5 has Properties already."
-------------------------------------------------------------

Two main reasons:

  1. Accessorize has what devs need, now, even in non-ES5 environments.
  2. The "JQuery-Style" Accessor Methods not only provide nice
     getter/setter syntax, but they also provide a nice place to hange
     meta-data and functions. Things like our `subscribe()` method have a
     nicer home than they could otherwise.

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

