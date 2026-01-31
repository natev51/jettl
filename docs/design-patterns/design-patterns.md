### Decorator Pattern

**Class Inheritance to SPaIC**

SPaIC: Subtype Polymorphism and Interface Composition

![](../images/dec_1.jpeg)
![](../images/dec_2.jpeg)
![](../images/dec_3.jpeg)

---

AF Static Class Inheritance
Panel Actor
Actor
Your Actor

jettl Dynamic Decorator Pattern
Note you can swap around the Way these are wrapped!
Your Actor
Panel Actor
Actor

---

### State Pattern

**Resources**:
[State Pattern – Design Patterns (ep 17)](https://www.youtube.com/watch?v=N12L5D78MAA)
[State of Grace - The State Pattern in LabVIEW](https://www.youtube.com/watch?v=HewNBC4TjKs)
[Powerful Design with the Gang of Four - Tom McQuillan and Sam Taggart](https://www.youtube.com/watch?v=IM8ZU1af6wQ&list=PLvDxiIkwuMQsxPk5KC9B1kdJboV-9GJKh&index=22)
[A Class Act: Simple Design Patterns to Improve Code Quality, Allen C Smith - GDevCon N.A. 2023](https://www.youtube.com/watch?v=GRDoyn1mNAI&list=PLvDxiIkwuMQtGtstTGKpYpoMVi1Lj07EP&index=18)
[A Class Act - Allen C Smith(JustACS) - GDevCon#4](https://www.youtube.com/watch?v=yVzT5ZqUuVU&list=PLvDxiIkwuMQtGtstTGKpYpoMVi1Lj07EP&index=19)

State must not be modified in `Entry.vi`. Disallowing state transitions in both `Entry.vi` and `Exit.vi` is intentional. A state must be fully entered or fully exited before a transition is permitted. This constraint prevents infinite state transitions and enforces a well defined state lifecycle.