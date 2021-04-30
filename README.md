## Interface-utils
A small powerful library that will allow you to really get control over your VyScript interfaces. `CLIENT-SIDE ONLY`  

Download everything inside the `lib` folder and import it into your project.

# API  
### Dragging
#### Make an interface draggable  
```ts
Interface
  Element
    var dragOptions = { 'draggable': true }
```
This will allow this element to be dragged around from its defined [`width`](https://www.vylocity.com/resources/docs/Diob/width.html) and [`height`](https://www.vylocity.com/resources/docs/Diob/height.html) dimensions as long as it has a [`mouseOpacity`](https://www.vylocity.com/resources/docs/Diob/mouseOpacity.html) value that is above `0`.

#### Make a child element follow a parent element when dragging
```ts
Interface
  ParentElement
    var dragOptions = { 'draggable': true, 'parent': true } // can only be one per Interface

  ChildElement
    var parentElement = 'parentelement' // ParentElement.name

  Element
    var dragOptions = { 'draggable': true }
  ```
  When `ParentElement` is dragged, wherever `ChildElement` is in relation to `ParentElement` it will be dragged along with it.  

  `ChildElement` must exist in the same `Interface` file as `ParentElement`.  

  There can only be one element with `dragOptions.parent` enabled per `Interface` but an unlimited number of elements can have `parentElement` enabled.

#### Make a title-bar

```ts
Interface
  Element
    var dragOptions = { 'draggable': true, 'titlebar': { 'width': 100, 'height': 30 } }
```

This will enable a `virtual` title-bar on the element. Meaning the element will only be able to be dragged from this `virtual` title-bar. The origin of the element is it's top-left corner; so `100` pixels to the right and `30` pixels down defines the `virtual` title-bar for this element grabbing the element from within those values will let you drag it.

#### Can i move the title-bar's origin?

```js
Interface
  Element
    var dragOptions = { 'draggable': true, 'titlebar': { 'width': 100, 'height': 30, 'xPos': 50, 'yPos': 50 } }
```

Yes you can! Using `dragOptions.titlebar.xPos` and `dragOptions.titlebar.yPos`. These specify the origin position of the element. Using the above mentioned values of `50` for `dragOptions.titlebar.xPos` and `50` for `dragOptions.titlebar.yPos` will effectively offset the bounds of this element to the right `50` pixels and down `50` pixels.


### More to come 🚧🚧
