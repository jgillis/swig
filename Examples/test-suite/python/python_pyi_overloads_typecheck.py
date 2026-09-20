# pyright: strict, reportUnnecessaryTypeIgnoreComment=true
from typing import Union
from python_pyi_overloads import Choice, choose, compact, conflicting, defaults, duplicate, multi, produced

mapped: int = multi(["a", "b"])
floating: float = multi(2.5)
n: int = choose(3)
s: str = choose("hello")
a: int = defaults(2)
b: int = compact(2)
c: int = produced(2)
d: float = produced("hello")
e: int = duplicate(3)
f: Union[int, str] = conflicting(3)
instance = Choice(3)
g: int = instance.pick(3)
h: str = instance.pick("hello")
i: str = Choice.build("hello")
other = Choice("abc")

choose([])  # type: ignore
choose(n=3)  # type: ignore
wrong: int = choose("hello")  # type: ignore
wrong_output: str = produced(2)  # type: ignore
Choice([])  # type: ignore
instance.pick([])  # type: ignore
Choice.build([])  # type: ignore
