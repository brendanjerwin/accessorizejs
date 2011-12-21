define ["src/accessorize.js"], (acc) ->
  describe "setter chaining", ->
    obj = undefined

    beforeEach ->
      obj = acc
        property_one : ""
        property_two : []
        property_three : ""

    it 'should return the wrapped object from the setter', ->
      expect(obj.property_one("foo")).to.eql(obj)
      expect(obj.property_two([])).to.eql(obj)
      expect(obj.property_two(0, "bar")).to.eql(obj)

    it 'should allow a chaining syntax', ->
      expect(-> obj.property_one("foo").property_two(0,"bar").property_three("baz") ).not.to.throw()

