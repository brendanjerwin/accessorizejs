define ["src/accessorize"], (acc) ->
  describe "setter chaining", ->
    obj = undefined

    beforeEach ->
      obj = acc
        property_one : ""
        property_two : []
        property_three : ""

    it 'should return the wrapped object from the setter', ->
      expect(obj.property_one("foo")).toBe(obj)
      expect(obj.property_two([])).toBe(obj)
      expect(obj.property_two(0, "bar")).toBe(obj)

    it 'should allow a chaining syntax', ->
      expect(-> obj.property_one("foo").property_two(0,"bar").property_three("baz") ).not.toThrow()

