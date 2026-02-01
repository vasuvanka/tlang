// Test struct literals Person{} / Person{ field: value } and nirmanam(Map) for maps
nirmanam Person {
    name string;
    age int;
}

#prarambham() {
    @person *Person = Person{ name: "Alice", age: 30 }
    okavela person == sunyam {
        mallinchu
    }
    sunyam(person)

    @m jatha[string]int = nirmanam(jatha[string]int)
    okavela m == sunyam {
        mallinchu
    }
    sunyam(m)
}
