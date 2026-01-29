# Interfaces

Tlang supports interfaces for polymorphism and abstraction, similar to Go's interfaces.

## Interface Definition

Define an interface with required methods:

```tl
interface Shape {
    Area() float;
    Perimeter() float;
}
```

## Interface Implementation

A struct automatically implements an interface if it has all required methods:

```tl
nirmanam Rectangle {
    width float;
    height float;
}

// Rectangle implements Shape interface by having these methods:
#Rectangle_Area(rect *Rectangle) float {
    mallinchu rect.width * rect.height;
}

#Rectangle_Perimeter(rect *Rectangle) float {
    mallinchu 2.0 * (rect.width + rect.height);
}
```

## Automatic Interface Satisfaction Checking ⭐ **NEW**

The compiler automatically checks if a struct satisfies an interface:

- ✅ **Automatic checking**: No explicit `implements` keyword needed
- ✅ **Compile-time verification**: Errors if struct doesn't have all required methods
- ✅ **Method signature matching**: Parameters and return types must match exactly

**Example:**

```tl
interface Writer {
    Write(data string) int;
}

nirmanam FileWriter {
    filename string;
}

// This will cause a compile error if Rectangle_Write doesn't exist:
// Error: Struct FileWriter does not satisfy interface Writer
// Missing method: Write(data string) int
```

## Automatic Vtable Generation ⭐ **NEW**

When a struct satisfies an interface, the compiler automatically:

1. **Generates a vtable** (virtual function table) for the struct-interface pair
2. **Creates a constructor function** to convert struct to interface

**Example:**

```tl
interface Shape {
    Area() float;
}

nirmanam Circle {
    radius float;
}

#Circle_Area(circle *Circle) float {
    mallinchu 3.14159 * circle.radius * circle.radius;
}

#prarambham() {
    @circle Circle = Circle{radius: 5.0};
    
    // Automatically generated: Shape* NewCircle_Shape(Circle* s)
    @shape Shape* = NewCircle_Shape(&circle);
    
    // Call method via vtable
    @area float = shape->vtable->Area(shape->data);
}
```

## Interface Embedding ⭐ **NEW**

Interfaces can embed other interfaces, similar to Go:

```tl
interface Reader {
    Read() string;
}

interface Writer {
    Write(data string) int;
}

// ReadWriter embeds both Reader and Writer
interface ReadWriter {
    interface Reader;  // Embed Reader interface
    interface Writer;  // Embed Writer interface
    Close();           // Additional method
}
```

A struct that implements `ReadWriter` must implement:
- All methods from `Reader`
- All methods from `Writer`
- The `Close()` method

**Example:**

```tl
nirmanam File {
    filename string;
}

#File_Read(file *File) string {
    // ... read implementation
}

#File_Write(file *File, data string) int {
    // ... write implementation
}

#File_Close(file *File) {
    // ... close implementation
}

// File automatically implements ReadWriter because it has all required methods
```

## Interface Method Calls via Vtable ⭐ **NEW**

Interface method calls use vtables for polymorphism:

```tl
interface Drawable {
    Draw();
}

nirmanam Circle { radius float; }
nirmanam Square { side float; }

#Circle_Draw(circle *Circle) {
    fmt.Printf("Drawing circle with radius %f\n", circle.radius);
}

#Square_Draw(square *Square) {
    fmt.Printf("Drawing square with side %f\n", square.side);
}

#drawShape(shape Drawable*) {
    // Method call via vtable
    shape->vtable->Draw(shape->data);
}

#prarambham() {
    @circle Circle = Circle{radius: 5.0};
    @square Square = Square{side: 10.0};
    
    @circleShape Drawable* = NewCircle_Drawable(&circle);
    @squareShape Drawable* = NewSquare_Drawable(&square);
    
    drawShape(circleShape);  // Calls Circle_Draw
    drawShape(squareShape);  // Calls Square_Draw
}
```

## Best Practices

### 1. Keep Interfaces Small

```tl
// Good: Small, focused interface
interface Reader {
    Read() string;
}

// Bad: Too many methods
interface Everything {
    Read() string;
    Write(data string) int;
    Close();
    Open();
    Seek(pos int);
    // ... too many methods
}
```

### 2. Use Descriptive Names

```tl
// Good
interface Shape {
    Area() float;
}

// Bad
interface S {
    A() float;
}
```

### 3. Prefer Composition over Large Interfaces

```tl
// Good: Compose smaller interfaces
interface Reader { Read() string; }
interface Writer { Write(data string) int; }
interface ReadWriter {
    interface Reader;
    interface Writer;
}

// Bad: One large interface
interface ReadWriter {
    Read() string;
    Write(data string) int;
    // ... many more methods
}
```

## Examples

### Example 1: Basic Interface

```tl
samooham adhi;

dhimpu "fmt";

interface Animal {
    Speak() string;
    Move() string;
}

nirmanam Dog {
    name string;
}

nirmanam Cat {
    name string;
}

#Dog_Speak(dog *Dog) string {
    mallinchu fmt.Sprintf("%s says: Woof!", dog.name);
}

#Dog_Move(dog *Dog) string {
    mallinchu fmt.Sprintf("%s runs", dog.name);
}

#Cat_Speak(cat *Cat) string {
    mallinchu fmt.Sprintf("%s says: Meow!", cat.name);
}

#Cat_Move(cat *Cat) string {
    mallinchu fmt.Sprintf("%s walks", cat.name);
}

#prarambham() {
    @dog Dog = Dog{name: "Buddy"};
    @cat Cat = Cat{name: "Whiskers"};
    
    @dogAnimal Animal* = NewDog_Animal(&dog);
    @catAnimal Animal* = NewCat_Animal(&cat);
    
    fmt.Printf("%s\n", dogAnimal->vtable->Speak(dogAnimal->data));
    fmt.Printf("%s\n", catAnimal->vtable->Speak(catAnimal->data));
}
```

### Example 2: Interface Embedding

```tl
interface Reader {
    Read() string;
}

interface Writer {
    Write(data string) int;
}

interface ReadWriter {
    interface Reader;
    interface Writer;
}

nirmanam Buffer {
    data string;
}

#Buffer_Read(buf *Buffer) string {
    mallinchu buf.data;
}

#Buffer_Write(buf *Buffer, data string) int {
    buf.data = data;
    mallinchu len(data);
}

// Buffer automatically implements ReadWriter
```

## Implementation Details

### Vtable Structure

Each interface has a vtable structure:

```c
typedef struct Shape_vtable {
    float (*Area)(void*);
    float (*Perimeter)(void*);
} Shape_vtable;

typedef struct Shape {
    Shape_vtable* vtable;
    void* data;  // Pointer to implementing struct
} Shape;
```

### Automatic Vtable Generation

For each struct-interface pair, the compiler generates:

1. **Static vtable**: Contains function pointers to struct methods
2. **Constructor function**: `NewStructName_InterfaceName(struct* s) -> Interface*`

### Interface Satisfaction Algorithm

1. For each interface method, check if struct has matching method
2. Method name format: `StructName_MethodName`
3. Verify parameter count and types match
4. Verify return type matches
5. If all methods found, generate vtable

## See Also

- `docs/type-system.md` - Type system documentation
- `examples/interface_example.tl` - Basic interface example
- `examples/interface_polymorphism_example.tl` - Polymorphism example
