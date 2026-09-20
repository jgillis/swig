# pyright: strict, reportUnnecessaryTypeIgnoreComment=true
from typing import List
import python_pyi_parameters as m

size: int = m.size1()
compact: int = m.compact(2)
plain: str = m.plain()
keyword: int = m.keywords(value=2)
grouped: int = m.grouped(["a", "b"])
output: int = m.output()
combined: List[int] = m.combined(2)
default_output: List[int] = m.combined_default()
w = m.Widget()
member: int = w.size1()
named: int = w.keyword(value=3)
static: int = m.Widget.make(3)

m.size1(1)  # type: ignore
m.compact("wrong")  # type: ignore
m.compact(1, 2, 3)  # type: ignore
m.compact(value=1)  # type: ignore
m.plain(3)  # type: ignore
m.keywords(unknown=1)  # type: ignore
m.grouped(3)  # type: ignore
m.output(1)  # type: ignore
wrong_output: str = m.combined_default()  # type: ignore
w.size1(1)  # type: ignore
w.keyword(value="wrong")  # type: ignore
m.Widget.make("wrong")  # type: ignore
m.Widget("wrong")  # type: ignore
