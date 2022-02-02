# Chapter 1 Highlights

## Structs

A struct is used to generate a class defined by variables:

```ruby
Point = Struct.new(:x, :y)

Point.new(1, 2) # => #<struct Point x = 1, y = 2> 
```

It comes preloaded with getters, setters and a method for equality.

